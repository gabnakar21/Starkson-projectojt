  -- Add missing trailer_documents table
  DROP TABLE IF EXISTS public.trailer_documents CASCADE;

  CREATE TABLE public.trailer_documents (
      id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
      plate_no TEXT NOT NULL,
      document_type TEXT NOT NULL CHECK (document_type IN ('OR', 'CR', 'INSURANCE', 'REGISTRATION', 'OTHER')),
      file_url TEXT NOT NULL,
      file_path TEXT,
      file_name TEXT,
      file_size INTEGER,
      upload_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
      is_active BOOLEAN DEFAULT true,
      uploaded_by TEXT,
      expires_date DATE,
      notes TEXT,
      created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
      updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
  );

  ALTER TABLE public.trailer_documents DISABLE ROW LEVEL SECURITY;

  -- Create indexes for better performance
  CREATE INDEX idx_trailer_documents_plate ON public.trailer_documents(plate_no);
  CREATE INDEX idx_trailer_documents_type ON public.trailer_documents(document_type);
  CREATE INDEX idx_trailer_documents_active ON public.trailer_documents(is_active);
  CREATE INDEX idx_trailer_documents_plate_type_active ON public.trailer_documents(plate_no, document_type, is_active);

  -- TRAILER DOCUMENTS TABLE POLICIES
  DROP POLICY IF EXISTS "Enable read access for all users" ON public.trailer_documents;
  DROP POLICY IF EXISTS "Enable insert for admin users only" ON public.trailer_documents;
  DROP POLICY IF EXISTS "Enable update for admin users only" ON public.trailer_documents;
  DROP POLICY IF EXISTS "Enable delete for admin users only" ON public.trailer_documents;

  CREATE POLICY "Enable read access for all users" ON public.trailer_documents
    FOR SELECT
    USING (true);

  CREATE POLICY "Enable insert for admin users only" ON public.trailer_documents
    FOR INSERT
    WITH CHECK (is_admin_from_session());

  CREATE POLICY "Enable update for admin users only" ON public.trailer_documents
    FOR UPDATE
    USING (is_admin_from_session())
    WITH CHECK (is_admin_from_session());

  CREATE POLICY "Enable delete for admin users only" ON public.trailer_documents
    FOR DELETE
    USING (is_admin_from_session());

  -- Create a function to automatically update the updated_at timestamp
  CREATE OR REPLACE FUNCTION update_trailer_documents_updated_at()
    RETURNS TRIGGER AS $$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $$ language 'plpgsql';

  -- Create trigger to automatically update updated_at
  CREATE TRIGGER update_trailer_documents_updated_at 
      BEFORE UPDATE ON public.trailer_documents
      FOR EACH ROW 
      EXECUTE FUNCTION update_trailer_documents_updated_at();

  -- Insert sample trailer documents data
  INSERT INTO public.trailer_documents (plate_no, document_type, file_url, file_name, is_active) VALUES
  ('TRL-001', 'OR', 'https://example.com/docs/TRL-001_OR.pdf', 'TRL-001_Official_Receipt.pdf', true),
  ('TRL-001', 'CR', 'https://example.com/docs/TRL-001_CR.pdf', 'TRL-001_Certificate_Registration.pdf', true),
  ('TRL-002', 'OR', 'https://example.com/docs/TRL-002_OR.pdf', 'TRL-002_Official_Receipt.pdf', true),
  ('TRL-002', 'CR', 'https://example.com/docs/TRL-002_CR.pdf', 'TRL-002_Certificate_Registration.pdf', true),
  ('TRL-003', 'OR', 'https://example.com/docs/TRL-003_OR.pdf', 'TRL-003_Official_Receipt.pdf', true),
  ('TRL-003', 'CR', 'https://example.com/docs/TRL-003_CR.pdf', 'TRL-003_Certificate_Registration.pdf', false); -- Inactive example

  -- Add comments for documentation
  COMMENT ON TABLE public.trailer_documents IS 'Document storage for trailer registration and other paperwork';
  COMMENT ON COLUMN public.trailer_documents.plate_no IS 'License plate number of the trailer';
  COMMENT ON COLUMN public.trailer_documents.document_type IS 'Type of document (OR, CR, INSURANCE, REGISTRATION, OTHER)';
  COMMENT ON COLUMN public.trailer_documents.file_url IS 'URL or path to the stored document file';
  COMMENT ON COLUMN public.trailer_documents.is_active IS 'Whether the document is currently active and valid';
