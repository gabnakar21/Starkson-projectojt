-- Vehicle Status Table Update Script
-- Run this script in your Supabase SQL Editor

-- Step 1: Add new columns to vehicle_status table (if they don't already exist)
ALTER TABLE public.vehicle_status 
ADD COLUMN IF NOT EXISTS truck_size TEXT,
ADD COLUMN IF NOT EXISTS model TEXT,
ADD COLUMN IF NOT EXISTS year INTEGER,
ADD COLUMN IF NOT EXISTS no_of_years INTEGER;

-- Step 2: Create indexes for better performance on new columns
CREATE INDEX IF NOT EXISTS idx_vehicle_status_truck_size ON public.vehicle_status(truck_size);
CREATE INDEX IF NOT EXISTS idx_vehicle_status_model ON public.vehicle_status(model);
CREATE INDEX IF NOT EXISTS idx_vehicle_status_year ON public.vehicle_status(year);

-- Step 3: Update RLS policies to include new columns (if needed)
-- The existing policies should already cover all columns, but let's ensure they're properly set

-- Step 4: Add comments for documentation
COMMENT ON COLUMN public.vehicle_status.truck_size IS 'Truck size copied from vehicle_registry table';
COMMENT ON COLUMN public.vehicle_status.model IS 'Vehicle model copied from vehicle_registry table';
COMMENT ON COLUMN public.vehicle_status.year IS 'Vehicle year model copied from vehicle_registry table';
COMMENT ON COLUMN public.vehicle_status.no_of_years IS 'Number of years - manually entered, nullable';

-- Verify the table structure
-- You can run this to see the updated structure:
