-- Enable RLS Policies for All Tables
-- This script enables Row Level Security while maintaining current functionality
-- Run this in your Supabase SQL Editor

-- ============================================================
-- ENABLE RLS ON ALL TABLES
-- ============================================================

-- Enable RLS on vehicles table
ALTER TABLE public.vehicles ENABLE ROW LEVEL SECURITY;

-- Enable RLS on trucks table  
ALTER TABLE public.trucks ENABLE ROW LEVEL SECURITY;

-- Enable RLS on drivers table
ALTER TABLE public.drivers ENABLE ROW LEVEL SECURITY;

-- Enable RLS on vehicle_repairs table
ALTER TABLE public.vehicle_repairs ENABLE ROW LEVEL SECURITY;

-- Enable RLS on vehicle_registry table
ALTER TABLE public.vehicle_registry ENABLE ROW LEVEL SECURITY;

-- Enable RLS on vehicle_status table
ALTER TABLE public.vehicle_status ENABLE ROW LEVEL SECURITY;

-- Enable RLS on gps_tracking table
ALTER TABLE public.gps_tracking ENABLE ROW LEVEL SECURITY;

-- Enable RLS on admin_users table
ALTER TABLE public.admin_users ENABLE ROW LEVEL SECURITY;

-- Enable RLS on user_sessions table
ALTER TABLE public.user_sessions ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- SIMPLE OPEN POLICIES (Mimic RLS OFF behavior)
-- ============================================================

-- Vehicles table - Allow all operations
DROP POLICY IF EXISTS "Allow all read" ON public.vehicles;
DROP POLICY IF EXISTS "Allow all insert" ON public.vehicles;
DROP POLICY IF EXISTS "Allow all update" ON public.vehicles;
DROP POLICY IF EXISTS "Allow all delete" ON public.vehicles;

CREATE POLICY "Allow all read" ON public.vehicles
  FOR SELECT
  USING (true);

CREATE POLICY "Allow all insert" ON public.vehicles
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow all update" ON public.vehicles
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow all delete" ON public.vehicles
  FOR DELETE
  USING (true);

-- Trucks table - Allow all operations
DROP POLICY IF EXISTS "Allow all read" ON public.trucks;
DROP POLICY IF EXISTS "Allow all insert" ON public.trucks;
DROP POLICY IF EXISTS "Allow all update" ON public.trucks;
DROP POLICY IF EXISTS "Allow all delete" ON public.trucks;

CREATE POLICY "Allow all read" ON public.trucks
  FOR SELECT
  USING (true);

CREATE POLICY "Allow all insert" ON public.trucks
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow all update" ON public.trucks
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow all delete" ON public.trucks
  FOR DELETE
  USING (true);

-- Drivers table - Allow all operations
DROP POLICY IF EXISTS "Allow all read" ON public.drivers;
DROP POLICY IF EXISTS "Allow all insert" ON public.drivers;
DROP POLICY IF EXISTS "Allow all update" ON public.drivers;
DROP POLICY IF EXISTS "Allow all delete" ON public.drivers;

CREATE POLICY "Allow all read" ON public.drivers
  FOR SELECT
  USING (true);

CREATE POLICY "Allow all insert" ON public.drivers
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow all update" ON public.drivers
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow all delete" ON public.drivers
  FOR DELETE
  USING (true);

-- Vehicle repairs table - Allow all operations
DROP POLICY IF EXISTS "Allow all read" ON public.vehicle_repairs;
DROP POLICY IF EXISTS "Allow all insert" ON public.vehicle_repairs;
DROP POLICY IF EXISTS "Allow all update" ON public.vehicle_repairs;
DROP POLICY IF EXISTS "Allow all delete" ON public.vehicle_repairs;

CREATE POLICY "Allow all read" ON public.vehicle_repairs
  FOR SELECT
  USING (true);

CREATE POLICY "Allow all insert" ON public.vehicle_repairs
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow all update" ON public.vehicle_repairs
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow all delete" ON public.vehicle_repairs
  FOR DELETE
  USING (true);

-- Vehicle registry table - Allow all operations
DROP POLICY IF EXISTS "Allow all read" ON public.vehicle_registry;
DROP POLICY IF EXISTS "Allow all insert" ON public.vehicle_registry;
DROP POLICY IF EXISTS "Allow all update" ON public.vehicle_registry;
DROP POLICY IF EXISTS "Allow all delete" ON public.vehicle_registry;

CREATE POLICY "Allow all read" ON public.vehicle_registry
  FOR SELECT
  USING (true);

CREATE POLICY "Allow all insert" ON public.vehicle_registry
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow all update" ON public.vehicle_registry
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow all delete" ON public.vehicle_registry
  FOR DELETE
  USING (true);

-- Vehicle status table - Allow all operations
DROP POLICY IF EXISTS "Allow all read" ON public.vehicle_status;
DROP POLICY IF EXISTS "Allow all insert" ON public.vehicle_status;
DROP POLICY IF EXISTS "Allow all update" ON public.vehicle_status;
DROP POLICY IF EXISTS "Allow all delete" ON public.vehicle_status;

CREATE POLICY "Allow all read" ON public.vehicle_status
  FOR SELECT
  USING (true);

CREATE POLICY "Allow all insert" ON public.vehicle_status
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow all update" ON public.vehicle_status
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow all delete" ON public.vehicle_status
  FOR DELETE
  USING (true);

-- GPS tracking table - Allow all operations
DROP POLICY IF EXISTS "Allow all read" ON public.gps_tracking;
DROP POLICY IF EXISTS "Allow all insert" ON public.gps_tracking;
DROP POLICY IF EXISTS "Allow all update" ON public.gps_tracking;
DROP POLICY IF EXISTS "Allow all delete" ON public.gps_tracking;

CREATE POLICY "Allow all read" ON public.gps_tracking
  FOR SELECT
  USING (true);

CREATE POLICY "Allow all insert" ON public.gps_tracking
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow all update" ON public.gps_tracking
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow all delete" ON public.gps_tracking
  FOR DELETE
  USING (true);

-- Admin users table - Allow all operations (for session management)
DROP POLICY IF EXISTS "Allow all read" ON public.admin_users;
DROP POLICY IF EXISTS "Allow all insert" ON public.admin_users;
DROP POLICY IF EXISTS "Allow all update" ON public.admin_users;
DROP POLICY IF EXISTS "Allow all delete" ON public.admin_users;

CREATE POLICY "Allow all read" ON public.admin_users
  FOR SELECT
  USING (true);

CREATE POLICY "Allow all insert" ON public.admin_users
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow all update" ON public.admin_users
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow all delete" ON public.admin_users
  FOR DELETE
  USING (true);

-- User sessions table - Allow all operations
DROP POLICY IF EXISTS "Allow all read" ON public.user_sessions;
DROP POLICY IF EXISTS "Allow all insert" ON public.user_sessions;
DROP POLICY IF EXISTS "Allow all update" ON public.user_sessions;
DROP POLICY IF EXISTS "Allow all delete" ON public.user_sessions;

CREATE POLICY "Allow all read" ON public.user_sessions
  FOR SELECT
  USING (true);

CREATE POLICY "Allow all insert" ON public.user_sessions
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "Allow all update" ON public.user_sessions
  FOR UPDATE
  USING (true)
  WITH CHECK (true);

CREATE POLICY "Allow all delete" ON public.user_sessions
  FOR DELETE
  USING (true);

-- ============================================================
-- VERIFICATION QUERIES
-- ============================================================

-- Check RLS status on all tables
SELECT 
    schemaname,
    tablename,
    rowsecurity as rls_enabled
FROM pg_tables 
WHERE schemaname = 'public'
AND tablename IN (
    'vehicles', 'trucks', 'drivers', 'vehicle_repairs', 
    'vehicle_registry', 'vehicle_status', 'gps_tracking',
    'admin_users', 'user_sessions'
)
ORDER BY tablename;

-- Check policies on vehicles table (as example)
SELECT 
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual as using_condition,
    with_check
FROM pg_policies 
WHERE tablename = 'vehicles'
AND schemaname = 'public';

-- ============================================================
-- COMPLETION MESSAGE
-- ============================================================

-- RLS is now enabled on all tables with open policies
-- Your application should work exactly the same as before
-- The database is now ready for future security improvements
