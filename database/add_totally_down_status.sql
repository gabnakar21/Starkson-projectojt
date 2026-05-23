-- Add TOTALLY DOWN status to all status check constraints
-- Run this script in your Supabase SQL Editor

-- Update containers table status check constraint
DO $$
BEGIN
  -- Drop existing constraint if it exists
  IF EXISTS (
    SELECT 1 FROM information_schema.table_constraints 
    WHERE table_name = 'containers' AND constraint_name = 'containers_status_check'
  ) THEN
    ALTER TABLE public.containers DROP CONSTRAINT containers_status_check;
    RAISE NOTICE 'Dropped containers_status_check constraint';
  END IF;
END $$;

-- Add new check constraint with TOTALLY DOWN included
ALTER TABLE public.containers 
ADD CONSTRAINT containers_status_check 
CHECK (status IS NULL OR status IN ('OPERATIONAL', 'OPERATIONAL/HUSTLING', 'DOWN', 'TOTALLY DOWN', 'Active', 'Inactive', 'Maintenance', 'Repair', 'Available', 'Unavailable', 'In Use', 'Out of Service'));

-- Update trailer_registry table status check constraint
DO $$
BEGIN
  -- Drop existing constraint if it exists
  IF EXISTS (
    SELECT 1 FROM information_schema.table_constraints 
    WHERE table_name = 'trailer_registry' AND constraint_name = 'trailer_registry_status_check'
  ) THEN
    ALTER TABLE public.trailer_registry DROP CONSTRAINT trailer_registry_status_check;
    RAISE NOTICE 'Dropped trailer_registry_status_check constraint';
  END IF;
END $$;

-- Add new check constraint with TOTALLY DOWN included
ALTER TABLE public.trailer_registry 
ADD CONSTRAINT trailer_registry_status_check 
CHECK (status IS NULL OR status IN ('OPERATIONAL', 'OPERATIONAL/HUSTLING', 'DOWN', 'TOTALLY DOWN', 'Active', 'Inactive', 'Maintenance', 'Repair', 'Available', 'Unavailable', 'In Use', 'Out of Service'));

-- Update drivers_status table status check constraint
DO $$
BEGIN
  -- Drop existing constraint if it exists
  IF EXISTS (
    SELECT 1 FROM information_schema.table_constraints 
    WHERE table_name = 'drivers_status' AND constraint_name = 'drivers_status_status_check'
  ) THEN
    ALTER TABLE public.drivers_status DROP CONSTRAINT drivers_status_status_check;
    RAISE NOTICE 'Dropped drivers_status_status_check constraint';
  END IF;
END $$;

-- Add new check constraint with TOTALLY DOWN included
ALTER TABLE public.drivers_status 
ADD CONSTRAINT drivers_status_status_check 
CHECK (status IN ('OPERATIONAL', 'OPERATIONAL/HUSTLING', 'DOWN', 'TOTALLY DOWN'));

-- Update trailer_registry inline check constraint (if it exists as a named constraint)
DO $$
BEGIN
  -- Check if there's an inline check constraint that needs to be updated
  -- This handles the case where the constraint was created inline in the table definition
  IF EXISTS (
    SELECT 1 FROM information_schema.table_constraints 
    WHERE table_name = 'trailer_registry' AND constraint_name LIKE '%trailer_registry_status%'
  ) THEN
    -- Drop any remaining status-related constraints
    DECLARE 
      constraint_rec RECORD;
    BEGIN
      FOR constraint_rec IN 
        SELECT constraint_name 
        FROM information_schema.table_constraints 
        WHERE table_name = 'trailer_registry' 
        AND constraint_name LIKE '%status%'
      LOOP
        EXECUTE 'ALTER TABLE public.trailer_registry DROP CONSTRAINT ' || constraint_rec.constraint_name;
        RAISE NOTICE 'Dropped constraint: %', constraint_rec.constraint_name;
      END LOOP;
    END;
  END IF;
END $$;

-- Re-add the comprehensive check constraint for trailer_registry
ALTER TABLE public.trailer_registry 
ADD CONSTRAINT trailer_registry_status_check 
CHECK (status IS NULL OR status IN ('OPERATIONAL', 'OPERATIONAL/HUSTLING', 'DOWN', 'TOTALLY DOWN', 'Active', 'Inactive', 'Maintenance', 'Repair', 'Available', 'Unavailable', 'In Use', 'Out of Service'));

-- Verification queries
SELECT 'containers table' as table_name, 
       column_name, 
       data_type, 
       is_nullable
FROM information_schema.columns 
WHERE table_name = 'containers' AND column_name = 'status';

SELECT 'trailer_registry table' as table_name, 
       column_name, 
       data_type, 
       is_nullable
FROM information_schema.columns 
WHERE table_name = 'trailer_registry' AND column_name = 'status';

SELECT 'drivers_status table' as table_name, 
       column_name, 
       data_type, 
       is_nullable
FROM information_schema.columns 
WHERE table_name = 'drivers_status' AND column_name = 'status';

-- Check constraints
SELECT 
    tc.table_name,
    tc.constraint_name,
    cc.check_clause
FROM information_schema.table_constraints tc
JOIN information_schema.check_constraints cc ON tc.constraint_name = cc.constraint_name
WHERE tc.table_name IN ('containers', 'trailer_registry', 'drivers_status')
AND tc.constraint_type = 'CHECK'
ORDER BY tc.table_name, tc.constraint_name;
