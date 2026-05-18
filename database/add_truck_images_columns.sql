-- Add image columns to vehicle_registry table for truck images
-- Run this script in your Supabase SQL Editor to add missing image columns

-- Step 1: Add missing columns to vehicle_registry table (if they don't already exist)
ALTER TABLE public.vehicle_registry 
ADD COLUMN IF NOT EXISTS image1_url TEXT,
ADD COLUMN IF NOT EXISTS image2_url TEXT,
ADD COLUMN IF NOT EXISTS image3_url TEXT,
ADD COLUMN IF NOT EXISTS image4_url TEXT;

-- Step 2: Add comments for documentation
COMMENT ON COLUMN public.vehicle_registry.image1_url IS 'URL to truck image 1 stored in Supabase storage';
COMMENT ON COLUMN public.vehicle_registry.image2_url IS 'URL to truck image 2 stored in Supabase storage';
COMMENT ON COLUMN public.vehicle_registry.image3_url IS 'URL to truck image 3 stored in Supabase storage';
COMMENT ON COLUMN public.vehicle_registry.image4_url IS 'URL to truck image 4 stored in Supabase storage';

-- Step 3: Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_vehicle_registry_image1 ON public.vehicle_registry(image1_url);
CREATE INDEX IF NOT EXISTS idx_vehicle_registry_image2 ON public.vehicle_registry(image2_url);
CREATE INDEX IF NOT EXISTS idx_vehicle_registry_image3 ON public.vehicle_registry(image3_url);
CREATE INDEX IF NOT EXISTS idx_vehicle_registry_image4 ON public.vehicle_registry(image4_url);

-- Step 4: Verify the columns were added
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'vehicle_registry' 
    AND column_name LIKE 'image%'
ORDER BY ordinal_position;
