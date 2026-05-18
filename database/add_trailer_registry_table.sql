-- Add missing trailer_registry table
DROP TABLE IF EXISTS public.trailer_registry CASCADE;

CREATE TABLE public.trailer_registry (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    plate_no TEXT UNIQUE NOT NULL,
    chassis_no TEXT,
    container TEXT,
    status TEXT DEFAULT 'OPERATIONAL' CHECK (status IN ('OPERATIONAL', 'OPERATIONAL/HUSTLING', 'DOWN')),
    trailer_issue TEXT,
    remarks TEXT,
    trailer_type TEXT,
    gross_weight DECIMAL(10,2),
    cr_registered DATE,
    cr_expiry_date DATE,
    date_reported DATE,
    location_plant TEXT,
    mv_file_no TEXT,
    owner_name TEXT,
    year_model INTEGER,
    image1_url TEXT,
    image2_url TEXT,
    image3_url TEXT,
    image4_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.trailer_registry DISABLE ROW LEVEL SECURITY;

-- Create indexes for better performance
CREATE INDEX idx_trailer_registry_plate ON public.trailer_registry(plate_no);
CREATE INDEX idx_trailer_registry_status ON public.trailer_registry(status);

-- TRAILER REGISTRY TABLE POLICIES
DROP POLICY IF EXISTS "Enable read access for all users" ON public.trailer_registry;
DROP POLICY IF EXISTS "Enable insert for admin users only" ON public.trailer_registry;
DROP POLICY IF EXISTS "Enable update for admin users only" ON public.trailer_registry;
DROP POLICY IF EXISTS "Enable delete for admin users only" ON public.trailer_registry;

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

-- Insert sample trailer registry data
INSERT INTO public.trailer_registry (plate_no, chassis_no, container, status, trailer_issue) VALUES
('TRL-001', 'CHS-001', 'CONT-001', 'OPERATIONAL', NULL),
('TRL-002', 'CHS-002', 'CONT-002', 'OPERATIONAL/HUSTLING', 'Minor dent'),
('TRL-003', 'CHS-003', 'CONT-003', 'DOWN', 'Tire replacement needed'),
('TRL-004', 'CHS-004', 'CONT-004', 'OPERATIONAL', NULL),
('TRL-005', 'CHS-005', 'CONT-005', 'OPERATIONAL/HUSTLING', NULL);
