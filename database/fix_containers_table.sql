-- Fix Containers Table Script
-- This script specifically fixes the missing columns in the containers table

-- Add missing columns to containers table
DO $$
BEGIN
  -- Add missing columns one by one
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'containers' AND column_name = 'container_number') THEN
    ALTER TABLE public.containers ADD COLUMN container_number TEXT;
    RAISE NOTICE 'container_number column added to containers table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'containers' AND column_name = 'chassi_no') THEN
    ALTER TABLE public.containers ADD COLUMN chassi_no TEXT;
    RAISE NOTICE 'chassi_no column added to containers table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'containers' AND column_name = 'color') THEN
    ALTER TABLE public.containers ADD COLUMN color TEXT;
    RAISE NOTICE 'color column added to containers table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'containers' AND column_name = 'size') THEN
    ALTER TABLE public.containers ADD COLUMN size TEXT;
    RAISE NOTICE 'size column added to containers table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'containers' AND column_name = 'remarks') THEN
    ALTER TABLE public.containers ADD COLUMN remarks TEXT;
    RAISE NOTICE 'remarks column added to containers table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'containers' AND column_name = 'container_issue') THEN
    ALTER TABLE public.containers ADD COLUMN container_issue TEXT;
    RAISE NOTICE 'container_issue column added to containers table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'containers' AND column_name = 'status') THEN
    ALTER TABLE public.containers ADD COLUMN status TEXT DEFAULT 'Active';
    RAISE NOTICE 'status column added to containers table';
  END IF;
  
  RAISE NOTICE 'All missing columns added to containers table';
END $$;

-- Fix RLS policies for containers table
DO $$
BEGIN
  -- Enable RLS on containers if not already enabled
  ALTER TABLE public.containers ENABLE ROW LEVEL SECURITY;
  
  -- Drop existing policies if they exist to avoid conflicts
  DROP POLICY IF EXISTS "Enable read access for all users" ON public.containers;
  DROP POLICY IF EXISTS "Enable insert for admin users only" ON public.containers;
  DROP POLICY IF EXISTS "Enable update for admin users only" ON public.containers;
  DROP POLICY IF EXISTS "Enable delete for admin users only" ON public.containers;
  DROP POLICY IF EXISTS "Enable insert for all users" ON public.containers;
  DROP POLICY IF EXISTS "Enable update for all users" ON public.containers;
  DROP POLICY IF EXISTS "Enable delete for all users" ON public.containers;
  
  -- Create RLS policies for containers (allow all operations for now)
  CREATE POLICY "Enable read access for all users" ON public.containers
    FOR SELECT USING (true);
    
  CREATE POLICY "Enable insert for all users" ON public.containers
    FOR INSERT WITH CHECK (true);
    
  CREATE POLICY "Enable update for all users" ON public.containers
    FOR UPDATE USING (true) WITH CHECK (true);
    
  CREATE POLICY "Enable delete for all users" ON public.containers
    FOR DELETE USING (true);
    
  RAISE NOTICE 'RLS policies created for containers table';
END $$;

-- Verify the containers table structure
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'containers' 
    AND table_schema = 'public'
ORDER BY ordinal_position;
