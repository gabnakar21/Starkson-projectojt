-- Create trailer_documents table for storing O/R and C/R PDF files
-- This table will store document images for trailers

-- Drop table if it exists (for testing purposes)
DROP TABLE IF EXISTS public.trailer_documents;

-- Create the trailer_documents table
CREATE TABLE public.trailer_documents (
    id SERIAL PRIMARY KEY,
    plate_no VARCHAR(50) NOT NULL,
    document_type VARCHAR(10) NOT NULL CHECK (document_type IN ('OR', 'CR')),
    file_name VARCHAR(255),
    file_path TEXT,
    file_size BIGINT,
    mime_type VARCHAR(100),
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    uploaded_by VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    
    -- Foreign key constraint to trailer_registry
    CONSTRAINT fk_trailer_documents_plate 
        FOREIGN KEY (plate_no) 
        REFERENCES public.trailer_registry(plate_no) 
        ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_trailer_documents_plate_no ON public.trailer_documents(plate_no);
CREATE INDEX IF NOT EXISTS idx_trailer_documents_document_type ON public.trailer_documents(document_type);
CREATE INDEX IF NOT EXISTS idx_trailer_documents_upload_date ON public.trailer_documents(upload_date);
CREATE INDEX IF NOT EXISTS idx_trailer_documents_active ON public.trailer_documents(is_active);

-- Create unique constraint to prevent duplicate documents of same type for same plate
CREATE UNIQUE INDEX IF NOT EXISTS idx_trailer_documents_unique 
ON public.trailer_documents(plate_no, document_type) 
WHERE is_active = TRUE;

-- Add comments for documentation
COMMENT ON TABLE public.trailer_documents IS 'Stores O/R and C/R PDF documents for trailers';
COMMENT ON COLUMN public.trailer_documents.plate_no IS 'License plate number of the trailer';
COMMENT ON COLUMN public.trailer_documents.document_type IS 'Type of document: OR (Official Receipt) or CR (Certificate of Registration)';
COMMENT ON COLUMN public.trailer_documents.file_name IS 'Original filename of the uploaded document';
COMMENT ON COLUMN public.trailer_documents.file_path IS 'Storage path or URL of the document file';
COMMENT ON COLUMN public.trailer_documents.file_size IS 'File size in bytes';
COMMENT ON COLUMN public.trailer_documents.mime_type IS 'MIME type of the uploaded file';
COMMENT ON COLUMN public.trailer_documents.upload_date IS 'Timestamp when the document was uploaded';
COMMENT ON COLUMN public.trailer_documents.uploaded_by IS 'User who uploaded the document';
COMMENT ON COLUMN public.trailer_documents.is_active IS 'Flag to indicate if document is currently active';

-- Grant permissions (adjust as needed for your setup)
GRANT SELECT, INSERT, UPDATE, DELETE ON public.trailer_documents TO authenticated;
GRANT USAGE, SELECT ON SEQUENCE public.trailer_documents_id_seq TO authenticated;

-- Verify table structure
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'trailer_documents' 
ORDER BY ordinal_position;
