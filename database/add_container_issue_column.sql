-- Add container_issue column to containers table
-- This fixes the error when adding containers with issue information

DO $$
BEGIN
  -- Add container_issue column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'containers' AND column_name = 'container_issue'
  ) THEN
    ALTER TABLE public.containers ADD COLUMN container_issue TEXT DEFAULT NULL;
    
    -- Log the change
    RAISE NOTICE 'container_issue column added to containers table';
  ELSE
    RAISE NOTICE 'container_issue column already exists in containers table';
  END IF;
END $$;

-- Update existing containers to have NULL container_issue (optional)
-- UPDATE public.containers SET container_issue = NULL WHERE container_issue IS NULL;
