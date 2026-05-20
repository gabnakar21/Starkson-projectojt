-- For Supabase, grant permissions to standard roles
-- Run this as the database owner
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO service_role;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;

-- If you need to grant to a specific user, replace with actual username:
-- GRANT ALL PRIVILEGES ON TABLE public.drivers_status TO your_actual_username;
