-- Fix vehicle_status table access issues
-- Run this script in your Supabase SQL Editor to resolve 406 errors

-- Step 1: Check if vehicle_status table exists
SELECT 
    table_name, 
    table_schema,
    table_type
FROM information_schema.tables 
WHERE table_name = 'vehicle_status' 
    AND table_schema = 'public';

-- Step 2: If table doesn't exist, create it
DO $$
BEGIN
IF NOT EXISTS (
    SELECT 1 FROM information_schema.tables 
    WHERE table_name = 'vehicle_status' 
    AND table_schema = 'public'
) THEN
    -- Create vehicle_status table
    CREATE TABLE public.vehicle_status (
        id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        plate TEXT UNIQUE NOT NULL REFERENCES public.vehicle_registry (plate) ON DELETE CASCADE,
        registered_date DATE NOT NULL,
        expiration_date DATE,
        CONSTRAINT valid_dates CHECK (expiration_date > registered_date)
    );
    
    -- Create indexes for faster lookups
    CREATE INDEX idx_vehicle_status_plate ON public.vehicle_status(plate);
    CREATE INDEX idx_vehicle_status_expiration ON public.vehicle_status(expiration_date);
    
    -- Disable Row Level Security temporarily
    ALTER TABLE public.vehicle_status DISABLE ROW LEVEL SECURITY;
END IF;
END $$;

-- Step 3: Enable RLS policies for vehicle_status table
ALTER TABLE public.vehicle_status ENABLE ROW LEVEL SECURITY;

-- Step 4: Create RLS policies
CREATE POLICY "Enable read access for all users" ON public.vehicle_status
    FOR SELECT
    USING (true);

CREATE POLICY "Enable insert for admin users only" ON public.vehicle_status
    FOR INSERT
    WITH CHECK (is_admin_from_session());

CREATE POLICY "Enable update for admin users only" ON public.vehicle_status
    FOR UPDATE
    USING (is_admin_from_session())
    WITH CHECK (is_admin_from_session());

CREATE POLICY "Enable delete for admin users only" ON public.vehicle_status
    FOR DELETE
    USING (is_admin_from_session());

-- Step 5: Verify table structure
SELECT 
    column_name, 
    data_type, 
    is_nullable,
    column_default
FROM information_schema.columns 
WHERE table_name = 'vehicle_status' 
    AND table_schema = 'public'
ORDER BY column_name;
