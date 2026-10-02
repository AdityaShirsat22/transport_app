-- ==============================================================================
-- MIGRATION: 20261002_coordinator_access.sql
-- Description:
--   1. Create the staff_pins table for PIN-based coordinator/driver login.
--   2. Allow anon role to SELECT from staff_pins (required to validate PIN
--      before the anonymous Supabase auth session is created).
--   3. Authenticated users (including anonymous sessions created after PIN
--      validation via signInAnonymously) already have full access via
--      existing policies on all tables — no extra grants needed.
-- ==============================================================================

-- 1. CREATE STAFF PINS TABLE (IF NOT EXISTS)
CREATE TABLE IF NOT EXISTS public.staff_pins (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    name TEXT NOT NULL,
    email TEXT,
    role TEXT NOT NULL,         -- 'Coordinator', 'Driver', etc.
    pin_code TEXT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. UNIQUE INDEX on pin_code + role (one PIN per role)
CREATE UNIQUE INDEX IF NOT EXISTS idx_staff_pins_pin_role
  ON public.staff_pins (pin_code, role)
  WHERE is_active = true;

-- 3. ROW LEVEL SECURITY
ALTER TABLE public.staff_pins ENABLE ROW LEVEL SECURITY;

-- 4. Allow authenticated users full management of staff_pins (Super Admin)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'staff_pins'
      AND policyname = 'Authenticated users full access staff_pins'
  ) THEN
    CREATE POLICY "Authenticated users full access staff_pins"
    ON public.staff_pins FOR ALL TO authenticated USING (true) WITH CHECK (true);
  END IF;
END $$;

-- 5. Allow ANONYMOUS users to SELECT from staff_pins
-- This is required so the coordinator can query the PIN table BEFORE the
-- anonymous Supabase session is created (chicken-and-egg: we need to
-- validate the PIN before we can sign in anonymously).
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'staff_pins'
      AND policyname = 'Anon users can read staff_pins for PIN validation'
  ) THEN
    CREATE POLICY "Anon users can read staff_pins for PIN validation"
    ON public.staff_pins FOR SELECT TO anon USING (true);
  END IF;
END $$;

-- NOTE: After signInAnonymously() is called in the app, the coordinator gets
-- an `authenticated` role JWT. All existing policies (e.g., "Authenticated
-- users full access transports") then apply automatically. No additional
-- policies are needed for transports, allocations, etc.
