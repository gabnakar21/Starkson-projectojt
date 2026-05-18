-- Create trailer_registry table for Vehicle Registry trailer tab
-- This table stores trailer information with all required fields

-- ============================================================
-- TRAILER REGISTRY TABLE
-- ============================================================
DROP TABLE IF EXISTS public.trailer_registry CASCADE;

CREATE TABLE public.trailer_registry (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    plate_no TEXT NOT NULL UNIQUE,
    chassis_no TEXT NOT NULL,
    mv_file_no TEXT NOT NULL,
    year_model INTEGER NOT NULL,
    owner_name TEXT NOT NULL,
    location_plant TEXT NOT NULL DEFAULT 'DISNEY 3',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.trailer_registry DISABLE ROW LEVEL SECURITY;

-- Create indexes for better performance
CREATE INDEX idx_trailer_registry_plate ON public.trailer_registry(plate_no);
CREATE INDEX idx_trailer_registry_plant ON public.trailer_registry(location_plant);

-- ROW LEVEL SECURITY POLICIES
DROP POLICY IF EXISTS "Enable read access for all users" ON public.trailer_registry;
DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.trailer_registry;
DROP POLICY IF EXISTS "Enable update for authenticated users" ON public.trailer_registry;
DROP POLICY IF EXISTS "Enable delete for authenticated users" ON public.trailer_registry;

CREATE POLICY "Enable read access for all users" ON public.trailer_registry
    FOR SELECT
    USING (true);

CREATE POLICY "Enable insert for admin users only" ON public.trailer_registry
    FOR INSERT
    WITH CHECK (is_admin_from_session());

CREATE POLICY "Enable update for admin users only" ON public.trailer_registry
    FOR UPDATE
    USING (is_admin_from_session())
    WITH CHECK (is_admin_from_session());

CREATE POLICY "Enable delete for admin users only" ON public.trailer_registry
    FOR DELETE
    USING (is_admin_from_session());

-- Create a function to automatically update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_trailer_registry_updated_at()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_trailer_registry_updated_at 
    BEFORE UPDATE ON public.trailer_registry
    FOR EACH ROW 
    EXECUTE FUNCTION update_trailer_registry_updated_at();

-- Insert sample trailer data
INSERT INTO public.trailer_registry (plate_no, chassis_no, mv_file_no, year_model, owner_name, location_plant) VALUES
('TRL-001', 'CHS-001', 'MV-001', 2020, 'John Doe Transport', 'DISNEY 3'),
('TRL-002', 'CHS-002', 'MV-002', 2021, 'Jane Smith Logistics', 'DISNEY 6'),
('TRL-003', 'CHS-003', 'MV-003', 2019, 'ABC Transport Co.', 'HASBRO'),
('TRL-004', 'CHS-004', 'MV-004', 2022, 'Speedy Delivery Inc', 'DISNEY 3'),
('TRL-005', 'CHS-005', 'MV-005', 2020, 'Fast Freight Co', 'DISNEY 6');
