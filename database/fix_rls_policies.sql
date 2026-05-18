-- Quick Fix for RLS Policies
-- This script specifically fixes the 406 Not Acceptable errors
-- Run this script immediately to resolve access issues

-- Fix drivers_status table RLS policies
DO $$
BEGIN
  -- Enable RLS
  ALTER TABLE public.drivers_status ENABLE ROW LEVEL SECURITY;
  
  -- Drop existing policies (all possible policy names)
  DROP POLICY IF EXISTS "Enable read access for all users" ON public.drivers_status;
  DROP POLICY IF EXISTS "Enable insert for admin users only" ON public.drivers_status;
  DROP POLICY IF EXISTS "Enable update for admin users only" ON public.drivers_status;
  DROP POLICY IF EXISTS "Enable delete for admin users only" ON public.drivers_status;
  DROP POLICY IF EXISTS "Enable insert for all users" ON public.drivers_status;
  DROP POLICY IF EXISTS "Enable update for all users" ON public.drivers_status;
  DROP POLICY IF EXISTS "Enable delete for all users" ON public.drivers_status;
  
  -- Create new policies that allow access
  CREATE POLICY "Enable read access for all users" ON public.drivers_status
    FOR SELECT USING (true);
  CREATE POLICY "Enable insert for all users" ON public.drivers_status
    FOR INSERT WITH CHECK (true);
  CREATE POLICY "Enable update for all users" ON public.drivers_status
    FOR UPDATE USING (true) WITH CHECK (true);
  CREATE POLICY "Enable delete for all users" ON public.drivers_status
    FOR DELETE USING (true);
    
  RAISE NOTICE 'drivers_status RLS policies fixed';
END $$;

-- Fix vehicle_status table RLS policies
DO $$
BEGIN
  -- Enable RLS
  ALTER TABLE public.vehicle_status ENABLE ROW LEVEL SECURITY;
  
  -- Drop existing policies (all possible policy names)
  DROP POLICY IF EXISTS "Enable read access for all users" ON public.vehicle_status;
  DROP POLICY IF EXISTS "Enable insert for admin users only" ON public.vehicle_status;
  DROP POLICY IF EXISTS "Enable update for admin users only" ON public.vehicle_status;
  DROP POLICY IF EXISTS "Enable delete for admin users only" ON public.vehicle_status;
  DROP POLICY IF EXISTS "Enable insert for all users" ON public.vehicle_status;
  DROP POLICY IF EXISTS "Enable update for all users" ON public.vehicle_status;
  DROP POLICY IF EXISTS "Enable delete for all users" ON public.vehicle_status;
  
  -- Create new policies that allow access
  CREATE POLICY "Enable read access for all users" ON public.vehicle_status
    FOR SELECT USING (true);
  CREATE POLICY "Enable insert for all users" ON public.vehicle_status
    FOR INSERT WITH CHECK (true);
  CREATE POLICY "Enable update for all users" ON public.vehicle_status
    FOR UPDATE USING (true) WITH CHECK (true);
  CREATE POLICY "Enable delete for all users" ON public.vehicle_status
    FOR DELETE USING (true);
    
  RAISE NOTICE 'vehicle_status RLS policies fixed';
END $$;

-- Verify the policies are in place
SELECT 
  schemaname, 
  tablename, 
  policyname, 
  permissive, 
  roles, 
  cmd, 
  qual
FROM pg_policies 
WHERE tablename IN ('drivers_status', 'vehicle_status')
ORDER BY tablename, policyname;
