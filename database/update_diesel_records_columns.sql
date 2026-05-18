-- ============================================================
-- MIGRATION: UPDATE DIESEL RECORDS TABLE COLUMNS
-- ============================================================
-- Purpose: Add 8W column, replace 18W with 12W, and match new table structure
-- Date: 2026-04-15

-- ============================================================
-- 1. UPDATE DIESEL RECORDS AVERAGE TABLE
-- ============================================================

-- Add new 8W column
ALTER TABLE public.diesel_records_ave 
ADD COLUMN IF NOT EXISTS eight_w DECIMAL(10,2);

-- Rename eighteen_w to twelve_w (only if column exists)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'diesel_records_ave' 
        AND column_name = 'eighteen_w'
        AND table_schema = 'public'
    ) THEN
        ALTER TABLE public.diesel_records_ave 
        RENAME COLUMN eighteen_w TO twelve_w;
    END IF;
END $$;

-- Update comments for clarity
COMMENT ON COLUMN public.diesel_records_ave.eight_w IS '8W diesel consumption';
COMMENT ON COLUMN public.diesel_records_ave.twelve_w IS '12W diesel consumption (renamed from 18W)';

-- ============================================================
-- 2. UPDATE DIESEL RECORDS MINIMUM TABLE
-- ============================================================

-- Add new 8W column
ALTER TABLE public.diesel_records_min 
ADD COLUMN IF NOT EXISTS eight_w DECIMAL(10,2);

-- Rename eighteen_w to twelve_w (only if column exists)
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'diesel_records_min' 
        AND column_name = 'eighteen_w'
        AND table_schema = 'public'
    ) THEN
        ALTER TABLE public.diesel_records_min 
        RENAME COLUMN eighteen_w TO twelve_w;
    END IF;
END $$;

-- Update comments for clarity
COMMENT ON COLUMN public.diesel_records_min.eight_w IS '8W diesel consumption';
COMMENT ON COLUMN public.diesel_records_min.twelve_w IS '12W diesel consumption (renamed from 18W)';

-- ============================================================
-- 3. UPDATE INDEXES FOR NEW COLUMNS
-- ============================================================

-- Add indexes for new 8W column
CREATE INDEX IF NOT EXISTS idx_diesel_ave_eight_w ON public.diesel_records_ave(eight_w);
CREATE INDEX IF NOT EXISTS idx_diesel_min_eight_w ON public.diesel_records_min(eight_w);

-- Update index names for renamed column
DROP INDEX IF EXISTS public.idx_diesel_ave_eighteen_w;
DROP INDEX IF EXISTS public.idx_diesel_min_eighteen_w;

CREATE INDEX IF NOT EXISTS idx_diesel_ave_twelve_w ON public.diesel_records_ave(twelve_w);
CREATE INDEX IF NOT EXISTS idx_diesel_min_twelve_w ON public.diesel_records_min(twelve_w);

-- ============================================================
-- 4. MIGRATE EXISTING DATA (OPTIONAL)
-- ============================================================
-- Note: This section is for data migration if needed
-- You can uncomment and modify these statements if you want to migrate data

-- Example: If you want to move some 18W data to 12W and 8W columns
-- UPDATE public.diesel_records_ave 
-- SET eight_w = twelve_w * 0.6, twelve_w = twelve_w * 0.8 
-- WHERE eight_w IS NULL AND twelve_w IS NOT NULL;

-- UPDATE public.diesel_records_min 
-- SET eight_w = twelve_w * 0.6, twelve_w = twelve_w * 0.8 
-- WHERE eight_w IS NULL AND twelve_w IS NOT NULL;

-- ============================================================
-- 5. VERIFICATION QUERIES
-- ============================================================

-- Check table structures
-- \d public.diesel_records_ave
-- \d public.diesel_records_min

-- Sample queries to verify the changes
-- SELECT id, destination, four_w_six_w, eight_w, ten_w, twelve_w, tractor_head 
-- FROM public.diesel_records_ave 
-- LIMIT 5;

-- SELECT id, destination, four_w_six_w, eight_w, ten_w, twelve_w, tractor_head 
-- FROM public.diesel_records_min 
-- LIMIT 5;

-- ============================================================
-- 6. ROLLBACK SCRIPT (IF NEEDED)
-- ============================================================

-- If you need to rollback these changes, use the following:
-- ALTER TABLE public.diesel_records_ave DROP COLUMN IF EXISTS eight_w;
-- ALTER TABLE public.diesel_records_ave RENAME COLUMN twelve_w TO eighteen_w;
-- ALTER TABLE public.diesel_records_min DROP COLUMN IF EXISTS eight_w;
-- ALTER TABLE public.diesel_records_min RENAME COLUMN twelve_w TO eighteen_w;
