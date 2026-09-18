-- ==============================================================================
-- TRANSPORT OPERATION SYSTEM (FreightOps) — Production Schema
-- Database: PostgreSQL (Supabase)
-- ==============================================================================

-- 1. VEHICLES TABLE
CREATE TABLE IF NOT EXISTS public.vehicles (
    id TEXT PRIMARY KEY,
    vehicle_number TEXT UNIQUE NOT NULL,
    vehicle_type TEXT NOT NULL,
    capacity TEXT NOT NULL, -- '20 FT' or '40 FT'
    status TEXT NOT NULL DEFAULT 'AVAILABLE', -- 'AVAILABLE', 'ON_TRIP', 'MAINTENANCE', 'INACTIVE'
    assigned_driver_id TEXT,
    assigned_driver_name TEXT,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. DRIVERS TABLE
CREATE TABLE IF NOT EXISTS public.drivers (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    mobile_number TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'AVAILABLE', -- 'AVAILABLE', 'ON_TRIP', 'OFF_DUTY', 'INACTIVE'
    current_vehicle_id TEXT,
    current_vehicle_number TEXT,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 3. PARTIES / CUSTOMERS TABLE
CREATE TABLE IF NOT EXISTS public.parties (
    id TEXT PRIMARY KEY,
    party_name TEXT NOT NULL,
    customer_mobile TEXT NOT NULL,
    email TEXT DEFAULT '',
    city TEXT DEFAULT '',
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 4. SHIPPING LINES TABLE
CREATE TABLE IF NOT EXISTS public.shipping_lines (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    code TEXT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 5. LOCATIONS TABLE
CREATE TABLE IF NOT EXISTS public.locations (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    location_type TEXT NOT NULL, -- 'CUSTOMER', 'FACTORY', 'WAREHOUSE', 'PORT', 'CFS', 'OTHER'
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 6. PORT / CFS TABLE
CREATE TABLE IF NOT EXISTS public.ports_cfs (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    type TEXT NOT NULL, -- 'PORT', 'CFS'
    location TEXT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 7. TRANSPORTS TABLE
CREATE TABLE IF NOT EXISTS public.transports (
    id TEXT PRIMARY KEY,
    transport_number TEXT NOT NULL,
    booking_number TEXT NOT NULL,
    container_number TEXT NOT NULL,
    seal_number TEXT NOT NULL,
    container_size TEXT NOT NULL, -- '20 FT', '40 FT'
    shipment_type TEXT NOT NULL, -- 'EXPORT', 'IMPORT'
    
    party_id TEXT REFERENCES public.parties(id) ON DELETE RESTRICT,
    party_name TEXT NOT NULL,
    booking_party_id TEXT REFERENCES public.parties(id) ON DELETE RESTRICT,
    booking_party_name TEXT NOT NULL,
    shipping_line_id TEXT REFERENCES public.shipping_lines(id) ON DELETE RESTRICT,
    shipping_line_name TEXT NOT NULL,
    
    from_location_id TEXT REFERENCES public.locations(id) ON DELETE RESTRICT,
    from_location_name TEXT NOT NULL,
    to_location_id TEXT REFERENCES public.locations(id) ON DELETE RESTRICT,
    to_location_name TEXT NOT NULL,
    port_cfs_id TEXT REFERENCES public.ports_cfs(id) ON DELETE RESTRICT,
    port_cfs_name TEXT NOT NULL,
    
    vehicle_id TEXT REFERENCES public.vehicles(id) ON DELETE SET NULL,
    vehicle_number TEXT,
    driver_id TEXT REFERENCES public.drivers(id) ON DELETE SET NULL,
    driver_name TEXT,
    driver_mobile TEXT,
    
    status TEXT NOT NULL DEFAULT 'NEW',
    exception_reason TEXT,
    
    vehicle_reported_at TIMESTAMPTZ,
    container_picked_up_at TIMESTAMPTZ,
    in_transit_at TIMESTAMPTZ,
    at_port_cfs_at TIMESTAMPTZ,
    container_delivered_at TIMESTAMPTZ,
    pod_received_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 8. STATUS HISTORY TABLE
CREATE TABLE IF NOT EXISTS public.transport_status_history (
    id TEXT PRIMARY KEY,
    transport_id TEXT NOT NULL REFERENCES public.transports(id) ON DELETE CASCADE,
    status TEXT NOT NULL,
    remarks TEXT,
    changed_by TEXT NOT NULL DEFAULT 'Super Admin',
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 9. VEHICLE ASSIGNMENTS (WITH SERVER-SIDE CONCURRENCY RULE)
CREATE TABLE IF NOT EXISTS public.vehicle_assignments (
    id TEXT PRIMARY KEY,
    transport_id TEXT NOT NULL REFERENCES public.transports(id) ON DELETE CASCADE,
    vehicle_id TEXT NOT NULL REFERENCES public.vehicles(id) ON DELETE RESTRICT,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    assigned_by TEXT NOT NULL DEFAULT 'Super Admin',
    released_at TIMESTAMPTZ,
    is_active BOOLEAN NOT NULL DEFAULT true
);

-- Enforce: One vehicle cannot be actively assigned to multiple transports
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_active_vehicle_assignment
ON public.vehicle_assignments (vehicle_id)
WHERE is_active = true;

-- 10. DRIVER ASSIGNMENTS (WITH SERVER-SIDE CONCURRENCY RULE)
CREATE TABLE IF NOT EXISTS public.driver_assignments (
    id TEXT PRIMARY KEY,
    transport_id TEXT NOT NULL REFERENCES public.transports(id) ON DELETE CASCADE,
    driver_id TEXT NOT NULL REFERENCES public.drivers(id) ON DELETE RESTRICT,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    assigned_by TEXT NOT NULL DEFAULT 'Super Admin',
    released_at TIMESTAMPTZ,
    is_active BOOLEAN NOT NULL DEFAULT true
);

-- Enforce: One driver cannot be actively assigned to multiple transports
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique_active_driver_assignment
ON public.driver_assignments (driver_id)
WHERE is_active = true;

-- 11. NOTIFICATION LOGS TABLE
CREATE TABLE IF NOT EXISTS public.notification_logs (
    id TEXT PRIMARY KEY,
    transport_id TEXT NOT NULL REFERENCES public.transports(id) ON DELETE CASCADE,
    party_id TEXT,
    recipient_name TEXT NOT NULL,
    recipient_mobile TEXT NOT NULL,
    channel TEXT NOT NULL DEFAULT 'WhatsApp', -- 'WhatsApp', 'SMS'
    message_body TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'READY', -- 'READY', 'SENT', 'FAILED', 'NOT_CONFIGURED'
    sent_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 12. POD DOCUMENTS TABLE
CREATE TABLE IF NOT EXISTS public.pod_documents (
    id TEXT PRIMARY KEY,
    transport_id TEXT NOT NULL REFERENCES public.transports(id) ON DELETE CASCADE,
    file_name TEXT NOT NULL,
    storage_path TEXT NOT NULL,
    file_type TEXT NOT NULL, -- 'PDF', 'IMAGE'
    file_size BIGINT NOT NULL,
    uploaded_by TEXT NOT NULL DEFAULT 'Super Admin',
    uploaded_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    file_url TEXT
);

-- 13. ACTIVITY / AUDIT LOGS TABLE
CREATE TABLE IF NOT EXISTS public.activity_logs (
    id TEXT PRIMARY KEY,
    transport_id TEXT,
    user_id TEXT,
    action TEXT NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ==============================================================================
-- INDEXES FOR FREQUENTLY QUERIED FIELDS
-- ==============================================================================
CREATE INDEX IF NOT EXISTS idx_transports_status ON public.transports (status);
CREATE INDEX IF NOT EXISTS idx_transports_created_at ON public.transports (created_at DESC);
CREATE INDEX IF NOT EXISTS idx_transports_booking_number ON public.transports (booking_number);
CREATE INDEX IF NOT EXISTS idx_transports_container_number ON public.transports (container_number);
CREATE INDEX IF NOT EXISTS idx_transports_vehicle_id ON public.transports (vehicle_id);
CREATE INDEX IF NOT EXISTS idx_transports_driver_id ON public.transports (driver_id);
CREATE INDEX IF NOT EXISTS idx_transports_party_id ON public.transports (party_id);

CREATE INDEX IF NOT EXISTS idx_vehicles_status ON public.vehicles (status);
CREATE INDEX IF NOT EXISTS idx_vehicles_number ON public.vehicles (vehicle_number);
CREATE INDEX IF NOT EXISTS idx_drivers_status ON public.drivers (status);
CREATE INDEX IF NOT EXISTS idx_drivers_mobile ON public.drivers (mobile_number);
CREATE INDEX IF NOT EXISTS idx_parties_name ON public.parties (party_name);

-- ==============================================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ==============================================================================
ALTER TABLE public.vehicles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.drivers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.parties ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.shipping_lines ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.locations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ports_cfs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.transport_status_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vehicle_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.driver_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notification_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pod_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.activity_logs ENABLE ROW LEVEL SECURITY;

-- Allow authenticated users to perform all operations within the business
CREATE POLICY "Authenticated users full access vehicles" ON public.vehicles FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users full access drivers" ON public.drivers FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users full access parties" ON public.parties FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users full access shipping_lines" ON public.shipping_lines FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users full access locations" ON public.locations FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users full access ports_cfs" ON public.ports_cfs FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users full access transports" ON public.transports FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users full access transport_status_history" ON public.transport_status_history FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users full access vehicle_assignments" ON public.vehicle_assignments FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users full access driver_assignments" ON public.driver_assignments FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users full access notification_logs" ON public.notification_logs FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users full access pod_documents" ON public.pod_documents FOR ALL TO authenticated USING (true) WITH CHECK (true);
CREATE POLICY "Authenticated users full access activity_logs" ON public.activity_logs FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ==============================================================================
-- STORAGE BUCKET FOR POD DOCUMENTS
-- ==============================================================================
INSERT INTO storage.buckets (id, name, public)
VALUES ('pod-documents', 'pod-documents', false)
ON CONFLICT (id) DO NOTHING;

-- Policy to allow authenticated users to view POD files
CREATE POLICY "Allow authenticated read pod documents"
ON storage.objects FOR SELECT TO authenticated
USING (bucket_id = 'pod-documents');

-- Policy to allow authenticated users to upload POD files
CREATE POLICY "Allow authenticated upload pod documents"
ON storage.objects FOR INSERT TO authenticated
WITH CHECK (bucket_id = 'pod-documents');
