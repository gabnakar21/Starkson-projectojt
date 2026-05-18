-- Add missing remarks column to containers table
-- Run this script if the containers table exists but needs the remarks column

-- Add remarks column if it doesn't exist
DO $$
BEGIN
    -- Add remarks column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'containers' AND column_name = 'remarks'
    ) THEN
        ALTER TABLE public.containers ADD COLUMN remarks TEXT;
        RAISE NOTICE 'Added remarks column to containers table';
    ELSE
        RAISE NOTICE 'remarks column already exists in containers table';
    END IF;
END $$;

-- Update sample data to include remarks
UPDATE public.containers 
SET remarks = 'Standard container for general cargo'
WHERE remarks IS NULL AND status = 'OPERATIONAL';

UPDATE public.containers 
SET remarks = 'Container under maintenance'
WHERE remarks IS NULL AND status = 'DOWN';

UPDATE public.containers 
SET remarks = 'Container in active transport'
WHERE remarks IS NULL AND status = 'OPERATIONAL/HUSTLING';

-- Add index for remarks column if frequently searched
CREATE INDEX IF NOT EXISTS idx_containers_remarks ON public.containers(remarks);

-- Verify the table structure
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'containers' 
ORDER BY ordinal_position;

-- Show sample data with remarks
SELECT chassi_no, container, status, remarks 
FROM public.containers 
LIMIT 5;
