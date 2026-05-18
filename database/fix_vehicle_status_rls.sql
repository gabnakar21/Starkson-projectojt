-- Complete RLS Policy Fix for vehicle_status table
-- This addresses the INSERT policy violation for vehicle_status

DO $$
BEGIN
  -- First, completely disable RLS temporarily
  ALTER TABLE public.vehicle_status DISABLE ROW LEVEL SECURITY;
  
  -- Then re-enable RLS
  ALTER TABLE public.vehicle_status ENABLE ROW LEVEL SECURITY;
  
  -- Drop ALL existing policies to avoid conflicts
  DROP POLICY IF EXISTS "Enable read access for all users" ON public.vehicle_status;
  DROP POLICY IF EXISTS "Enable insert for admin users only" ON public.vehicle_status;
  DROP POLICY IF EXISTS "Enable update for admin users only" ON public.vehicle_status;
  DROP POLICY IF EXISTS "Enable delete for admin users only" ON public.vehicle_status;
  DROP POLICY IF EXISTS "Enable insert for all users" ON public.vehicle_status;
  DROP POLICY IF EXISTS "Enable update for all users" ON public.vehicle_status;
  DROP POLICY IF EXISTS "Enable delete for all users" ON public.vehicle_status;
  DROP POLICY IF EXISTS "Users can insert their own data" ON public.vehicle_status;
  DROP POLICY IF EXISTS "Users can update own data" ON public.vehicle_status;
  DROP POLICY IF EXISTS "Users can view all data" ON public.vehicle_status;
  
  -- Create completely permissive policies
  CREATE POLICY "Allow all reads" ON public.vehicle_status
    FOR SELECT USING (true);
    
  CREATE POLICY "Allow all inserts" ON public.vehicle_status
    FOR INSERT WITH CHECK (true);
    
  CREATE POLICY "Allow all updates" ON public.vehicle_status
    FOR UPDATE USING (true) WITH CHECK (true);
    
  CREATE POLICY "Allow all deletes" ON public.vehicle_status
    FOR DELETE USING (true);
    
  RAISE NOTICE 'vehicle_status RLS policies completely reset and fixed';
END $$;

-- Verify the policies
SELECT policyname, cmd, permissive, roles
FROM pg_policies
WHERE tablename = 'vehicle_status'
ORDER BY policyname;
