-- Data Migration Script: Copy Vehicle Data from Registry to Status
-- Run this script in your Supabase SQL Editor AFTER running the table update script

-- Step 1: Update existing vehicle_status records with data from vehicle_registry
-- This will copy truck_size, model, and year from vehicle_registry to vehicle_status
UPDATE public.vehicle_status vs
SET 
    truck_size = vr.size,
    model = vr.model,
    year = vr.year_model
FROM public.vehicle_registry vr
WHERE vs.plate = vr.plate
AND (vs.truck_size IS NULL OR vs.model IS NULL OR vs.year IS NULL);

-- Step 2: Insert any missing vehicle_status records that exist in vehicle_registry
-- This ensures all vehicles in registry have corresponding status records
INSERT INTO public.vehicle_status (plate, registered_date, expiration_date, truck_size, model, year)
SELECT 
    vr.plate,
    CURRENT_DATE - INTERVAL '1 year' as registered_date,  -- Default: 1 year ago
    CURRENT_DATE + INTERVAL '1 year' as expiration_date,   -- Default: 1 year from now
    vr.size as truck_size,
    vr.model,
    vr.year_model
FROM public.vehicle_registry vr
WHERE NOT EXISTS (
    SELECT 1 FROM public.vehicle_status vs WHERE vs.plate = vr.plate
);

-- Step 3: Verify the migration results
-- Run these queries to check the migration:

-- Check how many records were updated
SELECT COUNT(*) as updated_records
FROM public.vehicle_status 
WHERE truck_size IS NOT NULL AND model IS NOT NULL AND year IS NOT NULL;

-- Check for any records that still need migration
SELECT COUNT(*) as records_needing_migration
FROM public.vehicle_status 
WHERE truck_size IS NULL OR model IS NULL OR year IS NULL;

-- Show sample of migrated data
SELECT 
    plate,
    truck_size,
    model,
    year,
    no_of_years,
    registered_date,
    expiration_date
FROM public.vehicle_status 
ORDER BY plate
LIMIT 10;

-- Step 4: Optional - Set default no_of_years for existing records
-- Uncomment if you want to set a default value
-- UPDATE public.vehicle_status SET no_of_years = 5 WHERE no_of_years IS NULL;

-- Migration complete! 
-- You should now see truck_size, model, and year populated in the vehicle_status table.
