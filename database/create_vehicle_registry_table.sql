-- Create vehicle_registry table
-- This script creates the vehicle_registry table that the application expects

-- Drop table if it exists to start fresh
DROP TABLE IF EXISTS public.vehicle_registry CASCADE;

-- Create vehicle_registry table
CREATE TABLE public.vehicle_registry (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    plate TEXT UNIQUE NOT NULL,
    plate_no TEXT,
    chassi_no TEXT,
    chassis_no TEXT,
    engine_no TEXT,
    mv_file_no TEXT,
    year_model INTEGER,
    year INTEGER,
    model TEXT,
    size TEXT,
    truck_size TEXT,
    color TEXT,
    type TEXT DEFAULT 'Truck',
    vehicle_type TEXT DEFAULT 'truck',
    owner_name TEXT,
    location_plant TEXT DEFAULT 'DISNEY 3',
    plant TEXT,
    registered_date DATE,
    expiration_date DATE,
    driver_name TEXT,
    gps_status TEXT DEFAULT 'Active',
    autosweep TEXT,
    easytrip TEXT,
    tire_size_front TEXT,
    tire_size_rear TEXT,
    total_tire_front INTEGER,
    total_tire_rear INTEGER,
    no_of_years INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Disable Row Level Security temporarily
ALTER TABLE public.vehicle_registry DISABLE ROW LEVEL SECURITY;

-- Create indexes for better performance
CREATE INDEX idx_vehicle_registry_plate ON public.vehicle_registry(plate);
CREATE INDEX idx_vehicle_registry_plate_no ON public.vehicle_registry(plate_no);
CREATE INDEX idx_vehicle_registry_chassis_no ON public.vehicle_registry(chassis_no);
CREATE INDEX idx_vehicle_registry_type ON public.vehicle_registry(type);
CREATE INDEX idx_vehicle_registry_plant ON public.vehicle_registry(location_plant);
CREATE INDEX idx_vehicle_registry_gps_status ON public.vehicle_registry(gps_status);

-- Create a function to automatically update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_vehicle_registry_updated_at()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_vehicle_registry_updated_at 
    BEFORE UPDATE ON public.vehicle_registry
    FOR EACH ROW 
    EXECUTE FUNCTION update_vehicle_registry_updated_at();

-- Enable Row Level Security
ALTER TABLE public.vehicle_registry ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
CREATE POLICY "Enable read access for all users" ON public.vehicle_registry
    FOR SELECT
    USING (true);

CREATE POLICY "Enable insert for admin users only" ON public.vehicle_registry
    FOR INSERT
    WITH CHECK (is_admin_from_session());

CREATE POLICY "Enable update for admin users only" ON public.vehicle_registry
    FOR UPDATE
    USING (is_admin_from_session())
    WITH CHECK (is_admin_from_session());

CREATE POLICY "Enable delete for admin users only" ON public.vehicle_registry
    FOR DELETE
    USING (is_admin_from_session());

-- Insert sample data
INSERT INTO public.vehicle_registry (
    plate, plate_no, chassi_no, chassis_no, engine_no, mv_file_no, 
    year_model, model, size, truck_size, color, type, owner_name, 
    location_plant, registered_date, expiration_date, driver_name, gps_status
) VALUES
('TRK-001', 'TRK-001', 'CHS-001', 'CHS-001', 'ENG-001', 'MVF-001', 2020, 'Isuzu', '10ft', '10ft', 'Blue', 'Truck', 'John Doe', 'DISNEY 3', '2023-01-01', '2024-01-01', 'Driver 1', 'Active'),
('TRK-002', 'TRK-002', 'CHS-002', 'CHS-002', 'ENG-002', 'MVF-002', 2021, 'Hino', '20ft', '20ft', 'Red', 'Truck', 'Jane Smith', 'DISNEY 6', '2023-02-01', '2024-02-01', 'Driver 2', 'Active'),
('TRK-003', 'TRK-003', 'CHS-003', 'CHS-003', 'ENG-003', 'MVF-003', 2019, 'Mitsubishi', '40ft', '40ft', 'Green', 'Truck', 'Bob Johnson', 'HASBRO', '2023-03-01', '2024-03-01', 'Driver 3', 'Active');

-- Verify the table structure
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'vehicle_registry' 
ORDER BY ordinal_position;
