-- Add all missing document columns to drivers_status table
-- Run this script in your Supabase SQL Editor to add all document storage columns

-- Step 1: Add missing document columns to drivers_status table (if they don't already exist)
ALTER TABLE public.drivers_status 
ADD COLUMN IF NOT EXISTS cr_image_url TEXT,
ADD COLUMN IF NOT EXISTS cr_image_name TEXT,
ADD COLUMN IF NOT EXISTS or_image_url TEXT,
ADD COLUMN IF NOT EXISTS or_image_name TEXT,
ADD COLUMN IF NOT EXISTS date_reported DATE;

-- Step 2: Add comments for documentation
COMMENT ON COLUMN public.drivers_status.cr_image_url IS 'URL to C/R document PDF file';
COMMENT ON COLUMN public.drivers_status.cr_image_name IS 'Filename of C/R document PDF';
COMMENT ON COLUMN public.drivers_status.or_image_url IS 'URL to O/R document PDF file';
COMMENT ON COLUMN public.drivers_status.or_image_name IS 'Filename of O/R document PDF';
COMMENT ON COLUMN public.drivers_status.date_reported IS 'Date when truck was reported as DOWN';

-- Step 3: Create indexes for better performance on new columns
CREATE INDEX IF NOT EXISTS idx_drivers_status_cr_image_url ON public.drivers_status(cr_image_url);
CREATE INDEX IF NOT EXISTS idx_drivers_status_cr_image_name ON public.drivers_status(cr_image_name);
CREATE INDEX IF NOT EXISTS idx_drivers_status_or_image_url ON public.drivers_status(or_image_url);
CREATE INDEX IF NOT EXISTS idx_drivers_status_or_image_name ON public.drivers_status(or_image_name);
CREATE INDEX IF NOT EXISTS idx_drivers_status_date_reported ON public.drivers_status(date_reported);

-- Step 4: Verify all columns were added successfully
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'drivers_status' 
    AND table_schema = 'public'
    AND column_name IN ('cr_image_url', 'cr_image_name', 'or_image_url', 'or_image_name', 'date_reported')
ORDER BY column_name;
