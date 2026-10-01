-- ==============================================================================
-- MIGRATION: 20261001_add_transport_allocations.sql
-- Description: Adds transport_allocations table with per-slot container_number
--              and seal_number support, updates transports table nullability,
--              and configures RLS and performance indexes.
-- ==============================================================================

-- 1. MAKE CONTAINER_NUMBER AND SEAL_NUMBER OPTIONAL ON TRANSPORTS TABLE
-- Transports can now be created with vehicle-specific containers allotted across slots.
ALTER TABLE public.transports ALTER COLUMN container_number DROP NOT NULL;
ALTER TABLE public.transports ALTER COLUMN container_number SET DEFAULT '';
ALTER TABLE public.transports ALTER COLUMN seal_number DROP NOT NULL;
ALTER TABLE public.transports ALTER COLUMN seal_number SET DEFAULT '';

-- 2. CREATE TRANSPORT_ALLOCATIONS TABLE (IF NOT EXISTS)
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

-- 3. ENSURE NEW COLUMNS EXIST (IF TABLE WAS PREVIOUSLY CREATED WITHOUT THEM)
ALTER TABLE public.transport_allocations ADD COLUMN IF NOT EXISTS container_number TEXT;
ALTER TABLE public.transport_allocations ADD COLUMN IF NOT EXISTS seal_number TEXT;

-- 4. PERFORMANCE INDEXES
CREATE INDEX IF NOT EXISTS idx_transport_allocations_transport_id ON public.transport_allocations (transport_id);
CREATE INDEX IF NOT EXISTS idx_transport_allocations_vehicle_id ON public.transport_allocations (vehicle_id);
CREATE INDEX IF NOT EXISTS idx_transport_allocations_driver_id ON public.transport_allocations (driver_id);
CREATE INDEX IF NOT EXISTS idx_transport_allocations_container_no ON public.transport_allocations (container_number);

-- 5. ROW LEVEL SECURITY (RLS) POLICIES
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
END $$;

-- 6. ENABLE REALTIME REPLICATION (Optional / Recommended for Live Sync)
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
  WHEN OTHERS THEN NULL; -- Ignore if publication doesn't exist
END $$;
