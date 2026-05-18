-- Add missing date_reported column to containers table
-- Run this script if the containers table exists but needs the date_reported column

-- Add date_reported column if it doesn't exist
DO $$
BEGIN
    -- Add date_reported column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'containers' AND column_name = 'date_reported'
    ) THEN
        ALTER TABLE public.containers ADD COLUMN date_reported DATE;
        RAISE NOTICE 'Added date_reported column to containers table';
    ELSE
        RAISE NOTICE 'date_reported column already exists in containers table';
    END IF;
END $$;

-- Update sample data to include date_reported
UPDATE public.containers 
SET date_reported = CURRENT_DATE - INTERVAL '14 days'
WHERE date_reported IS NULL AND status = 'OPERATIONAL';

UPDATE public.containers 
SET date_reported = CURRENT_DATE - INTERVAL '2 days'
WHERE date_reported IS NULL AND status = 'DOWN';

UPDATE public.containers 
SET date_reported = CURRENT_DATE - INTERVAL '5 days'
WHERE date_reported IS NULL AND status = 'OPERATIONAL/HUSTLING';

-- Add index for date_reported column for better query performance
CREATE INDEX IF NOT EXISTS idx_containers_date_reported ON public.containers(date_reported);

-- Verify the table structure
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'containers' 
ORDER BY ordinal_position;

-- Show sample data with date_reported
SELECT chassi_no, container, status, container_issue, date_reported 
FROM public.containers 
LIMIT 5;
