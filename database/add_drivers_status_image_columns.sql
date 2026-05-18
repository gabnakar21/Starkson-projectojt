-- Add missing image columns to drivers_status table
-- Run this script if the drivers_status table exists but needs image columns

-- Add image columns if they don't exist
DO $$
BEGIN
    -- Add or_image_url column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'drivers_status' AND column_name = 'or_image_url'
    ) THEN
        ALTER TABLE public.drivers_status ADD COLUMN or_image_url TEXT;
        RAISE NOTICE 'Added or_image_url column to drivers_status table';
    ELSE
        RAISE NOTICE 'or_image_url column already exists in drivers_status table';
    END IF;

    -- Add or_image_name column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'drivers_status' AND column_name = 'or_image_name'
    ) THEN
        ALTER TABLE public.drivers_status ADD COLUMN or_image_name TEXT;
        RAISE NOTICE 'Added or_image_name column to drivers_status table';
    ELSE
        RAISE NOTICE 'or_image_name column already exists in drivers_status table';
    END IF;

    -- Add cr_image_url column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'drivers_status' AND column_name = 'cr_image_url'
    ) THEN
        ALTER TABLE public.drivers_status ADD COLUMN cr_image_url TEXT;
        RAISE NOTICE 'Added cr_image_url column to drivers_status table';
    ELSE
        RAISE NOTICE 'cr_image_url column already exists in drivers_status table';
    END IF;

    -- Add cr_image_name column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'drivers_status' AND column_name = 'cr_image_name'
    ) THEN
        ALTER TABLE public.drivers_status ADD COLUMN cr_image_name TEXT;
        RAISE NOTICE 'Added cr_image_name column to drivers_status table';
    ELSE
        RAISE NOTICE 'cr_image_name column already exists in drivers_status table';
    END IF;
END $$;

-- Add indexes for image columns for better query performance
CREATE INDEX IF NOT EXISTS idx_drivers_status_or_image_url ON public.drivers_status(or_image_url);
CREATE INDEX IF NOT EXISTS idx_drivers_status_cr_image_url ON public.drivers_status(cr_image_url);

-- Verify the table structure
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'drivers_status' 
ORDER BY ordinal_position;

-- Show sample data with image columns
SELECT plate, driver, status, or_image_name, cr_image_name 
FROM public.drivers_status 
WHERE or_image_url IS NOT NULL OR cr_image_url IS NOT NULL
LIMIT 5;
