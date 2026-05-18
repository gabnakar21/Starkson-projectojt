-- Fix missing columns in trailer_registry table
-- Run this script if the table already exists and needs additional columns

-- Add missing columns if they don't exist
DO $$
BEGIN
    -- Add remarks column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'trailer_registry' AND column_name = 'remarks'
    ) THEN
        ALTER TABLE public.trailer_registry ADD COLUMN remarks TEXT;
    END IF;

    -- Add trailer_type column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'trailer_registry' AND column_name = 'trailer_type'
    ) THEN
        ALTER TABLE public.trailer_registry ADD COLUMN trailer_type TEXT;
    END IF;

    -- Add gross_weight column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'trailer_registry' AND column_name = 'gross_weight'
    ) THEN
        ALTER TABLE public.trailer_registry ADD COLUMN gross_weight DECIMAL(10,2);
    END IF;

    -- Add cr_registered column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'trailer_registry' AND column_name = 'cr_registered'
    ) THEN
        ALTER TABLE public.trailer_registry ADD COLUMN cr_registered DATE;
    END IF;

    -- Add cr_expiry_date column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'trailer_registry' AND column_name = 'cr_expiry_date'
    ) THEN
        ALTER TABLE public.trailer_registry ADD COLUMN cr_expiry_date DATE;
    END IF;

    -- Add date_reported column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'trailer_registry' AND column_name = 'date_reported'
    ) THEN
        ALTER TABLE public.trailer_registry ADD COLUMN date_reported DATE;
    END IF;
END $$;

-- Update sample data to include the new columns
UPDATE public.trailer_registry 
SET 
    remarks = COALESCE(remarks, 'Standard trailer'),
    trailer_type = COALESCE(trailer_type, 'Flatbed'),
    gross_weight = COALESCE(gross_weight, 20000.00),
    cr_registered = COALESCE(cr_registered, CURRENT_DATE - INTERVAL '1 year'),
    cr_expiry_date = COALESCE(cr_expiry_date, CURRENT_DATE + INTERVAL '1 year'),
    date_reported = COALESCE(date_reported, CURRENT_DATE)
WHERE remarks IS NULL OR trailer_type IS NULL OR gross_weight IS NULL OR cr_registered IS NULL OR cr_expiry_date IS NULL OR date_reported IS NULL;

-- Add indexes for the new columns
CREATE INDEX IF NOT EXISTS idx_trailer_registry_type ON public.trailer_registry(trailer_type);
CREATE INDEX IF NOT EXISTS idx_trailer_registry_weight ON public.trailer_registry(gross_weight);

-- Verify the table structure
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'trailer_registry' 
ORDER BY ordinal_position;
