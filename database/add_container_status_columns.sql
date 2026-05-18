-- Add container status columns to vehicle registry container table
-- This script adds remarks, container_issue, and status fields to connect with Status page

-- First, drop any existing check constraints that might conflict
DO $$
BEGIN
  -- Drop status check constraint if it exists on containers table
  IF EXISTS (
    SELECT 1 FROM information_schema.table_constraints 
    WHERE table_name = 'containers' AND constraint_name = 'containers_status_check'
  ) THEN
    ALTER TABLE public.containers DROP CONSTRAINT containers_status_check;
    RAISE NOTICE 'Dropped containers_status_check constraint';
  END IF;
END $$;

DO $$
BEGIN
  -- Add remarks column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'containers' AND column_name = 'remarks'
  ) THEN
    ALTER TABLE public.containers ADD COLUMN remarks TEXT DEFAULT NULL;
    RAISE NOTICE 'remarks column added to containers table';
  END IF;

  -- Add container_issue column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'containers' AND column_name = 'container_issue'
  ) THEN
    ALTER TABLE public.containers ADD COLUMN container_issue TEXT DEFAULT NULL;
    RAISE NOTICE 'container_issue column added to containers table';
  END IF;

  -- Add status column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'containers' AND column_name = 'status'
  ) THEN
    ALTER TABLE public.containers ADD COLUMN status TEXT DEFAULT NULL;
    RAISE NOTICE 'status column added to containers table';
  END IF;
END $$;

-- Update existing records to have default values
UPDATE public.containers 
SET 
  remarks = '-',
  container_issue = '-',
  status = NULL
WHERE remarks IS NULL OR container_issue IS NULL OR status IS NULL;

-- Add new check constraint with proper status values (allowing NULL)
ALTER TABLE public.containers 
ADD CONSTRAINT containers_status_check 
CHECK (status IS NULL OR status IN ('OPERATIONAL', 'OPERATIONAL/HUSTLING', 'DOWN', 'Active', 'Inactive', 'Maintenance', 'Repair', 'Available', 'Unavailable', 'In Use', 'Out of Service'));

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_containers_status ON public.containers(status);
CREATE INDEX IF NOT EXISTS idx_containers_container ON public.containers(container);

-- Verify the table structure
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'containers' 
ORDER BY ordinal_position;
