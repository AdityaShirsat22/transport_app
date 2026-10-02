-- ==============================================================================
-- MIGRATION: 20261002_fix_allocations_and_container_fields.sql
-- Description:
--   1. Ensure transport_allocations table exists with ALL required columns
--      including container_number and seal_number (may be missing if the
--      previous migration was not fully applied).
--   2. Remove the unique partial index on vehicle_assignments that blocks
--      multi-slot transport allocations from syncing (multiple vehicles can
--      be active on the same transport across different slots).
--   3. Add a unique constraint on transport_allocations (transport_id, slot_index)
--      so duplicate slots cannot be created per transport.
--   4. Drop the NOT NULL constraints on transports.container_number and
--      transports.seal_number (they are now managed at allocation slot level).
-- ==============================================================================

-- 1. ENSURE transport_allocations TABLE EXISTS WITH ALL COLUMNS
CREATE TABLE IF NOT EXISTS public.transport_allocations (
    id TEXT PRIMARY KEY,
    transport_id TEXT NOT NULL REFERENCES public.transports(id) ON DELETE CASCADE,
    slot_index INTEGER NOT NULL DEFAULT 0,
    vehicle_id TEXT NOT NULL REFERENCES public.vehicles(id) ON DELETE RESTRICT,
    vehicle_number TEXT NOT NULL,
    driver_id TEXT REFERENCES public.drivers(id) ON DELETE SET NULL,
    driver_name TEXT,
    driver_mobile TEXT,
    container_number TEXT,
    seal_number TEXT,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. ADD MISSING COLUMNS IF TABLE ALREADY EXISTS (idempotent)
ALTER TABLE public.transport_allocations ADD COLUMN IF NOT EXISTS container_number TEXT;
ALTER TABLE public.transport_allocations ADD COLUMN IF NOT EXISTS seal_number TEXT;
ALTER TABLE public.transport_allocations ADD COLUMN IF NOT EXISTS driver_mobile TEXT;

-- 3. ADD UNIQUE CONSTRAINT ON (transport_id, slot_index) IF NOT EXISTS
-- This enables proper upsert (ON CONFLICT) per slot.
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'uq_transport_allocations_transport_slot'
  ) THEN
    ALTER TABLE public.transport_allocations
      ADD CONSTRAINT uq_transport_allocations_transport_slot
      UNIQUE (transport_id, slot_index);
  END IF;
END $$;

-- 4. REMOVE THE BLOCKING UNIQUE INDEX ON vehicle_assignments
-- This constraint prevents multiple active vehicle assignments across different
-- transport slots for the same vehicle. With multi-slot allocations stored in
-- transport_allocations, the vehicle_assignments table is only used for audit
-- history, and this hard constraint silently fails slot 2+ sync items.
DROP INDEX IF EXISTS public.idx_unique_active_vehicle_assignment;
DROP INDEX IF EXISTS idx_unique_active_vehicle_assignment;

-- 5. SIMILARLY REMOVE THE BLOCKING INDEX ON driver_assignments
DROP INDEX IF EXISTS public.idx_unique_active_driver_assignment;
DROP INDEX IF EXISTS idx_unique_active_driver_assignment;

-- 6. MAKE container_number / seal_number NULLABLE ON transports TABLE
-- (Now managed per-slot in transport_allocations)
ALTER TABLE public.transports ALTER COLUMN container_number DROP NOT NULL;
ALTER TABLE public.transports ALTER COLUMN container_number SET DEFAULT '';
ALTER TABLE public.transports ALTER COLUMN seal_number DROP NOT NULL;
ALTER TABLE public.transports ALTER COLUMN seal_number SET DEFAULT '';

-- 7. PERFORMANCE INDEXES (idempotent)
CREATE INDEX IF NOT EXISTS idx_transport_allocations_transport_id
  ON public.transport_allocations (transport_id);
CREATE INDEX IF NOT EXISTS idx_transport_allocations_vehicle_id
  ON public.transport_allocations (vehicle_id);
CREATE INDEX IF NOT EXISTS idx_transport_allocations_driver_id
  ON public.transport_allocations (driver_id);
CREATE INDEX IF NOT EXISTS idx_transport_allocations_slot
  ON public.transport_allocations (transport_id, slot_index);

-- 8. ROW LEVEL SECURITY (idempotent)
ALTER TABLE public.transport_allocations ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'transport_allocations'
      AND policyname = 'Authenticated users full access transport_allocations'
  ) THEN
    CREATE POLICY "Authenticated users full access transport_allocations"
    ON public.transport_allocations FOR ALL TO authenticated USING (true) WITH CHECK (true);
  END IF;

  -- Allow anonymous users full access (Coordinator and Driver login use PIN with anon role)
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'transport_allocations'
      AND policyname = 'Anon users full access transport_allocations'
  ) THEN
    CREATE POLICY "Anon users full access transport_allocations"
    ON public.transport_allocations FOR ALL TO anon USING (true) WITH CHECK (true);
  END IF;
END $$;

-- 9. ENABLE REALTIME REPLICATION (Optional)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_publication_tables
    WHERE pubname = 'supabase_realtime'
      AND tablename = 'transport_allocations'
  ) THEN
    ALTER PUBLICATION supabase_realtime ADD TABLE public.transport_allocations;
  END IF;
EXCEPTION
  WHEN OTHERS THEN NULL;
END $$;
