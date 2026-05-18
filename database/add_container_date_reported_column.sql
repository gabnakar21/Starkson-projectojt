-- Add date_reported column to containers table
-- Run this script in your Supabase SQL Editor to add the missing date_reported column

-- Step 1: Add date_reported column to containers table (if it doesn't already exist)
ALTER TABLE public.containers 
ADD COLUMN IF NOT EXISTS date_reported DATE;

-- Step 2: Add comment for documentation
COMMENT ON COLUMN public.containers.date_reported IS 'Date when container was reported as DOWN';

-- Step 3: Create index for better performance on date_reported column
CREATE INDEX IF NOT EXISTS idx_containers_date_reported ON public.containers(date_reported);

-- Step 4: Verify the column was added successfully
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'containers' 
    AND table_schema = 'public'
    AND column_name = 'date_reported'
ORDER BY column_name;
