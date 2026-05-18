-- Add missing file_path column to trailer_documents table
-- Run this script if the trailer_documents table exists but needs the file_path column

-- Add file_path column if it doesn't exist
DO $$
BEGIN
    -- Add file_path column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'trailer_documents' AND column_name = 'file_path'
    ) THEN
        ALTER TABLE public.trailer_documents ADD COLUMN file_path TEXT;
        RAISE NOTICE 'Added file_path column to trailer_documents table';
    ELSE
        RAISE NOTICE 'file_path column already exists in trailer_documents table';
    END IF;
END $$;

-- Update sample data to include file_path (copy from file_url or set default)
UPDATE public.trailer_documents 
SET file_path = file_url
WHERE file_path IS NULL AND file_url IS NOT NULL;

-- For records without file_url, set a default path
UPDATE public.trailer_documents 
SET file_path = '/documents/trailers/' || plate_no || '/' || document_type || '/' || file_name
WHERE file_path IS NULL;

-- Add index for file_path column for better query performance
CREATE INDEX IF NOT EXISTS idx_trailer_documents_file_path ON public.trailer_documents(file_path);

-- Verify the table structure
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'trailer_documents' 
ORDER BY ordinal_position;

-- Show sample data with file_path
SELECT plate_no, document_type, file_name, file_url, file_path 
FROM public.trailer_documents 
LIMIT 5;
