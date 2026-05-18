-- Add missing location_plant column to trailer_registry table
-- Run this script if the trailer_registry table exists but needs the location_plant column

-- Add location_plant column if it doesn't exist
DO $$
BEGIN
    -- Add location_plant column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'trailer_registry' AND column_name = 'location_plant'
    ) THEN
        ALTER TABLE public.trailer_registry ADD COLUMN location_plant TEXT;
        RAISE NOTICE 'Added location_plant column to trailer_registry table';
    ELSE
        RAISE NOTICE 'location_plant column already exists in trailer_registry table';
    END IF;
END $$;

-- Update sample data to include location_plant (default to common plant locations)
UPDATE public.trailer_registry 
SET location_plant = 'DISNEY 3'
WHERE location_plant IS NULL AND plate_no LIKE 'TRL-00%';

UPDATE public.trailer_registry 
SET location_plant = 'DISNEY 6'
WHERE location_plant IS NULL AND plate_no LIKE 'TRL-01%';

UPDATE public.trailer_registry 
SET location_plant = 'DISNEY 3'
WHERE location_plant IS NULL;

-- Add index for location_plant column for better query performance
CREATE INDEX IF NOT EXISTS idx_trailer_registry_location_plant ON public.trailer_registry(location_plant);

-- Verify the table structure
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'trailer_registry' 
ORDER BY ordinal_position;

-- Show sample data with location_plant
SELECT plate_no, chassis_no, container, status, location_plant 
FROM public.trailer_registry 
LIMIT 5;
