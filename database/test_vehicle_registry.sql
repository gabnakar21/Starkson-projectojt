-- Test script to verify vehicle_registry table structure
-- This script checks if all required columns exist in the vehicle_registry table

-- Check vehicle_registry table structure
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'vehicle_registry' 
    AND table_schema = 'public'
ORDER BY ordinal_position;

-- Test inserting a sample record
DO $$
BEGIN
    -- Check if plate column exists before testing insert
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'vehicle_registry' AND column_name = 'plate'
    ) THEN
        -- Test insert with sample data
        INSERT INTO public.vehicle_registry (
            plate, model, size, year_model, plant, engine_no, chassi_no, 
            classification, vehicle_type, color, aircon_type, cr_no, cr_registered,
            mv_file, denomination, piston_displacement, no_of_cylinder, fuel,
            series, body_type, body_no, gross_wt, net_wt, shipping_wt,
            net_capacity, length, width, height, volume, owner_name, address,
            company, no_of_years, pallets_cap, tire_size_front, tire_size_rear,
            total_tire_front, total_tire_rear, autosweep, easytrip, gps_type, remarks
        ) VALUES (
            'TEST-001', 'Test Model', '10ft', 2023, 'Test Plant', 'ENG001', 
            'CHAS001', 'Test Class', 'truck', 'Blue', 'AC Type', 'CR001', 
            '2023-01-01', 'MV001', 'Test Denom', '2.0L', 4, 'Diesel',
            'Test Series', 'Truck', 'BODY001', 10000.0, 8000.0, 9000.0,
            7500.0, 20.5, 8.0, 10.0, 1640.0, 'Test Owner', 'Test Address',
            'Test Company', 5, 20, '225/75R17.5', '225/75R17.5',
            6, 4, 'AUTOSWEEP001', 'EASYTRIP001', 'GPS001', 'Test Remarks'
        ) ON CONFLICT (plate) DO NOTHING;
        
        RAISE NOTICE 'Test record inserted successfully';
    ELSE
        RAISE NOTICE 'Plate column does not exist in vehicle_registry table';
    END IF;
END $$;

-- Test querying the sample record
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'vehicle_registry' AND column_name = 'plate'
    ) THEN
        -- Test select query
        DECLARE
            test_record RECORD;
        BEGIN
            SELECT * INTO test_record 
            FROM public.vehicle_registry 
            WHERE plate = 'TEST-001';
            
            IF FOUND THEN
                RAISE NOTICE 'Test record found: %', test_record.plate;
                RAISE NOTICE 'Address field: %', test_record.address;
            ELSE
                RAISE NOTICE 'Test record not found';
            END IF;
        END;
    END IF;
END $$;

-- Clean up test data
DELETE FROM public.vehicle_registry WHERE plate = 'TEST-001';

DO $$
BEGIN
    RAISE NOTICE 'Vehicle registry table test completed';
END $$;
