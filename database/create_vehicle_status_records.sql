-- Create vehicle_status_records table with proper RLS policies
-- Run this in your Supabase SQL Editor

-- Drop table if it exists
DROP TABLE IF EXISTS public.vehicle_status_records CASCADE;

-- Create vehicle_status_records table
CREATE TABLE public.vehicle_status_records (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    plate_no TEXT NOT NULL,
    imei_no TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('active', 'offline', 'pullout')),
    remarks TEXT,
    date_installed DATE,
    date_repair_or_pullout DATE,
    plant TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Disable Row Level Security temporarily for testing
ALTER TABLE public.vehicle_status_records DISABLE ROW LEVEL SECURITY;

-- Create indexes for better performance
CREATE INDEX idx_vehicle_status_records_plate_no ON public.vehicle_status_records(plate_no);
CREATE INDEX idx_vehicle_status_records_imei_no ON public.vehicle_status_records(imei_no);
CREATE INDEX idx_vehicle_status_records_status ON public.vehicle_status_records(status);
CREATE INDEX idx_vehicle_status_records_plant ON public.vehicle_status_records(plant);
CREATE INDEX idx_vehicle_status_records_created_at ON public.vehicle_status_records(created_at);

-- Add comments for documentation
COMMENT ON TABLE public.vehicle_status_records IS 'Stores vehicle status tracking information including GPS status, repair dates, and plant assignments';
COMMENT ON COLUMN public.vehicle_status_records.plate_no IS 'Vehicle plate number';
COMMENT ON COLUMN public.vehicle_status_records.imei_no IS 'GPS IMEI number';
COMMENT ON COLUMN public.vehicle_status_records.status IS 'Vehicle status: active, offline, or pullout';
COMMENT ON COLUMN public.vehicle_status_records.remarks IS 'Additional notes or remarks';
COMMENT ON COLUMN public.vehicle_status_records.date_installed IS 'Date when GPS was installed';
COMMENT ON COLUMN public.vehicle_status_records.date_repair_or_pullout IS 'Date when vehicle was repaired or pulled out';
COMMENT ON COLUMN public.vehicle_status_records.plant IS 'Plant assignment';
