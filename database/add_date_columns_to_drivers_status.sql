-- Add Registration Date and Expiration Date columns to drivers_status table
-- Run this script in your Supabase SQL Editor to fix the missing columns error

-- Step 1: Add new columns to drivers_status table (if they don't already exist)
ALTER TABLE public.drivers_status 
ADD COLUMN IF NOT EXISTS registered_date DATE,
ADD COLUMN IF NOT EXISTS expiration_date DATE;

-- Step 2: Create indexes for better performance on new columns
CREATE INDEX IF NOT EXISTS idx_drivers_status_registered_date ON public.drivers_status(registered_date);
CREATE INDEX IF NOT EXISTS idx_drivers_status_expiration_date ON public.drivers_status(expiration_date);

-- Step 3: Add comments for documentation
COMMENT ON COLUMN public.drivers_status.registered_date IS 'Vehicle registration date';
COMMENT ON COLUMN public.drivers_status.expiration_date IS 'Vehicle expiration date';

-- Step 4: Verify the table structure
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'drivers_status' 
    AND table_schema = 'public'
    AND column_name IN ('registered_date', 'expiration_date')
ORDER BY column_name;
