-- Fix Database Issues Script
-- This script fixes missing columns and table access issues

-- 1. Add missing vehicle_type column to vehicle_registry if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'vehicle_registry' AND column_name = 'vehicle_type'
  ) THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN vehicle_type TEXT DEFAULT 'truck';
    RAISE NOTICE 'vehicle_type column added to vehicle_registry table';
  END IF;
END $$;

-- 1.1. Add missing address column to vehicle_registry if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'vehicle_registry' AND column_name = 'address'
  ) THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN address TEXT;
    RAISE NOTICE 'address column added to vehicle_registry table';
  END IF;
END $$;

-- 1.2. Add all other missing columns to vehicle_registry table
DO $$
BEGIN
  -- Add missing columns one by one
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'plate') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN plate TEXT;
    RAISE NOTICE 'plate column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'model') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN model TEXT;
    RAISE NOTICE 'model column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'size') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN size TEXT;
    RAISE NOTICE 'size column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'year_model') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN year_model INTEGER;
    RAISE NOTICE 'year_model column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'plant') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN plant TEXT;
    RAISE NOTICE 'plant column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'engine_no') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN engine_no TEXT;
    RAISE NOTICE 'engine_no column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'chassi_no') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN chassi_no TEXT;
    RAISE NOTICE 'chassi_no column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'classification') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN classification TEXT;
    RAISE NOTICE 'classification column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'vehicle_type') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN vehicle_type TEXT DEFAULT 'truck';
    RAISE NOTICE 'vehicle_type column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'color') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN color TEXT;
    RAISE NOTICE 'color column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'aircon_type') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN aircon_type TEXT;
    RAISE NOTICE 'aircon_type column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'cr_no') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN cr_no TEXT;
    RAISE NOTICE 'cr_no column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'cr_registered') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN cr_registered DATE;
    RAISE NOTICE 'cr_registered column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'mv_file') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN mv_file TEXT;
    RAISE NOTICE 'mv_file column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'denomination') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN denomination TEXT;
    RAISE NOTICE 'denomination column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'piston_displacement') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN piston_displacement TEXT;
    RAISE NOTICE 'piston_displacement column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'no_of_cylinder') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN no_of_cylinder INTEGER;
    RAISE NOTICE 'no_of_cylinder column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'fuel') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN fuel TEXT;
    RAISE NOTICE 'fuel column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'series') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN series TEXT;
    RAISE NOTICE 'series column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'body_type') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN body_type TEXT;
    RAISE NOTICE 'body_type column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'body_no') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN body_no TEXT;
    RAISE NOTICE 'body_no column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'gross_wt') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN gross_wt DECIMAL;
    RAISE NOTICE 'gross_wt column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'net_wt') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN net_wt DECIMAL;
    RAISE NOTICE 'net_wt column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'shipping_wt') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN shipping_wt DECIMAL;
    RAISE NOTICE 'shipping_wt column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'net_capacity') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN net_capacity DECIMAL;
    RAISE NOTICE 'net_capacity column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'length') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN length DECIMAL;
    RAISE NOTICE 'length column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'width') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN width DECIMAL;
    RAISE NOTICE 'width column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'height') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN height DECIMAL;
    RAISE NOTICE 'height column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'volume') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN volume DECIMAL;
    RAISE NOTICE 'volume column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'owner_name') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN owner_name TEXT;
    RAISE NOTICE 'owner_name column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'company') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN company TEXT;
    RAISE NOTICE 'company column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'no_of_years') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN no_of_years INTEGER;
    RAISE NOTICE 'no_of_years column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'pallets_cap') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN pallets_cap INTEGER;
    RAISE NOTICE 'pallets_cap column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'tire_size_front') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN tire_size_front TEXT;
    RAISE NOTICE 'tire_size_front column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'tire_size_rear') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN tire_size_rear TEXT;
    RAISE NOTICE 'tire_size_rear column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'total_tire_front') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN total_tire_front INTEGER;
    RAISE NOTICE 'total_tire_front column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'total_tire_rear') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN total_tire_rear INTEGER;
    RAISE NOTICE 'total_tire_rear column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'autosweep') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN autosweep TEXT;
    RAISE NOTICE 'autosweep column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'easytrip') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN easytrip TEXT;
    RAISE NOTICE 'easytrip column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'gps_type') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN gps_type TEXT;
    RAISE NOTICE 'gps_type column added to vehicle_registry table';
  END IF;
  
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'vehicle_registry' AND column_name = 'remarks') THEN
    ALTER TABLE public.vehicle_registry ADD COLUMN remarks TEXT;
    RAISE NOTICE 'remarks column added to vehicle_registry table';
  END IF;
  
  RAISE NOTICE 'All missing columns added to vehicle_registry table';
END $$;

-- 1.3. Add missing columns to containers table
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

-- 1.4. Ensure RLS is enabled and policies exist for containers table
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

-- 1.5. Ensure RLS is enabled and policies exist for vehicle_registry table
DO $$
BEGIN
  -- Enable RLS on vehicle_registry if not already enabled
  ALTER TABLE public.vehicle_registry ENABLE ROW LEVEL SECURITY;
  
  -- Drop existing policies if they exist to avoid conflicts
  DROP POLICY IF EXISTS "Enable read access for all users" ON public.vehicle_registry;
  DROP POLICY IF EXISTS "Enable insert for all users" ON public.vehicle_registry;
  DROP POLICY IF EXISTS "Enable update for all users" ON public.vehicle_registry;
  DROP POLICY IF EXISTS "Enable delete for all users" ON public.vehicle_registry;
  
  -- Create RLS policies for vehicle_registry (allow all operations for now)
  CREATE POLICY "Enable read access for all users" ON public.vehicle_registry
    FOR SELECT USING (true);
    
  CREATE POLICY "Enable insert for all users" ON public.vehicle_registry
    FOR INSERT WITH CHECK (true);
    
  CREATE POLICY "Enable update for all users" ON public.vehicle_registry
    FOR UPDATE USING (true) WITH CHECK (true);
    
  CREATE POLICY "Enable delete for all users" ON public.vehicle_registry
    FOR DELETE USING (true);
    
  RAISE NOTICE 'RLS policies created for vehicle_registry table';
END $$;

-- 2. Ensure drivers_status table exists and has proper structure
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.tables 
    WHERE table_name = 'drivers_status' AND table_schema = 'public'
  ) THEN
    CREATE TABLE public.drivers_status (
      id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      plate TEXT NOT NULL,
      driver_name TEXT,
      license_no TEXT,
      phone TEXT,
      address TEXT,
      status TEXT DEFAULT 'Active',
      hire_date DATE,
      created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
      updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    );
    
    -- Create indexes
    CREATE INDEX idx_drivers_status_plate ON public.drivers_status(plate);
    CREATE INDEX idx_drivers_status_status ON public.drivers_status(status);
    
    -- Enable RLS
    ALTER TABLE public.drivers_status ENABLE ROW LEVEL SECURITY;
    
    -- Create RLS policies
    CREATE POLICY "Enable read access for all users" ON public.drivers_status
      FOR SELECT USING (true);
    CREATE POLICY "Enable insert for all users" ON public.drivers_status
      FOR INSERT WITH CHECK (true);
    CREATE POLICY "Enable update for all users" ON public.drivers_status
      FOR UPDATE USING (true) WITH CHECK (true);
    CREATE POLICY "Enable delete for all users" ON public.drivers_status
      FOR DELETE USING (true);
    
    RAISE NOTICE 'drivers_status table created';
  ELSE
    -- Table exists, fix RLS policies if needed
    ALTER TABLE public.drivers_status ENABLE ROW LEVEL SECURITY;
    
    -- Drop existing policies if they exist to avoid conflicts
    DROP POLICY IF EXISTS "Enable read access for all users" ON public.drivers_status;
    DROP POLICY IF EXISTS "Enable insert for admin users only" ON public.drivers_status;
    DROP POLICY IF EXISTS "Enable update for admin users only" ON public.drivers_status;
    DROP POLICY IF EXISTS "Enable delete for admin users only" ON public.drivers_status;
    
    -- Create correct RLS policies
    CREATE POLICY "Enable read access for all users" ON public.drivers_status
      FOR SELECT USING (true);
    CREATE POLICY "Enable insert for all users" ON public.drivers_status
      FOR INSERT WITH CHECK (true);
    CREATE POLICY "Enable update for all users" ON public.drivers_status
      FOR UPDATE USING (true) WITH CHECK (true);
    CREATE POLICY "Enable delete for all users" ON public.drivers_status
      FOR DELETE USING (true);
    
    RAISE NOTICE 'drivers_status RLS policies fixed';
  END IF;
END $$;

-- 3. Ensure vehicle_status table exists and has proper structure
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.tables 
    WHERE table_name = 'vehicle_status' AND table_schema = 'public'
  ) THEN
    CREATE TABLE public.vehicle_status (
      id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
      plate TEXT UNIQUE NOT NULL,
      registered_date DATE NOT NULL,
      expiration_date DATE,
      truck_size TEXT,
      model TEXT,
      year INTEGER,
      no_of_years INTEGER,
      status TEXT DEFAULT 'Active',
      created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
      updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
      CONSTRAINT valid_dates CHECK (expiration_date > registered_date)
    );
    
    -- Create indexes
    CREATE INDEX idx_vehicle_status_plate ON public.vehicle_status(plate);
    CREATE INDEX idx_vehicle_status_status ON public.vehicle_status(status);
    
    -- Enable RLS
    ALTER TABLE public.vehicle_status ENABLE ROW LEVEL SECURITY;
    
    -- Create RLS policies
    CREATE POLICY "Enable read access for all users" ON public.vehicle_status
      FOR SELECT USING (true);
    CREATE POLICY "Enable insert for all users" ON public.vehicle_status
      FOR INSERT WITH CHECK (true);
    CREATE POLICY "Enable update for all users" ON public.vehicle_status
      FOR UPDATE USING (true) WITH CHECK (true);
    CREATE POLICY "Enable delete for all users" ON public.vehicle_status
      FOR DELETE USING (true);
    
    RAISE NOTICE 'vehicle_status table created';
  ELSE
    -- Table exists, fix RLS policies if needed
    ALTER TABLE public.vehicle_status ENABLE ROW LEVEL SECURITY;
    
    -- Drop existing policies if they exist to avoid conflicts
    DROP POLICY IF EXISTS "Enable read access for all users" ON public.vehicle_status;
    DROP POLICY IF EXISTS "Enable insert for admin users only" ON public.vehicle_status;
    DROP POLICY IF EXISTS "Enable update for admin users only" ON public.vehicle_status;
    DROP POLICY IF EXISTS "Enable delete for admin users only" ON public.vehicle_status;
    
    -- Create correct RLS policies
    CREATE POLICY "Enable read access for all users" ON public.vehicle_status
      FOR SELECT USING (true);
    CREATE POLICY "Enable insert for all users" ON public.vehicle_status
      FOR INSERT WITH CHECK (true);
    CREATE POLICY "Enable update for all users" ON public.vehicle_status
      FOR UPDATE USING (true) WITH CHECK (true);
    CREATE POLICY "Enable delete for all users" ON public.vehicle_status
      FOR DELETE USING (true);
    
    RAISE NOTICE 'vehicle_status RLS policies fixed';
  END IF;
END $$;

-- 4. Add sample data for testing if tables are empty
DO $$
BEGIN
  -- Add sample drivers_status data if empty
  IF (SELECT COUNT(*) FROM public.drivers_status) = 0 THEN
    INSERT INTO public.drivers_status (plate, driver_name, license_no, phone, status, hire_date)
    VALUES 
    ('TRK-001', 'John Driver', 'LIC-001', '123-456-7890', 'Active', '2023-01-15'),
    ('TRK-002', 'Jane Driver', 'LIC-002', '234-567-8901', 'Active', '2023-02-20'),
    ('TRK-003', 'Bob Driver', 'LIC-003', '345-678-9012', 'Active', '2023-03-10');
    RAISE NOTICE 'Sample drivers_status data added';
  END IF;
  
  -- Add sample vehicle_status data if empty
  IF (SELECT COUNT(*) FROM public.vehicle_status) = 0 THEN
    INSERT INTO public.vehicle_status (plate, registered_date, expiration_date, truck_size, model, year, status)
    VALUES 
    ('TRK-001', '2023-01-01', '2024-01-01', '10ft', 'Isuzu', 2020, 'Active'),
    ('TRK-002', '2023-02-01', '2024-02-01', '20ft', 'Hino', 2021, 'Active'),
    ('TRK-003', '2023-03-01', '2024-03-01', '40ft', 'Mitsubishi', 2019, 'Active');
    RAISE NOTICE 'Sample vehicle_status data added';
  END IF;
END $$;

-- 5. Verify table structures
SELECT 'vehicle_registry' as table_name, column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'vehicle_registry' 
ORDER BY ordinal_position;

SELECT 'drivers_status' as table_name, column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'drivers_status' 
ORDER BY ordinal_position;

SELECT 'vehicle_status' as table_name, column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'vehicle_status' 
ORDER BY ordinal_position;
