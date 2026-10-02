-- ==============================================================================
-- MIGRATION: 20261002_grant_anon_allocations.sql
-- Description:
--   Allow anonymous ('anon') users full access to transport_allocations.
--   Coordinator and Driver PIN logins operate under the Supabase 'anon' role.
--   This policy enables coordinators to view and update all multi-slot fleet & crew
--   allocations identically to Super Admin.
-- ==============================================================================

ALTER TABLE public.transport_allocations ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'transport_allocations'
      AND policyname = 'Anon users full access transport_allocations'
  ) THEN
    CREATE POLICY "Anon users full access transport_allocations"
    ON public.transport_allocations FOR ALL TO anon USING (true) WITH CHECK (true);
  END IF;
END $$;
