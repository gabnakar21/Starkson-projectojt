-- Trailer and Container Images Database Setup
-- This script ensures trailer and container image functionality is properly configured
-- Run this script in your Supabase SQL Editor

-- ============================================================
-- 1. ENSURE TRAILERS TABLE HAS IMAGE FIELDS
-- ============================================================

-- Check if image fields exist in trailers table, add if missing
DO $$
BEGIN
    -- Add image1_url if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'trailers' AND column_name = 'image1_url'
    ) THEN
        ALTER TABLE public.trailers ADD COLUMN image1_url TEXT;
    END IF;
    
    -- Add image2_url if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'trailers' AND column_name = 'image2_url'
    ) THEN
        ALTER TABLE public.trailers ADD COLUMN image2_url TEXT;
    END IF;
    
    -- Add image3_url if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'trailers' AND column_name = 'image3_url'
    ) THEN
        ALTER TABLE public.trailers ADD COLUMN image3_url TEXT;
    END IF;
    
    -- Add image4_url if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'trailers' AND column_name = 'image4_url'
    ) THEN
        ALTER TABLE public.trailers ADD COLUMN image4_url TEXT;
    END IF;
END $$;

-- ============================================================
-- 2. ENSURE CONTAINERS TABLE HAS IMAGE FIELDS
-- ============================================================

-- Check if image fields exist in containers table, add if missing
DO $$
BEGIN
    -- Add image1_url if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'containers' AND column_name = 'image1_url'
    ) THEN
        ALTER TABLE public.containers ADD COLUMN image1_url TEXT;
    END IF;
    
    -- Add image2_url if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'containers' AND column_name = 'image2_url'
    ) THEN
        ALTER TABLE public.containers ADD COLUMN image2_url TEXT;
    END IF;
    
    -- Add image3_url if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'containers' AND column_name = 'image3_url'
    ) THEN
        ALTER TABLE public.containers ADD COLUMN image3_url TEXT;
    END IF;
    
    -- Add image4_url if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'containers' AND column_name = 'image4_url'
    ) THEN
        ALTER TABLE public.containers ADD COLUMN image4_url TEXT;
    END IF;
END $$;

-- ============================================================
-- 3. CREATE/UPDATE TRAILERS TABLE POLICIES FOR IMAGES
-- ============================================================

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Enable read access for all users" ON public.trailers;
DROP POLICY IF EXISTS "Enable insert for admin users only" ON public.trailers;
DROP POLICY IF EXISTS "Enable update for admin users only" ON public.trailers;
DROP POLICY IF EXISTS "Enable delete for admin users only" ON public.trailers;

-- Create policies for trailers table (including image access)
CREATE POLICY "Enable read access for all users" ON public.trailers
  FOR SELECT
  USING (true);

CREATE POLICY "Enable insert for admin users only" ON public.trailers
  FOR INSERT
  WITH CHECK (is_admin_from_session());

CREATE POLICY "Enable update for admin users only" ON public.trailers
  FOR UPDATE
  USING (is_admin_from_session())
  WITH CHECK (is_admin_from_session());

CREATE POLICY "Enable delete for admin users only" ON public.trailers
  FOR DELETE
  USING (is_admin_from_session());

-- ============================================================
-- 4. CREATE/UPDATE CONTAINERS TABLE POLICIES FOR IMAGES
-- ============================================================

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Enable read access for all users" ON public.containers;
DROP POLICY IF EXISTS "Enable insert for admin users only" ON public.containers;
DROP POLICY IF EXISTS "Enable update for admin users only" ON public.containers;
DROP POLICY IF EXISTS "Enable delete for admin users only" ON public.containers;

-- Create policies for containers table (including image access)
CREATE POLICY "Enable read access for all users" ON public.containers
  FOR SELECT
  USING (true);

CREATE POLICY "Enable insert for admin users only" ON public.containers
  FOR INSERT
  WITH CHECK (is_admin_from_session());

CREATE POLICY "Enable update for admin users only" ON public.containers
  FOR UPDATE
  USING (is_admin_from_session())
  WITH CHECK (is_admin_from_session());

CREATE POLICY "Enable delete for admin users only" ON public.containers
  FOR DELETE
  USING (is_admin_from_session());

-- ============================================================
-- 5. CREATE HELPER FUNCTION FOR ADMIN CHECK (if not exists)
-- ============================================================

CREATE OR REPLACE FUNCTION is_admin_from_session()
  RETURNS boolean AS $$
DECLARE
    user_role TEXT;
BEGIN
    -- Get the current user's role from the session
    SELECT au.role INTO user_role
    FROM public.admin_users au
    JOIN public.user_sessions us ON au.id = us.user_id
    WHERE us.session_token = current_setting('app_settings.current_session_token', true)
    AND us.expires_at > NOW()
    AND au.is_active = true;
    
    RETURN user_role = 'admin';
EXCEPTION
    WHEN OTHERS THEN
        RETURN false;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================
-- 5. CLEAN UP DUPLICATE DATA BEFORE ADDING CONSTRAINTS
-- ============================================================

-- Remove duplicate trailer records, keeping the one with the earliest created_at
DELETE FROM public.trailers t1 
USING public.trailers t2 
WHERE t1.plate_no = t2.plate_no 
  AND t1.id > t2.id;

-- Remove duplicate container records, keeping the one with the earliest created_at  
DELETE FROM public.containers c1
USING public.containers c2
WHERE c1.chassi_no = c2.chassi_no
  AND c1.id > c2.id;

-- ============================================================
-- 6. ADD UNIQUE CONSTRAINTS TO PREVENT DUPLICATES
-- ============================================================

-- Add unique constraint to trailers plate_no if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE table_name = 'trailers' AND constraint_name = 'trailers_plate_no_unique'
    ) THEN
        ALTER TABLE public.trailers ADD CONSTRAINT trailers_plate_no_unique UNIQUE (plate_no);
    END IF;
END $$;

-- Add unique constraint to containers chassi_no if it doesn't exist
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.table_constraints 
        WHERE table_name = 'containers' AND constraint_name = 'containers_chassi_no_unique'
    ) THEN
        ALTER TABLE public.containers ADD CONSTRAINT containers_chassi_no_unique UNIQUE (chassi_no);
    END IF;
END $$;

-- ============================================================
-- 7. CREATE INDEXES FOR BETTER PERFORMANCE
-- ============================================================

-- Create indexes for trailer image queries
CREATE INDEX IF NOT EXISTS idx_trailers_plate_no ON public.trailers(plate_no);
CREATE INDEX IF NOT EXISTS idx_trailers_status ON public.trailers(status);

-- Create indexes for container image queries
CREATE INDEX IF NOT EXISTS idx_containers_chassi_no ON public.containers(chassi_no);
CREATE INDEX IF NOT EXISTS idx_containers_container ON public.containers(container);
CREATE INDEX IF NOT EXISTS idx_containers_status ON public.containers(status);

-- ============================================================
-- 8. SAMPLE DATA WITH IMAGES (for testing)
-- ============================================================

-- Insert sample trailer data with images
INSERT INTO public.trailers (plate_no, chassis_no, container, status, image1_url, image2_url, image3_url, image4_url) VALUES
('TRL-001', 'CHS-001', 'CONT-001', 'OPERATIONAL', 
 'https://example.com/trailer1-1.jpg', 'https://example.com/trailer1-2.jpg', 
 'https://example.com/trailer1-3.jpg', 'https://example.com/trailer1-4.jpg')
ON CONFLICT (plate_no) DO NOTHING;

INSERT INTO public.trailers (plate_no, chassis_no, container, status, image1_url, image2_url, image3_url, image4_url) VALUES
('TRL-002', 'CHS-002', 'CONT-002', 'OPERATIONAL/HUSTLING', 
 'https://example.com/trailer2-1.jpg', 'https://example.com/trailer2-2.jpg', 
 'https://example.com/trailer2-3.jpg', 'https://example.com/trailer2-4.jpg')
ON CONFLICT (plate_no) DO NOTHING;

-- Insert sample container data with images
INSERT INTO public.containers (chassi_no, container, color, size, status, image1_url, image2_url, image3_url, image4_url) VALUES
('CHS-001', 'CNT-001', 'Blue', '20ft', 'OPERATIONAL', 
 'https://example.com/container1-1.jpg', 'https://example.com/container1-2.jpg', 
 'https://example.com/container1-3.jpg', 'https://example.com/container1-4.jpg')
ON CONFLICT (chassi_no) DO NOTHING;

INSERT INTO public.containers (chassi_no, container, color, size, status, image1_url, image2_url, image3_url, image4_url) VALUES
('CHS-002', 'CNT-002', 'Red', '40ft', 'OPERATIONAL/HUSTLING', 
 'https://example.com/container2-1.jpg', 'https://example.com/container2-2.jpg', 
 'https://example.com/container2-3.jpg', 'https://example.com/container2-4.jpg')
ON CONFLICT (chassi_no) DO NOTHING;

-- ============================================================
-- 9. VERIFICATION QUERIES
-- ============================================================

-- Verify trailer table structure
SELECT 
    column_name, 
    data_type, 
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'trailers' 
AND column_name LIKE 'image%'
ORDER BY column_name;

-- Verify container table structure  
SELECT 
    column_name, 
    data_type, 
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'containers' 
AND column_name LIKE 'image%'
ORDER BY column_name;

-- Verify sample data
SELECT plate_no, chassis_no, container, status, 
       CASE WHEN image1_url IS NOT NULL THEN 'Has Images' ELSE 'No Images' END as image_status
FROM public.trailers
LIMIT 5;

SELECT chassi_no, container, color, size, status,
       CASE WHEN image1_url IS NOT NULL THEN 'Has Images' ELSE 'No Images' END as image_status
FROM public.containers
LIMIT 5;

-- ============================================================
-- COMPLETION MESSAGE
-- ============================================================

-- Database setup complete!
-- Trailers and containers tables now support 4 images each:
-- - image1_url, image2_url, image3_url, image4_url
-- 
-- RLS policies are configured for:
-- - All users can read trailer/container data including images
-- - Admin users can insert/update/delete trailer/container data including images
-- 
-- Sample data has been added for testing purposes.
-- 
-- Next steps:
-- 1. Implement frontend image upload functionality
-- 2. Create image display components for trailers and containers
-- 3. Set up image storage in Supabase Storage bucket
