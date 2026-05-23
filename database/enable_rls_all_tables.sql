-- Comprehensive RLS Enable Script for All Tables
-- This script enables Row Level Security on all tables and creates permissive policies
-- Run this in your Supabase SQL Editor

DO $$
DECLARE
  table_record RECORD;
BEGIN
  -- Enable RLS on all public tables
  FOR table_record IN 
    SELECT tablename 
    FROM pg_tables 
    WHERE schemaname = 'public' 
    AND tablename NOT LIKE 'pg_%'
  LOOP
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', table_record.tablename);
    RAISE NOTICE 'Enabled RLS on table: %', table_record.tablename;
  END LOOP;
END $$;

-- Drop all existing policies to avoid conflicts
DO $$
DECLARE
  policy_record RECORD;
BEGIN
  FOR policy_record IN 
    SELECT policyname, tablename 
    FROM pg_policies 
    WHERE schemaname = 'public'
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON public.%I', policy_record.policyname, policy_record.tablename);
    RAISE NOTICE 'Dropped policy: % on table: %', policy_record.policyname, policy_record.tablename;
  END LOOP;
END $$;

-- Create permissive policies for all tables
DO $$
DECLARE
  table_record RECORD;
BEGIN
  FOR table_record IN 
    SELECT tablename 
    FROM pg_tables 
    WHERE schemaname = 'public' 
    AND tablename NOT LIKE 'pg_%'
  LOOP
    -- Create SELECT policy
    EXECUTE format('CREATE POLICY "Allow all reads on %I" ON public.%I FOR SELECT USING (true)', 
                   table_record.tablename, table_record.tablename);
    
    -- Create INSERT policy
    EXECUTE format('CREATE POLICY "Allow all inserts on %I" ON public.%I FOR INSERT WITH CHECK (true)', 
                   table_record.tablename, table_record.tablename);
    
    -- Create UPDATE policy
    EXECUTE format('CREATE POLICY "Allow all updates on %I" ON public.%I FOR UPDATE USING (true) WITH CHECK (true)', 
                   table_record.tablename, table_record.tablename);
    
    -- Create DELETE policy
    EXECUTE format('CREATE POLICY "Allow all deletes on %I" ON public.%I FOR DELETE USING (true)', 
                   table_record.tablename, table_record.tablename);
    
    RAISE NOTICE 'Created policies for table: %', table_record.tablename;
  END LOOP;
END $$;

-- Verify the policies
SELECT 
  schemaname, 
  tablename, 
  policyname, 
  permissive, 
  roles, 
  cmd 
FROM pg_policies 
WHERE schemaname = 'public'
ORDER BY tablename, policyname;
