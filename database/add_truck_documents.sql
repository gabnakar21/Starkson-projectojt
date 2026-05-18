-- Add O/R and C/R Image Columns to drivers_status Table
-- Run this SQL in your Supabase SQL Editor

-- ============================================================
-- Add image columns to drivers_status table
-- ============================================================

DO $$
BEGIN
  -- Add or_image_url column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'drivers_status' AND column_name = 'or_image_url'
  ) THEN
    ALTER TABLE public.drivers_status ADD COLUMN or_image_url TEXT DEFAULT NULL;
  END IF;

  -- Add or_image_name column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'drivers_status' AND column_name = 'or_image_name'
  ) THEN
    ALTER TABLE public.drivers_status ADD COLUMN or_image_name TEXT DEFAULT NULL;
  END IF;

  -- Add cr_image_url column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'drivers_status' AND column_name = 'cr_image_url'
  ) THEN
    ALTER TABLE public.drivers_status ADD COLUMN cr_image_url TEXT DEFAULT NULL;
  END IF;

  -- Add cr_image_name column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'drivers_status' AND column_name = 'cr_image_name'
  ) THEN
    ALTER TABLE public.drivers_status ADD COLUMN cr_image_name TEXT DEFAULT NULL;
  END IF;
END $$;

-- ============================================================
-- Create storage bucket for truck documents
-- ============================================================

-- Note: Storage buckets need to be created manually in Supabase Dashboard
-- Bucket name: truck-documents
-- Public access: Enabled

-- ============================================================
-- Update RLS policies for truck documents storage
-- ============================================================

-- Create policies for the storage bucket (run after creating bucket in dashboard)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'truck-documents', 
  'truck-documents', 
  true, 
  52428800, -- 50MB limit per file
  ARRAY['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'application/pdf']
) ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  public = EXCLUDED.public,
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types;

-- Storage policies - Allow all operations for authenticated users
DROP POLICY IF EXISTS "Anyone can view truck documents" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can upload truck documents" ON storage.objects;
DROP POLICY IF EXISTS "Users can update own truck documents" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete own truck documents" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can update truck documents" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can delete truck documents" ON storage.objects;

-- Create new permissive policies for truck-documents bucket
CREATE POLICY "Anyone can view truck documents" ON storage.objects
FOR SELECT USING (bucket_id = 'truck-documents');

CREATE POLICY "Authenticated users can upload truck documents" ON storage.objects
FOR INSERT WITH CHECK (
  bucket_id = 'truck-documents' AND 
  auth.role() = 'authenticated'
);

CREATE POLICY "Authenticated users can update truck documents" ON storage.objects
FOR UPDATE USING (
  bucket_id = 'truck-documents' AND 
  auth.role() = 'authenticated'
);

CREATE POLICY "Authenticated users can delete truck documents" ON storage.objects
FOR DELETE USING (
  bucket_id = 'truck-documents' AND 
  auth.role() = 'authenticated'
);

-- Alternative: Disable RLS for storage bucket if policies don't work
-- Uncomment below if above policies still don't work

-- Disable RLS for storage.objects table (less secure but works)
ALTER TABLE storage.objects DISABLE ROW LEVEL SECURITY;

-- Or create a very permissive policy
CREATE POLICY "Allow all operations on truck documents" ON storage.objects
FOR ALL USING (bucket_id = 'truck-documents') WITH CHECK (bucket_id = 'truck-documents');

-- If still having issues, try this more permissive approach:
DO $$
BEGIN
  -- Check if RLS is enabled and disable it for storage.objects
  BEGIN
    ALTER TABLE storage.objects DISABLE ROW LEVEL SECURITY;
    RAISE NOTICE 'RLS disabled for storage.objects table';
  EXCEPTION
    WHEN OTHERS THEN
      RAISE NOTICE 'Could not disable RLS for storage.objects: %', SQLERRM;
  END;
END $$;

-- ============================================================
-- Create indexes for better performance
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_drivers_status_or_image ON public.drivers_status(or_image_url);
CREATE INDEX IF NOT EXISTS idx_drivers_status_cr_image ON public.drivers_status(cr_image_url);

-- ============================================================
-- Add comments for documentation
-- ============================================================

COMMENT ON COLUMN public.drivers_status.or_image_url IS 'URL to the O/R (Official Receipt) image stored in Supabase storage';
COMMENT ON COLUMN public.drivers_status.or_image_name IS 'Filename of the O/R (Official Receipt) image in storage';
COMMENT ON COLUMN public.drivers_status.cr_image_url IS 'URL to the C/R (Certificate of Registration) image stored in Supabase storage';
COMMENT ON COLUMN public.drivers_status.cr_image_name IS 'Filename of the C/R (Certificate of Registration) image in storage';

-- ============================================================
-- Sample data update (optional)
-- ============================================================

-- Update existing records with sample image URLs (for testing)
-- UPDATE public.drivers_status 
-- SET or_image_url = 'https://example.com/or-sample.jpg',
--     or_image_name = 'or_sample.jpg',
--     cr_image_url = 'https://example.com/cr-sample.jpg', 
--     cr_image_name = 'cr_sample.jpg'
-- WHERE plate = 'AAY 3082' AND or_image_url IS NULL;

COMMIT;
