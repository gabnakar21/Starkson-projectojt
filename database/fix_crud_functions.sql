-- ========================================
-- FIX CRUD FUNCTIONS - Database Updates
-- ========================================

-- Run these SQL commands in your Supabase SQL Editor to fix CRUD issues

-- 1. Add missing tables (if not already created)
-- Run add_clients_table.sql and add_trailer_registry_table.sql first

-- 2. Fix table references and constraints
-- Update existing tables to ensure proper relationships

-- Fix vehicle_registry references in other tables
DO $$
BEGIN
    -- Update drivers_status table to reference vehicle_registry instead of vehicles
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'drivers_status') THEN
        -- Check if foreign key constraint exists and update if needed
        IF NOT EXISTS (
            SELECT 1 FROM information_schema.table_constraints 
            WHERE table_name = 'drivers_status' 
            AND constraint_name = 'drivers_status_plate_fkey'
        ) THEN
            -- Add proper foreign key constraint
            ALTER TABLE public.drivers_status 
            ADD CONSTRAINT drivers_status_plate_fkey 
            FOREIGN KEY (plate) REFERENCES public.vehicle_registry(plate) ON DELETE CASCADE;
        END IF;
    END IF;
END $$;

-- 3. Ensure all tables have proper RLS policies
-- This should already be handled by the individual table creation scripts

-- 4. Add missing indexes for performance
CREATE INDEX IF NOT EXISTS idx_clients_plant_destination ON public.clients(plant, destination);
CREATE INDEX IF NOT EXISTS idx_trailer_registry_plate_container ON public.trailer_registry(plate_no, container);

-- 5. Verify sample data exists
INSERT INTO public.clients (plant, destination, address, going_to, going_back, total_km, average_time) 
SELECT 'DISNEY 3', 'Sample Destination', 'Sample Address', '08:00 AM', '05:00 PM', 100.5, '9 hours'
WHERE NOT EXISTS (SELECT 1 FROM public.clients LIMIT 1);

-- 6. Function to validate CRUD operations
CREATE OR REPLACE FUNCTION validate_crud_operation(table_name TEXT, operation TEXT)
RETURNS BOOLEAN AS $$
BEGIN
    -- Check if table exists
    IF NOT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = table_name) THEN
        RAISE EXCEPTION 'Table % does not exist', table_name;
        RETURN FALSE;
    END IF;
    
    -- Check if user is admin for write operations
    IF operation IN ('INSERT', 'UPDATE', 'DELETE') THEN
        IF NOT is_admin_from_session() THEN
            RAISE EXCEPTION 'Admin privileges required for % operation', operation;
            RETURN FALSE;
        END IF;
    END IF;
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 7. Add helpful comments
COMMENT ON TABLE public.clients IS 'Client information for transportation management';
COMMENT ON TABLE public.trailer_registry IS 'Trailer registry with container assignments and status tracking';

-- 8. Create trigger functions for audit logging (optional)
CREATE OR REPLACE FUNCTION log_crud_operation()
RETURNS TRIGGER AS $$
BEGIN
    -- Log the operation to an audit table if needed
    -- For now, just return the data
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
