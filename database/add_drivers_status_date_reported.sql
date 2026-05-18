    -- Add missing date_reported column to drivers_status table
    -- Run this script if the drivers_status table exists but needs the date_reported column

    -- Add date_reported column if it doesn't exist
    DO $$
    BEGIN
        -- Add date_reported column
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.columns 
            WHERE table_name = 'drivers_status' AND column_name = 'date_reported'
        ) THEN
            ALTER TABLE public.drivers_status ADD COLUMN date_reported DATE;
            RAISE NOTICE 'Added date_reported column to drivers_status table';
        ELSE
            RAISE NOTICE 'date_reported column already exists in drivers_status table';
        END IF;
    END $$;

    -- Update sample data to include date_reported
    UPDATE public.drivers_status 
    SET date_reported = CURRENT_DATE - INTERVAL '7 days'
    WHERE date_reported IS NULL AND status = 'OPERATIONAL';

    UPDATE public.drivers_status 
    SET date_reported = CURRENT_DATE - INTERVAL '1 day'
    WHERE date_reported IS NULL AND status = 'DOWN';

    UPDATE public.drivers_status 
    SET date_reported = CURRENT_DATE - INTERVAL '3 days'
    WHERE date_reported IS NULL AND status = 'OPERATIONAL/HUSTLING';

    -- Add index for date_reported column for better query performance
    CREATE INDEX IF NOT EXISTS idx_drivers_status_date_reported ON public.drivers_status(date_reported);

    -- Verify the table structure
    SELECT column_name, data_type, is_nullable 
    FROM information_schema.columns 
    WHERE table_name = 'drivers_status' 
    ORDER BY ordinal_position;

    -- Show sample data with date_reported
    SELECT plate, driver, status, truck_issue, date_reported 
    FROM public.drivers_status 
    LIMIT 5;
