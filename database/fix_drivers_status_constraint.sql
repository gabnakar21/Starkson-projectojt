-- Fix drivers_status_status_check constraint to include ACTIVE status
-- The code uses 'ACTIVE' as a default status value, but the constraint doesn't allow it

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

-- Add new check constraint with ACTIVE included
ALTER TABLE public.drivers_status 
ADD CONSTRAINT drivers_status_status_check 
CHECK (status IN ('OPERATIONAL', 'OPERATIONAL/HUSTLING', 'DOWN', 'TOTALLY DOWN', 'ACTIVE'));
