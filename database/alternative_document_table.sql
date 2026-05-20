-- Alternative: Create separate document table
-- This might work if you have CREATE TABLE permissions

CREATE TABLE IF NOT EXISTS public.vehicle_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    plate TEXT NOT NULL REFERENCES vehicle_registry(plate),
    document_type TEXT NOT NULL CHECK (document_type IN ('or', 'cr')),
    file_url TEXT,
    file_name TEXT,
    uploaded_at TIMESTAMPTZ DEFAULT NOW(),
    created_by TEXT,
    CONSTRAINT unique_plate_document UNIQUE (plate, document_type)
);

-- Grant permissions
GRANT ALL ON TABLE public.vehicle_documents TO authenticated;
GRANT ALL ON TABLE public.vehicle_documents TO service_role;
