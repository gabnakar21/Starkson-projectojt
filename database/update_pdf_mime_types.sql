-- Update PDF MIME Types for Truck Documents Bucket
-- Run this SQL in your Supabase SQL Editor to fix PDF upload issue

-- ============================================================
-- Update allowed MIME types for truck-documents bucket
-- ============================================================

UPDATE storage.buckets 
SET allowed_mime_types = ARRAY['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'application/pdf']
WHERE id = 'truck-documents';

-- ============================================================
-- Verification query (optional)
-- ============================================================

-- Check the updated configuration
SELECT id, name, public, file_size_limit, allowed_mime_types 
FROM storage.buckets 
WHERE id = 'truck-documents';

COMMIT;
