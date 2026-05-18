-- Update trailer_documents table to change file_path from VARCHAR(500) to TEXT
-- This will allow storing large base64 encoded PDF files

-- Alter the file_path column to TEXT type
ALTER TABLE public.trailer_documents 
ALTER COLUMN file_path TYPE TEXT;

-- Update the comment for file_path column
COMMENT ON COLUMN public.trailer_documents.file_path IS 'Base64 encoded document data or storage path/URL of document file';

-- Verify the change
SELECT 
    column_name,
    data_type,
    character_maximum_length
FROM information_schema.columns 
WHERE table_name = 'trailer_documents' 
    AND column_name = 'file_path';
