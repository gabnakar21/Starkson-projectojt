-- Add missing owner_name column to trailer_registry table
-- Run this script if the trailer_registry table exists but needs the owner_name column

-- Add owner_name column if it doesn't exist
DO $$
BEGIN
    -- Add owner_name column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'trailer_registry' AND column_name = 'owner_name'
    ) THEN
        ALTER TABLE public.trailer_registry ADD COLUMN owner_name TEXT;
        RAISE NOTICE 'Added owner_name column to trailer_registry table';
    ELSE
        RAISE NOTICE 'owner_name column already exists in trailer_registry table';
    END IF;
END $$;

-- Update sample data to include owner_name (default to common owner names)
UPDATE public.trailer_registry 
SET owner_name = 'Starkson Corporation'
WHERE owner_name IS NULL AND plate_no LIKE 'TRL-00%';

UPDATE public.trailer_registry 
SET owner_name = 'Starkson Corporation'
WHERE owner_name IS NULL AND plate_no LIKE 'TRL-01%';

UPDATE public.trailer_registry 
SET owner_name = 'Starkson Corporation'
WHERE owner_name IS NULL;

-- Add index for owner_name column for better query performance
CREATE INDEX IF NOT EXISTS idx_trailer_registry_owner_name ON public.trailer_registry(owner_name);

-- Verify the table structure
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'trailer_registry' 
ORDER BY ordinal_position;

-- Show sample data with owner_name
SELECT plate_no, chassis_no, container, status, owner_name 
FROM public.trailer_registry 
LIMIT 5;
