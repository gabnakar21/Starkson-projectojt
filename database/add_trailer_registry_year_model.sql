-- Add missing year_model column to trailer_registry table
-- Run this script if the trailer_registry table exists but needs the year_model column

-- Add year_model column if it doesn't exist
DO $$
BEGIN
    -- Add year_model column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'trailer_registry' AND column_name = 'year_model'
    ) THEN
        ALTER TABLE public.trailer_registry ADD COLUMN year_model INTEGER;
        RAISE NOTICE 'Added year_model column to trailer_registry table';
    ELSE
        RAISE NOTICE 'year_model column already exists in trailer_registry table';
    END IF;
END $$;

-- Update sample data to include year_model (default to reasonable years)
UPDATE public.trailer_registry 
SET year_model = 2020
WHERE year_model IS NULL AND plate_no LIKE 'TRL-00%';

UPDATE public.trailer_registry 
SET year_model = 2021
WHERE year_model IS NULL AND plate_no LIKE 'TRL-01%';

UPDATE public.trailer_registry 
SET year_model = 2020
WHERE year_model IS NULL;

-- Add index for year_model column for better query performance
CREATE INDEX IF NOT EXISTS idx_trailer_registry_year_model ON public.trailer_registry(year_model);

-- Verify the table structure
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'trailer_registry' 
ORDER BY ordinal_position;

-- Show sample data with year_model
SELECT plate_no, chassis_no, container, status, year_model 
FROM public.trailer_registry 
LIMIT 5;
