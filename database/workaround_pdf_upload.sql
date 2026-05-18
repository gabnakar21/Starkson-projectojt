-- Workaround for PDF Upload - Create New Bucket or Modify Approach
-- Run this SQL in your Supabase SQL Editor

-- ============================================================
-- Option A: Create new bucket without MIME restrictions
-- ============================================================

-- Create a new bucket specifically for PDFs (no MIME restrictions)
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
  'truck-pdfs', 
  'truck-pdfs', 
  true, 
  52428800, -- 50MB limit per file
  NULL -- No MIME type restrictions
);

-- Create policies for the new PDF bucket
CREATE POLICY "Anyone can view truck PDFs" ON storage.objects
FOR SELECT USING (bucket_id = 'truck-pdfs');

CREATE POLICY "Authenticated users can upload truck PDFs" ON storage.objects
FOR INSERT WITH CHECK (
  bucket_id = 'truck-pdfs' AND 
  auth.role() = 'authenticated'
);

CREATE POLICY "Authenticated users can update truck PDFs" ON storage.objects
FOR UPDATE USING (
  bucket_id = 'truck-pdfs' AND 
  auth.role() = 'authenticated'
);

CREATE POLICY "Authenticated users can delete truck PDFs" ON storage.objects
FOR DELETE USING (
  bucket_id = 'truck-pdfs' AND 
  auth.role() = 'authenticated'
);

-- ============================================================
-- Option B: Force update using system admin (if you have access)
-- ============================================================

-- This requires elevated privileges - may not work for regular users
-- Uncomment and try only if you have admin access:

/*
-- Reset bucket configuration completely
TRUNCATE TABLE storage.buckets;
INSERT INTO storage.buckets (id, name, public, file_size_limit)
VALUES (
  'truck-documents',
  'truck-documents',
  true,
  52428800
);
*/

-- ============================================================
-- Verification
-- ============================================================

-- Check all buckets
SELECT id, name, public, file_size_limit, allowed_mime_types 
FROM storage.buckets 
WHERE id IN ('truck-documents', 'truck-pdfs')
ORDER BY id;

COMMIT;
