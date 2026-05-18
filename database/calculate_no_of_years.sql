-- Calculate and Update No. of Years Column
-- This script calculates the number of years from vehicle year to current year (2026)
-- Run this script in your Supabase SQL Editor

-- Step 1: Update vehicle_status table with calculated no_of_years
-- First, let's update existing records by calculating the difference between current year (2026) and vehicle year
UPDATE public.vehicle_status 
SET no_of_years = EXTRACT(YEAR FROM CURRENT_DATE) - vr.year_model
FROM public.vehicle_registry vr
WHERE public.vehicle_status.plate = vr.plate
AND public.vehicle_status.no_of_years IS NULL;

-- Step 2: Also update the vehicle_registry table to keep data consistent
UPDATE public.vehicle_registry 
SET no_of_years = EXTRACT(YEAR FROM CURRENT_DATE) - year_model
WHERE no_of_years IS NULL;

-- Step 3: Create a function to automatically calculate no_of_years when inserting/updating
CREATE OR REPLACE FUNCTION calculate_no_of_years()
RETURNS TRIGGER AS $$
BEGIN
    -- For vehicle_status table
    IF TG_TABLE_NAME = 'vehicle_status' THEN
        NEW.no_of_years = EXTRACT(YEAR FROM CURRENT_DATE) - 
                          (SELECT year_model FROM public.vehicle_registry WHERE plate = NEW.plate);
    -- For vehicle_registry table  
    ELSIF TG_TABLE_NAME = 'vehicle_registry' THEN
        NEW.no_of_years = EXTRACT(YEAR FROM CURRENT_DATE) - NEW.year_model;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Step 4: Create triggers to automatically calculate no_of_years on insert/update
-- Trigger for vehicle_status table
DROP TRIGGER IF EXISTS auto_calculate_no_of_years_vehicle_status ON public.vehicle_status;
CREATE TRIGGER auto_calculate_no_of_years_vehicle_status
    BEFORE INSERT OR UPDATE ON public.vehicle_status
    FOR EACH ROW
    EXECUTE FUNCTION calculate_no_of_years();

-- Trigger for vehicle_registry table
DROP TRIGGER IF EXISTS auto_calculate_no_of_years_vehicle_registry ON public.vehicle_registry;
CREATE TRIGGER auto_calculate_no_of_years_vehicle_registry
    BEFORE INSERT OR UPDATE ON public.vehicle_registry
    FOR EACH ROW
    EXECUTE FUNCTION calculate_no_of_years();

-- Step 5: Verify the updates
-- You can run these queries to verify the results:

-- Check vehicle_status table
-- SELECT plate, no_of_years FROM public.vehicle_status ORDER BY plate;

-- Check vehicle_registry table  
-- SELECT plate, year_model, no_of_years FROM public.vehicle_registry ORDER BY plate;

-- Sample calculation verification:
-- For a 2014 vehicle: 2026 - 2014 = 12 years
-- For a 2015 vehicle: 2026 - 2015 = 11 years
-- For a 2017 vehicle: 2026 - 2017 = 9 years
-- For a 2018 vehicle: 2026 - 2018 = 8 years
