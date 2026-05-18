-- Add cr_image_url and cr_image_name columns to drivers_status table
-- Run this script in your Supabase SQL Editor to add missing document columns

-- Step 1: Add missing columns to drivers_status table (if they don't already exist)
ALTER TABLE public.drivers_status 
ADD COLUMN IF NOT EXISTS cr_image_url TEXT,
ADD COLUMN IF NOT EXISTS cr_image_name TEXT;

-- Step 2: Add comments for documentation
COMMENT ON COLUMN public.drivers_status.cr_image_url IS 'URL to C/R document PDF file';
COMMENT ON COLUMN public.drivers_status.cr_image_name IS 'Filename of C/R document PDF';

-- Step 3: Create indexes for better performance on new columns
CREATE INDEX IF NOT EXISTS idx_drivers_status_cr_image_url ON public.drivers_status(cr_image_url);
CREATE INDEX IF NOT EXISTS idx_drivers_status_cr_image_name ON public.drivers_status(cr_image_name);

-- Step 4: Verify the columns were added successfully
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'drivers_status' 
    AND table_schema = 'public'
    AND column_name IN ('cr_image_url', 'cr_image_name')
ORDER BY column_name;
