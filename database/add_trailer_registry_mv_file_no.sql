-- Add missing mv_file_no column to trailer_registry table
-- Run this script if the trailer_registry table exists but needs the mv_file_no column

-- Add mv_file_no column if it doesn't exist
DO $$
BEGIN
    -- Add mv_file_no column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'trailer_registry' AND column_name = 'mv_file_no'
    ) THEN
        ALTER TABLE public.trailer_registry ADD COLUMN mv_file_no TEXT;
        RAISE NOTICE 'Added mv_file_no column to trailer_registry table';
    ELSE
        RAISE NOTICE 'mv_file_no column already exists in trailer_registry table';
    END IF;
END $$;

-- Update sample data to include mv_file_no (default to common MV file numbers)
UPDATE public.trailer_registry 
SET mv_file_no = 'MV-' || plate_no || '-2024'
WHERE mv_file_no IS NULL AND plate_no IS NOT NULL;

-- For records without plate_no, set a default
UPDATE public.trailer_registry 
SET mv_file_no = 'MV-DEFAULT-2024'
WHERE mv_file_no IS NULL AND plate_no IS NULL;

-- Add index for mv_file_no column for better query performance
CREATE INDEX IF NOT EXISTS idx_trailer_registry_mv_file_no ON public.trailer_registry(mv_file_no);

-- Verify the table structure
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'trailer_registry' 
ORDER BY ordinal_position;

-- Show sample data with mv_file_no
SELECT plate_no, chassis_no, container, status, mv_file_no 
FROM public.trailer_registry 
LIMIT 5;
