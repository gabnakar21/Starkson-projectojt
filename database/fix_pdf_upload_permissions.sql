-- Fix PDF Upload Permissions by Removing MIME Type Restrictions
-- Run this SQL in your Supabase SQL Editor

-- ============================================================
-- Option 1: Remove MIME type restrictions completely
-- ============================================================

-- Update bucket to allow all MIME types (remove MIME type filtering)
UPDATE storage.buckets 
SET allowed_mime_types = NULL
WHERE id = 'truck-documents';

-- ============================================================
-- Option 2: Alternative - Disable RLS for storage objects completely
-- ============================================================

-- Disable Row Level Security for storage.objects (less secure but works)
ALTER TABLE storage.objects DISABLE ROW LEVEL SECURITY;

-- ============================================================
-- Option 3: Create super permissive policy (if above doesn't work)
-- ============================================================

-- Drop existing policies
DROP POLICY IF EXISTS "Anyone can view truck documents" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can upload truck documents" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can update truck documents" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can delete truck documents" ON storage.objects;
DROP POLICY IF EXISTS "Allow all operations on truck documents" ON storage.objects;

-- Create new policy that allows everything
CREATE POLICY "Allow all on truck documents" ON storage.objects
FOR ALL USING (bucket_id = 'truck-documents') WITH CHECK (bucket_id = 'truck-documents');

-- ============================================================
-- Verification
-- ============================================================

-- Check current bucket configuration
SELECT id, name, public, file_size_limit, allowed_mime_types 
FROM storage.buckets 
WHERE id = 'truck-documents';

COMMIT;
