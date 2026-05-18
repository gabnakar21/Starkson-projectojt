-- Add trailer status columns to trailer_registry table
-- This script adds the necessary columns for user input functionality

-- First, drop any existing check constraints that might conflict
DO $$
BEGIN
  -- Drop status check constraint if it exists
  IF EXISTS (
    SELECT 1 FROM information_schema.table_constraints 
    WHERE table_name = 'trailer_registry' AND constraint_name = 'trailer_registry_status_check'
  ) THEN
    ALTER TABLE public.trailer_registry DROP CONSTRAINT trailer_registry_status_check;
    RAISE NOTICE 'Dropped trailer_registry_status_check constraint';
  END IF;
END $$;

DO $$
BEGIN
  -- Add container column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'trailer_registry' AND column_name = 'container'
  ) THEN
    ALTER TABLE public.trailer_registry ADD COLUMN container TEXT DEFAULT NULL;
    RAISE NOTICE 'container column added to trailer_registry table';
  END IF;

  -- Add remarks column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'trailer_registry' AND column_name = 'remarks'
  ) THEN
    ALTER TABLE public.trailer_registry ADD COLUMN remarks TEXT DEFAULT NULL;
    RAISE NOTICE 'remarks column added to trailer_registry table';
  END IF;

  -- Add trailer_issue column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'trailer_registry' AND column_name = 'trailer_issue'
  ) THEN
    ALTER TABLE public.trailer_registry ADD COLUMN trailer_issue TEXT DEFAULT NULL;
    RAISE NOTICE 'trailer_issue column added to trailer_registry table';
  END IF;

  -- Add status column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'trailer_registry' AND column_name = 'status'
  ) THEN
    ALTER TABLE public.trailer_registry ADD COLUMN status TEXT DEFAULT 'Active';
    RAISE NOTICE 'status column added to trailer_registry table';
  END IF;
END $$;

-- Update existing records to have default values
UPDATE public.trailer_registry 
SET 
  container = '-',
  remarks = '-',
  trailer_issue = '-',
  status = NULL
WHERE container IS NULL OR remarks IS NULL OR trailer_issue IS NULL OR status IS NULL;

-- Add new check constraint with proper status values (allowing NULL)
ALTER TABLE public.trailer_registry 
ADD CONSTRAINT trailer_registry_status_check 
CHECK (status IS NULL OR status IN ('OPERATIONAL', 'OPERATIONAL/HUSTLING', 'DOWN', 'Active', 'Inactive', 'Maintenance', 'Repair', 'Available', 'Unavailable', 'In Use', 'Out of Service'));

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_trailer_registry_status ON public.trailer_registry(status);
CREATE INDEX IF NOT EXISTS idx_trailer_registry_container ON public.trailer_registry(container);

-- Verify the table structure
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'trailer_registry' 
ORDER BY ordinal_position;
