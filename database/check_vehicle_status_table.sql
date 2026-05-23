-- Check if vehicle_status table exists and its structure
SELECT 
    table_name, 
    table_schema,
    table_type
FROM information_schema.tables 
WHERE table_name = 'vehicle_status' 
    AND table_schema = 'public';

-- Check column structure
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'vehicle_status' 
    AND table_schema = 'public'
ORDER BY column_name;

-- Check existing RLS policies
SELECT policyname, cmd, permissive, roles
FROM pg_policies
WHERE tablename = 'vehicle_status'
ORDER BY policyname;
