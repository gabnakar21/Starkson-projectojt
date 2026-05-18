-- Add trailer_issue column to trailers table
-- This fixes the error when adding trailers with issue information

DO $$
BEGIN
  -- Add trailer_issue column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'trailers' AND column_name = 'trailer_issue'
  ) THEN
    ALTER TABLE public.trailers ADD COLUMN trailer_issue TEXT DEFAULT NULL;
    
    -- Log the change
    RAISE NOTICE 'trailer_issue column added to trailers table';
  ELSE
    RAISE NOTICE 'trailer_issue column already exists in trailers table';
  END IF;
END $$;

-- Update existing trailers to have NULL trailer_issue (optional)
-- UPDATE public.trailers SET trailer_issue = NULL WHERE trailer_issue IS NULL;
