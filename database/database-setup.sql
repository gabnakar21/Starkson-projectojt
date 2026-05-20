  -- Fresh Supabase Database Setup for Trucks and Repairs Management
  -- Run these SQL commands in your Supabase SQL Editor

  -- ============================================================
  -- 1. VEHICLES TABLE
  -- ============================================================
  DROP TABLE IF EXISTS public.vehicles CASCADE;

  CREATE TABLE public.vehicles (
    plate TEXT PRIMARY KEY,
    model TEXT NOT NULL,
    size TEXT NOT NULL,
    year_model INTEGER NOT NULL,
    plant TEXT NOT NULL DEFAULT 'DISNEY 3',
    image1_url TEXT,
    image2_url TEXT,
    image3_url TEXT,
    image4_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
  );

  ALTER TABLE public.vehicles DISABLE ROW LEVEL SECURITY;

  -- ============================================================
  -- 2. DRIVERS_STATUS TABLE (for driver assignments and status tracking)
  -- ============================================================
  DROP TABLE IF EXISTS public.drivers_status CASCADE;

  CREATE TABLE public.drivers_status (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    plate TEXT UNIQUE NOT NULL REFERENCES public.vehicle_registry (plate) ON DELETE CASCADE,
    driver TEXT NOT NULL,
    status TEXT DEFAULT 'OPERATIONAL' CHECK (status IN ('OPERATIONAL', 'OPERATIONAL/HUSTLING', 'DOWN')),
    truck_issue TEXT DEFAULT NULL,
    trailer_issue TEXT DEFAULT NULL,
    truck_availability TEXT DEFAULT NULL,
    date_reported DATE,
    or_image_url TEXT,
    or_image_name TEXT,
    cr_image_url TEXT,
    cr_image_name TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
  );

  ALTER TABLE public.drivers_status DISABLE ROW LEVEL SECURITY;

-- Add missing columns to existing drivers_status table if they don't exist
DO $$
BEGIN
  -- Add truck_issue column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'drivers_status' AND column_name = 'truck_issue'
  ) THEN
    ALTER TABLE public.drivers_status ADD COLUMN truck_issue TEXT DEFAULT NULL;
  END IF;

  -- Add trailer_issue column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'drivers_status' AND column_name = 'trailer_issue'
  ) THEN
    ALTER TABLE public.drivers_status ADD COLUMN trailer_issue TEXT DEFAULT NULL;
  END IF;

  -- Add truck_availability column if it doesn't exist
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'drivers_status' AND column_name = 'truck_availability'
  ) THEN
    ALTER TABLE public.drivers_status ADD COLUMN truck_availability TEXT DEFAULT NULL;
  END IF;
END $$;

  -- ============================================================
  -- 3. TRUCKS TABLE (with truck image and driver image storage)
  -- ============================================================
  DROP TABLE IF EXISTS public.trucks CASCADE;

  CREATE TABLE public.trucks (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    plate TEXT UNIQUE NOT NULL REFERENCES public.vehicle_registry (plate) ON DELETE CASCADE,
    truck_image_url TEXT,
    truck_image_path TEXT,
    driver_image_url TEXT,
    driver_image_path TEXT,
    truck_condition TEXT DEFAULT 'Good',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
  );

  ALTER TABLE public.trucks DISABLE ROW LEVEL SECURITY;

  -- ============================================================
  -- 3. DRIVERS TABLE
  -- ============================================================
  DROP TABLE IF EXISTS public.drivers CASCADE;

  CREATE TABLE public.drivers (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    plate TEXT NOT NULL REFERENCES public.vehicle_registry (plate) ON DELETE CASCADE,
    driver_name TEXT NOT NULL,
    driver_image_url TEXT,
    driver_image_path TEXT,
    license_number TEXT UNIQUE,
    phone_number TEXT,
    status TEXT DEFAULT 'Active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
  );

  ALTER TABLE public.drivers DISABLE ROW LEVEL SECURITY;

  -- ============================================================
  -- 4. VEHICLE REPAIRS TABLE
  -- ============================================================
  DROP TABLE IF EXISTS public.vehicle_repairs CASCADE;

  CREATE TABLE public.vehicle_repairs (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ir_no TEXT UNIQUE NOT NULL,
    date_reported DATE NOT NULL,
    plate TEXT NOT NULL REFERENCES public.vehicle_registry (plate) ON DELETE CASCADE,
    truck_issue TEXT NOT NULL,
    in_charge TEXT NOT NULL,
    repair_status TEXT DEFAULT 'Pending',
    date_completed DATE,
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
  );

  ALTER TABLE public.vehicle_repairs DISABLE ROW LEVEL SECURITY;

  -- ============================================================
  -- 5. TRAILERS TABLE
  -- ============================================================
  DROP TABLE IF EXISTS public.trailers CASCADE;

  CREATE TABLE public.trailers (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    plate_no TEXT NOT NULL,
    chassis_no TEXT,
    container TEXT,
    status TEXT DEFAULT 'OPERATIONAL' CHECK (status IN ('OPERATIONAL', 'OPERATIONAL/HUSTLING', 'DOWN')),
    image1_url TEXT,
    image2_url TEXT,
    image3_url TEXT,
    image4_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
  );

  ALTER TABLE public.trailers DISABLE ROW LEVEL SECURITY;

  -- ============================================================
  -- 6. CONTAINERS TABLE
  -- ============================================================
  DROP TABLE IF EXISTS public.containers CASCADE;

  CREATE TABLE public.containers (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    chassi_no TEXT NOT NULL,
    container TEXT NOT NULL,
    color TEXT,
    size TEXT,
    plant TEXT,
    status TEXT DEFAULT 'OPERATIONAL' CHECK (status IN ('OPERATIONAL', 'OPERATIONAL/HUSTLING', 'DOWN')),
    remarks TEXT,
    container_issue TEXT,
    date_reported DATE,
    image1_url TEXT,
    image2_url TEXT,
    image3_url TEXT,
    image4_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
  );

  ALTER TABLE public.containers DISABLE ROW LEVEL SECURITY;

  -- CONTAINERS TABLE POLICIES
  DROP POLICY IF EXISTS "Enable read access for all users" ON public.containers;
  DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.containers;
  DROP POLICY IF EXISTS "Enable update for authenticated users" ON public.containers;
  DROP POLICY IF EXISTS "Enable delete for authenticated users" ON public.containers;

  CREATE POLICY "Enable read access for all users" ON public.containers
    FOR SELECT
    USING (true);

  CREATE POLICY "Enable insert for admin users only" ON public.containers
    FOR INSERT
    WITH CHECK (is_admin_from_session());

  CREATE POLICY "Enable update for admin users only" ON public.containers
    FOR UPDATE
    USING (is_admin_from_session())
    WITH CHECK (is_admin_from_session());

  CREATE POLICY "Enable delete for admin users only" ON public.containers
    FOR DELETE
    USING (is_admin_from_session());

  -- Create a function to automatically update the updated_at timestamp
  CREATE OR REPLACE FUNCTION update_containers_updated_at()
    RETURNS TRIGGER AS $$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $$ language 'plpgsql';

  -- Create trigger to automatically update updated_at
  CREATE TRIGGER update_containers_updated_at 
      BEFORE UPDATE ON public.containers
      FOR EACH ROW 
      EXECUTE FUNCTION update_containers_updated_at();

  -- Insert sample container data
  INSERT INTO public.containers (chassi_no, container, color, size, status) VALUES
  ('CHS-001', 'CNT-001', 'Blue', '20ft', 'OPERATIONAL'),
  ('CHS-002', 'CNT-002', 'Red', '40ft', 'OPERATIONAL/HUSTLING'),
  ('CHS-003', 'CNT-003', 'Green', '20ft', 'DOWN'),
  ('CHS-004', 'CNT-004', 'Yellow', '40ft', 'OPERATIONAL'),
  ('CHS-005', 'CNT-005', 'White', '20ft', 'OPERATIONAL/HUSTLING');

  -- ============================================================
  -- 7. VEHICLE REGISTRY TABLE (Extended vehicle details)
  -- ============================================================
  DROP TABLE IF EXISTS public.vehicle_registry CASCADE;

  CREATE TABLE public.vehicle_registry (
    plate TEXT PRIMARY KEY,
    model TEXT NOT NULL,
    size TEXT NOT NULL,
    year_model INTEGER NOT NULL,
    plant TEXT NOT NULL DEFAULT 'DISNEY 3',
    
    -- Image URLs
    image1_url TEXT,
    image2_url TEXT,
    image3_url TEXT,
    image4_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
  );

  ALTER TABLE public.vehicle_registry DISABLE ROW LEVEL SECURITY;

  -- ============================================================
  -- ROW LEVEL SECURITY POLICIES (ENABLED FOR PRODUCTION)
  -- ============================================================

  -- Helper function to check if user is admin based on session token
  CREATE OR REPLACE FUNCTION is_admin_from_session()
  RETURNS boolean AS $$
  DECLARE
      user_role TEXT;
  BEGIN
      -- Get the current user's role from the session
      SELECT au.role INTO user_role
      FROM public.admin_users au
      JOIN public.user_sessions us ON au.id = us.user_id
      WHERE us.session_token = current_setting('app_settings.current_session_token', true)
      AND us.expires_at > NOW()
      AND au.is_active = true;
      
      RETURN user_role = 'admin';
  EXCEPTION
      WHEN OTHERS THEN
          RETURN false;
  END;
  $$ LANGUAGE plpgsql SECURITY DEFINER;

  -- VEHICLES TABLE POLICIES
  DROP POLICY IF EXISTS "Enable read access for all users" ON public.vehicles;
  DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.vehicles;
  DROP POLICY IF EXISTS "Enable update for authenticated users" ON public.vehicles;
  DROP POLICY IF EXISTS "Enable delete for authenticated users" ON public.vehicles;

  CREATE POLICY "Enable read access for all users" ON public.vehicles
    FOR SELECT
    USING (true);

  CREATE POLICY "Enable insert for admin users only" ON public.vehicles
    FOR INSERT
    WITH CHECK (is_admin_from_session());

  CREATE POLICY "Enable update for admin users only" ON public.vehicles
    FOR UPDATE
    USING (is_admin_from_session())
    WITH CHECK (is_admin_from_session());

  CREATE POLICY "Enable delete for admin users only" ON public.vehicles
    FOR DELETE
    USING (is_admin_from_session());

  -- DRIVERS_STATUS TABLE POLICIES
  DROP POLICY IF EXISTS "Enable read access for all users" ON public.drivers_status;
  DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.drivers_status;
  DROP POLICY IF EXISTS "Enable update for authenticated users" ON public.drivers_status;
  DROP POLICY IF EXISTS "Enable delete for authenticated users" ON public.drivers_status;

  CREATE POLICY "Enable read access for all users" ON public.drivers_status
    FOR SELECT
    USING (true);

  CREATE POLICY "Enable insert for admin users only" ON public.drivers_status
    FOR INSERT
    WITH CHECK (is_admin_from_session());

  CREATE POLICY "Enable update for admin users only" ON public.drivers_status
    FOR UPDATE
    USING (is_admin_from_session())
    WITH CHECK (is_admin_from_session());

  CREATE POLICY "Enable delete for admin users only" ON public.drivers_status
    FOR DELETE
    USING (is_admin_from_session());

  -- TRUCKS TABLE POLICIES
  DROP POLICY IF EXISTS "Enable read access for all users" ON public.trucks;
  DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.trucks;
  DROP POLICY IF EXISTS "Enable update for authenticated users" ON public.trucks;
  DROP POLICY IF EXISTS "Enable delete for authenticated users" ON public.trucks;

  CREATE POLICY "Enable read access for all users" ON public.trucks
    FOR SELECT
    USING (true);

  CREATE POLICY "Enable insert for admin users only" ON public.trucks
    FOR INSERT
    WITH CHECK (is_admin_from_session());

  CREATE POLICY "Enable update for admin users only" ON public.trucks
    FOR UPDATE
    USING (is_admin_from_session())
    WITH CHECK (is_admin_from_session());

  CREATE POLICY "Enable delete for admin users only" ON public.trucks
    FOR DELETE
    USING (is_admin_from_session());

  -- DRIVERS TABLE POLICIES
  DROP POLICY IF EXISTS "Enable read access for all users" ON public.drivers;
  DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.drivers;
  DROP POLICY IF EXISTS "Enable update for authenticated users" ON public.drivers;
  DROP POLICY IF EXISTS "Enable delete for authenticated users" ON public.drivers;

  CREATE POLICY "Enable read access for all users" ON public.drivers
    FOR SELECT
    USING (true);

  CREATE POLICY "Enable insert for admin users only" ON public.drivers
    FOR INSERT
    WITH CHECK (is_admin_from_session());

  CREATE POLICY "Enable update for admin users only" ON public.drivers
    FOR UPDATE
    USING (is_admin_from_session())
    WITH CHECK (is_admin_from_session());

  CREATE POLICY "Enable delete for admin users only" ON public.drivers
    FOR DELETE
    USING (is_admin_from_session());

  -- VEHICLE REPAIRS TABLE POLICIES
  DROP POLICY IF EXISTS "Enable read access for all users" ON public.vehicle_repairs;
  DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.vehicle_repairs;
  DROP POLICY IF EXISTS "Enable update for authenticated users" ON public.vehicle_repairs;
  DROP POLICY IF EXISTS "Enable delete for authenticated users" ON public.vehicle_repairs;

  CREATE POLICY "Enable read access for all users" ON public.vehicle_repairs
    FOR SELECT
    USING (true);

  CREATE POLICY "Enable insert for admin users only" ON public.vehicle_repairs
    FOR INSERT
    WITH CHECK (is_admin_from_session());

  CREATE POLICY "Enable update for admin users only" ON public.vehicle_repairs
    FOR UPDATE
    USING (is_admin_from_session())
    WITH CHECK (is_admin_from_session());

  CREATE POLICY "Enable delete for admin users only" ON public.vehicle_repairs
    FOR DELETE
    USING (is_admin_from_session());

  -- TRAILERS TABLE POLICIES
  DROP POLICY IF EXISTS "Enable read access for all users" ON public.trailers;
  DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.trailers;
  DROP POLICY IF EXISTS "Enable update for authenticated users" ON public.trailers;
  DROP POLICY IF EXISTS "Enable delete for authenticated users" ON public.trailers;

  CREATE POLICY "Enable read access for all users" ON public.trailers
    FOR SELECT
    USING (true);

  CREATE POLICY "Enable insert for admin users only" ON public.trailers
    FOR INSERT
    WITH CHECK (is_admin_from_session());

  CREATE POLICY "Enable update for admin users only" ON public.trailers
    FOR UPDATE
    USING (is_admin_from_session())
    WITH CHECK (is_admin_from_session());

  CREATE POLICY "Enable delete for admin users only" ON public.trailers
    FOR DELETE
    USING (is_admin_from_session());

  -- VEHICLE REGISTRY TABLE POLICIES
  DROP POLICY IF EXISTS "Enable read access for all users" ON public.vehicle_registry;
  DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.vehicle_registry;
  DROP POLICY IF EXISTS "Enable update for authenticated users" ON public.vehicle_registry;
  DROP POLICY IF EXISTS "Enable delete for authenticated users" ON public.vehicle_registry;

  CREATE POLICY "Enable read access for all users" ON public.vehicle_registry
    FOR SELECT
    USING (true);

  DROP POLICY IF EXISTS "Enable insert for admin users only" ON public.vehicle_registry;
  CREATE POLICY "Enable insert for admin users only" ON public.vehicle_registry
    FOR INSERT
    WITH CHECK (is_admin_from_session());

  DROP POLICY IF EXISTS "Enable update for admin users only" ON public.vehicle_registry;
  CREATE POLICY "Enable update for admin users only" ON public.vehicle_registry
    FOR UPDATE
    USING (is_admin_from_session())
    WITH CHECK (is_admin_from_session());

  DROP POLICY IF EXISTS "Enable delete for admin users only" ON public.vehicle_registry;
  CREATE POLICY "Enable delete for admin users only" ON public.vehicle_registry
    FOR DELETE
    USING (is_admin_from_session());

  -- VEHICLE STATUS TABLE POLICIES
  DROP POLICY IF EXISTS "Enable read access for all users" ON public.vehicle_status;
  DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.vehicle_status;
  DROP POLICY IF EXISTS "Enable update for authenticated users" ON public.vehicle_status;
  DROP POLICY IF EXISTS "Enable delete for authenticated users" ON public.vehicle_status;

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

  -- VEHICLE TOOLS TABLE POLICIES
  DROP POLICY IF EXISTS "Enable read access for all users" ON public.vehicle_tools;
  DROP POLICY IF EXISTS "Enable insert for admin users only" ON public.vehicle_tools;
  DROP POLICY IF EXISTS "Enable update for admin users only" ON public.vehicle_tools;
  DROP POLICY IF EXISTS "Enable delete for admin users only" ON public.vehicle_tools;

  CREATE POLICY "Enable read access for all users" ON public.vehicle_tools
    FOR SELECT
    USING (true);

  CREATE POLICY "Enable insert for admin users only" ON public.vehicle_tools
    FOR INSERT
    WITH CHECK (is_admin_from_session());

  CREATE POLICY "Enable update for admin users only" ON public.vehicle_tools
    FOR UPDATE
    USING (is_admin_from_session())
    WITH CHECK (is_admin_from_session());

  CREATE POLICY "Enable delete for admin users only" ON public.vehicle_tools
    FOR DELETE
    USING (is_admin_from_session());

  -- ============================================================
  -- 5. VEHICLE REGISTRY TABLE (Extended vehicle details)
  -- ============================================================
  DROP TABLE IF EXISTS public.vehicle_registry CASCADE;

  CREATE TABLE public.vehicle_registry (
    plate TEXT PRIMARY KEY,
    model TEXT NOT NULL,
    size TEXT NOT NULL,
    year_model INTEGER NOT NULL,
    plant TEXT NOT NULL DEFAULT 'DISNEY 3',
    
    -- Image URLs
    image1_url TEXT,
    image2_url TEXT,
    image3_url TEXT,
    image4_url TEXT,
    
    -- Engine & Vehicle Details
    engine_no TEXT,
    chassi_no TEXT,
    classification TEXT,
    vehicle_type TEXT,
    color TEXT,
    aircon_type TEXT,
    
    -- Registration Details
    cr_no TEXT,
    cr_registered DATE,
    mv_file TEXT,
    
    -- Technical Specifications
    denomination TEXT,
    piston_displacement TEXT,
    no_of_cylinder INTEGER,
    fuel TEXT,
    series TEXT,
    
    -- Body & Dimensions
    body_type TEXT,
    body_no TEXT,
    gross_wt DECIMAL(10,2),
    net_wt DECIMAL(10,2),
    shipping_wt DECIMAL(10,2),
    net_capacity TEXT,
    length DECIMAL(10,2),
    width DECIMAL(10,2),
    height DECIMAL(10,2),
    volume DECIMAL(10,2),
    gross_weight DECIMAL(10,2),
    net_weight DECIMAL(10,2),
    
    -- Owner Information
    owner_name TEXT,
    address TEXT,
    company TEXT,
    
    -- Additional Details
    no_of_years INTEGER,
    pallets_cap INTEGER,
    tire_size_front TEXT,
    tire_size_rear TEXT,
    total_tire_front INTEGER,
    total_tire_rear INTEGER,
    autosweep TEXT,
    easytrip TEXT,
    gps_type TEXT,
    remarks TEXT,
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
  );

  ALTER TABLE public.vehicle_registry DISABLE ROW LEVEL SECURITY;

  -- Create indexes for better performance
  CREATE INDEX idx_vehicle_registry_plate ON public.vehicle_registry(plate);
  CREATE INDEX idx_vehicle_registry_plant ON public.vehicle_registry(plant);

  -- ============================================================
  -- 6. VEHICLE STATUS TABLE
  -- ============================================================
  DROP TABLE IF EXISTS public.vehicle_status CASCADE;

  CREATE TABLE public.vehicle_status (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    plate TEXT UNIQUE NOT NULL REFERENCES public.vehicle_registry (plate) ON DELETE CASCADE,
    registered_date DATE NOT NULL,
    expiration_date DATE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT valid_dates CHECK (expiration_date > registered_date)
  );

  ALTER TABLE public.vehicle_status DISABLE ROW LEVEL SECURITY;

  -- Create index for faster lookups
  CREATE INDEX idx_vehicle_status_plate ON public.vehicle_status(plate);
  CREATE INDEX idx_vehicle_status_expiration ON public.vehicle_status(expiration_date);

  -- ============================================================
  -- 8. ADMIN USERS TABLE (for authentication)
  -- ============================================================
  DROP TABLE IF EXISTS public.admin_users CASCADE;

  CREATE TABLE public.admin_users (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    email TEXT UNIQUE,
    role TEXT NOT NULL DEFAULT 'admin' CHECK (role IN ('admin', 'guest')),
    is_active BOOLEAN DEFAULT true,
    last_login TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
  );

  -- Create indexes for better performance
  CREATE INDEX idx_admin_users_username ON public.admin_users(username);
  CREATE INDEX idx_admin_users_email ON public.admin_users(email);
  CREATE INDEX idx_admin_users_role ON public.admin_users(role);

  ALTER TABLE public.admin_users DISABLE ROW LEVEL SECURITY;

  -- ADMIN USERS TABLE POLICIES
  -- Only authenticated users can read admin users (for role checking)
  CREATE POLICY "Enable read for authenticated users" ON public.admin_users
    FOR SELECT
    USING (auth.role() = 'authenticated');

  -- Only authenticated users can insert admin users (for initial setup)
  CREATE POLICY "Enable insert for authenticated users" ON public.admin_users
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

  -- Only authenticated users can update admin users
  CREATE POLICY "Enable update for authenticated users" ON public.admin_users
    FOR UPDATE
    USING (auth.role() = 'authenticated')
    WITH CHECK (auth.role() = 'authenticated');

  -- Only authenticated users can delete admin users
  CREATE POLICY "Enable delete for authenticated users" ON public.admin_users
    FOR DELETE
    USING (auth.role() = 'authenticated');

  -- Create a function to automatically update the updated_at timestamp
  CREATE OR REPLACE FUNCTION update_admin_users_updated_at()
  RETURNS TRIGGER AS $$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $$ language 'plpgsql';

  -- Create trigger to automatically update updated_at
  CREATE TRIGGER update_admin_users_updated_at 
      BEFORE UPDATE ON public.admin_users
      FOR EACH ROW 
      EXECUTE FUNCTION update_admin_users_updated_at();

  -- Insert default admin user (password: admin123)
  -- Hashed password for 'admin123' using bcrypt (you should change this in production)
  INSERT INTO public.admin_users (username, password_hash, email, role) VALUES
  ('admin', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj6QJw/2Ej7W', 'admin@starkson.com', 'admin')
  ON CONFLICT (username) DO NOTHING;

  -- ============================================================
  -- 9. USER SESSIONS TABLE (for session management)
  -- ============================================================
  DROP TABLE IF EXISTS public.user_sessions CASCADE;

  CREATE TABLE public.user_sessions (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES public.admin_users(id) ON DELETE CASCADE,
    session_token TEXT UNIQUE NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    last_accessed TIMESTAMPTZ DEFAULT NOW(),
    ip_address TEXT,
    user_agent TEXT
  );

  -- Create indexes for better performance
  CREATE INDEX idx_user_sessions_token ON public.user_sessions(session_token);
  CREATE INDEX idx_user_sessions_user_id ON public.user_sessions(user_id);
  CREATE INDEX idx_user_sessions_expires_at ON public.user_sessions(expires_at);

  ALTER TABLE public.user_sessions DISABLE ROW LEVEL SECURITY;

  -- USER SESSIONS TABLE POLICIES
  -- Only authenticated users can manage sessions
  CREATE POLICY "Enable all operations for authenticated users" ON public.user_sessions
    FOR ALL
    USING (auth.role() = 'authenticated')
    WITH CHECK (auth.role() = 'authenticated');

  -- Function to set session token for RLS policies
  CREATE OR REPLACE FUNCTION set_app_setting(setting_name TEXT, setting_value TEXT)
  RETURNS void AS $$
  BEGIN
      PERFORM set_config('app_settings.' || setting_name, setting_value, true);
  END;
  $$ LANGUAGE plpgsql SECURITY DEFINER;

  -- Function to clean up expired sessions
  CREATE OR REPLACE FUNCTION cleanup_expired_sessions()
  RETURNS void AS $$
  BEGIN
      DELETE FROM public.user_sessions WHERE expires_at < NOW();
  END;
  $$ LANGUAGE plpgsql;

  -- Create a function to automatically update last_accessed
  CREATE OR REPLACE FUNCTION update_user_sessions_last_accessed()
  RETURNS TRIGGER AS $$
  BEGIN
      NEW.last_accessed = NOW();
      RETURN NEW;
  END;
  $$ language 'plpgsql';

  -- Create trigger to automatically update last_accessed on session access
  CREATE TRIGGER update_user_sessions_last_accessed 
      BEFORE UPDATE ON public.user_sessions
      FOR EACH ROW 
      EXECUTE FUNCTION update_user_sessions_last_accessed();

  -- ============================================================
  -- SAMPLE DATA
  -- ============================================================

  -- Insert sample data into vehicles table (3 examples per plant)
  INSERT INTO public.vehicles (plate, model, size, year_model, plant) VALUES
  -- DISNEY 6 Examples
  ('AAY 3082', 'MAN', 'TractorHead', 2015, 'DISNEY 6'),
  ('NBK 4295', 'MAN', 'TractorHead', 2017, 'DISNEY 6'),
  ('NCS 4106', 'MERCEDEZ', 'TractorHead', 2018, 'DISNEY 6'),
  -- DISNEY 3 Examples
  ('AAN 2734', 'MAN', 'TractorHead', 2014, 'DISNEY 3'),
  ('NDU 9697', 'MAN', 'TractorHead', 2016, 'DISNEY 3'),
  ('NCA 2679', 'SCANNIA', 'TractorHead', 2018, 'DISNEY 3');

  -- Insert sample data into vehicle_registry table (extended details for same plates)
  INSERT INTO public.vehicle_registry (plate, model, size, year_model, plant) VALUES
  ('AAY 3082', 'MAN', 'TractorHead', 2015, 'DISNEY 6'),
  ('NBK 4295', 'MAN', 'TractorHead', 2017, 'DISNEY 6'),
  ('NCS 4106', 'MERCEDEZ', 'TractorHead', 2018, 'DISNEY 6'),
  ('AAN 2734', 'MAN', 'TractorHead', 2014, 'DISNEY 3'),
  ('NDU 9697', 'MAN', 'TractorHead', 2016, 'DISNEY 3'),
  ('NCA 2679', 'SCANNIA', 'TractorHead', 2018, 'DISNEY 3');

  -- Insert sample data into drivers_status table
  INSERT INTO public.drivers_status (plate, driver, status) VALUES
  ('AAY 3082', 'Juan Dela Cruz', 'OPERATIONAL'),
  ('NBK 4295', 'Carlos Santos', 'OPERATIONAL'),
  ('NCS 4106', 'Jose Reyes', 'DOWN'),
  ('AAN 2734', 'Antonio Lopez', 'OPERATIONAL/HUSTLING'),
  ('NDU 9697', 'Miguel Torres', 'OPERATIONAL'),
  ('NCA 2679', 'Roberto Garcia', 'DOWN');

  -- Insert sample data into trailers table
  INSERT INTO public.trailers (plate_no, chassis_no, container, status) VALUES
  ('TRL-001', 'CHS-001', 'CONT-001', 'OPERATIONAL'),
  ('TRL-002', 'CHS-002', 'CONT-002', 'OPERATIONAL/HUSTLING'),
  ('TRL-003', 'CHS-003', 'CONT-003', 'DOWN'),
  ('TRL-004', 'CHS-004', 'CONT-004', 'OPERATIONAL'),
  ('TRL-005', 'CHS-005', 'CONT-005', 'OPERATIONAL/HUSTLING');

  -- Insert vehicle status sample data (3 examples)
  INSERT INTO public.vehicle_status (plate, registered_date, expiration_date) VALUES
  ('AAY 3082', '2024-01-15', '2025-01-15'),
  ('NBK 4295', '2023-12-10', '2024-12-10'),
  ('AAN 2734', '2024-08-10', '2025-08-10');

  -- ============================================================
  -- 7. GPS TRACKING TABLE
  -- ============================================================
  DROP TABLE IF EXISTS public.gps_tracking CASCADE;

  CREATE TABLE public.gps_tracking (
      id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
      created_at TIMESTAMPTZ DEFAULT NOW(),
      updated_at TIMESTAMPTZ DEFAULT NOW(),
      date DATE NOT NULL,
      plate_no TEXT,
      description TEXT,
      remarks TEXT,
      imsi_no TEXT,
      plant TEXT,
      
      -- Additional fields for future GPS functionality
      latitude DECIMAL(10, 8),
      longitude DECIMAL(11, 8),
      status TEXT DEFAULT 'active',
      last_updated TIMESTAMPTZ DEFAULT NOW(),
      
      -- Constraints
      CONSTRAINT gps_tracking_date_check CHECK (date IS NOT NULL)
  );

  -- Create indexes for better performance
  CREATE INDEX idx_gps_tracking_date ON public.gps_tracking(date DESC);
  CREATE INDEX idx_gps_tracking_plate ON public.gps_tracking(plate_no);
  CREATE INDEX idx_gps_tracking_plant ON public.gps_tracking(plant);
  CREATE INDEX idx_gps_tracking_status ON public.gps_tracking(status);

  ALTER TABLE public.gps_tracking DISABLE ROW LEVEL SECURITY;

  -- GPS TRACKING TABLE POLICIES
  DROP POLICY IF EXISTS "Enable read access for all users" ON public.gps_tracking;
  DROP POLICY IF EXISTS "Enable insert for authenticated users" ON public.gps_tracking;
  DROP POLICY IF EXISTS "Enable update for authenticated users" ON public.gps_tracking;
  DROP POLICY IF EXISTS "Enable delete for authenticated users" ON public.gps_tracking;

  CREATE POLICY "Enable read access for all users" ON public.gps_tracking
    FOR SELECT
    USING (true);

  CREATE POLICY "Enable insert for admin users only" ON public.gps_tracking
    FOR INSERT
    WITH CHECK (is_admin_from_session());

  CREATE POLICY "Enable update for admin users only" ON public.gps_tracking
    FOR UPDATE
    USING (is_admin_from_session())
    WITH CHECK (is_admin_from_session());

  CREATE POLICY "Enable delete for admin users only" ON public.gps_tracking
    FOR DELETE
    USING (is_admin_from_session());

  -- Create a function to automatically update the updated_at timestamp
  CREATE OR REPLACE FUNCTION update_gps_tracking_updated_at()
  RETURNS TRIGGER AS $$
  BEGIN
      NEW.updated_at = NOW();
      RETURN NEW;
  END;
  $$ language 'plpgsql';

  -- Create trigger to automatically update updated_at
  CREATE TRIGGER update_gps_tracking_updated_at 
      BEFORE UPDATE ON public.gps_tracking
      FOR EACH ROW 
      EXECUTE FUNCTION update_gps_tracking_updated_at();

  -- Add comments for documentation
  COMMENT ON TABLE public.gps_tracking IS 'GPS tracking information for vehicles including location, status, and maintenance records';
  COMMENT ON COLUMN public.gps_tracking.date IS 'Date of GPS record or tracking event';
  COMMENT ON COLUMN public.gps_tracking.plate_no IS 'Vehicle plate number associated with GPS record';
  COMMENT ON COLUMN public.gps_tracking.description IS 'Description of GPS event or location';
  COMMENT ON COLUMN public.gps_tracking.remarks IS 'Additional remarks or notes about GPS record';
  COMMENT ON COLUMN public.gps_tracking.imsi_no IS 'IMSI number of GPS device';
  COMMENT ON COLUMN public.gps_tracking.plant IS 'Plant location where vehicle is assigned';
  COMMENT ON COLUMN public.gps_tracking.latitude IS 'Latitude coordinate of GPS location';
  COMMENT ON COLUMN public.gps_tracking.longitude IS 'Longitude coordinate of GPS location';
  COMMENT ON COLUMN public.gps_tracking.status IS 'Current status of GPS tracking (active, inactive, maintenance)';

  -- Insert sample GPS tracking data (3 examples)
  INSERT INTO public.gps_tracking (date, plate_no, description, remarks, imsi_no, plant, status) VALUES
  ('2026-04-01', 'AAY 3082', 'GPS device installed', 'Device working properly', '123456789012345', 'DISNEY 6', 'active'),
  ('2026-03-28', 'NBK 4295', 'Location update', 'Vehicle at Cavite plant', '987654321098765', 'DISNEY 6', 'active'),

  ('2025-03-02', 'DCP 6567', 'Reset GPS unit (engine warning light on)', '', '', 'DISNEY 6', 'active'),
  ('2025-03-02', 'NBK 4296', 'Reset GPS unit', '', '', 'DISNEY 6', 'active'),
  ('2025-03-02', 'AAY 3083', 'Reset GPS unit', '', '', 'DISNEY 6', 'active'),
  ('2025-03-02', 'NCS 4409', 'Reset GPS unit', '', '', 'DISNEY 6', 'active'),
  ('2025-03-02', 'DAA 2285', 'Initialized GPS unit and fixed dashcam (detached)', '', '', 'DISNEY 6', 'active'),
  ('2025-03-02', 'MGE 632', 'Reset GPS unit', '', '', 'DISNEY 6', 'active'),
  ('2025-03-02', 'NDJ 9667', 'Reset GPS unit', '', '', 'DISNEY 6', 'active'),
  ('2025-03-02', 'AAN 2734', 'Checked voltage supply and wiring, found safety switch issue', '', '', 'DISNEY 6', 'active'),
  ('2025-03-02', 'NEI 3272', 'Reset GPS unit', '', '', 'DISNEY 6', 'active'),
  ('2025-03-02', 'NCA 2681', 'Reset GPS unit', '', '', 'DISNEY 6', 'active'),
  ('2025-03-02', 'NBK 4295', 'Reset GPS unit (engine warning light on)', '', '', 'DISNEY 6', 'active'),
  ('2025-03-02', 'DCP 8065', 'Initialized GPS unit', '', '', 'DISNEY 6', 'active'),
  ('2025-03-01', 'RJH 524', 'RESETTED GPS UNIT', '', '', 'DISNEY 6', 'active'),
  ('2025-03-01', 'MGE 763', 'INITIALIZED GPS UNIT', '', '', 'DISNEY 6', 'active'),
  ('2025-03-01', 'RNE 467', 'RESETTED GPS UNIT', '', '', 'DISNEY 6', 'active'),
  ('2025-03-01', 'RAK 314', 'RESETTED GPS UNIT / REMOVED DEFECTIVE VOLTAGE', '', '', 'DISNEY 6', 'active'),
  ('2025-03-01', 'RMB 650', 'INITIALIZED GPS UNIT', '', '', 'DISNEY 6', 'active'),
  ('2025-03-01', 'RME 429', 'INITIALIZED GPS UNIT', '', '', 'DISNEY 6', 'active'),
  ('2025-03-01', 'RJM 365', 'INITIALIZED GPS UNIT / REMOVED DEFECTIVE VOLTAGE', '', '', 'DISNEY 6', 'active'),
  ('2025-03-01', 'NAV 2526', 'RESETTED GPS UNIT', '', '', 'DISNEY 6', 'active'),
  ('2023-07-29', 'DAA 2285', 'NOT DONE, NO KEY', '', '', 'DISNEY 6', 'inactive'),
  ('2023-07-29', 'DCP 1934', 'NOT DONE, NO KEY', '', '', 'DISNEY 6', 'inactive'),
  ('2023-07-29', 'DCQ 8065', 'NOT DONE, NO KEY', '', '', 'DISNEY 6', 'inactive'),
  ('2023-07-29', 'NCA 2681', 'NOT DONE, NO KEY', '', '', 'DISNEY 6', 'inactive'),
  ('2023-07-29', 'AAY 3083', 'MANUALLY RESETTED GPS UNIT', '', '', 'DISNEY 6', 'active'),
  ('2023-07-29', 'DCP 6567', 'MANUALLY RESETTED GPS UNIT', '', '', 'DISNEY 6', 'active'),
  ('2023-07-29', 'NBK 4295', 'MANUALLY RESETTED GPS UNIT', '', '', 'DISNEY 6', 'active'),
  ('2023-07-29', 'DCQ 2882', 'MANUALLY RESETTED GPS UNIT', '', '', 'DISNEY 6', 'active'),
  ('2023-07-29', 'KGE 632', 'MANUALLY RESETTED GPS UNIT', '', '', 'DISNEY 6', 'active'),
  ('2023-07-29', 'NBK 4296', 'MANUALLY RESETTED GPS UNIT', '', '', 'DISNEY 6', 'active'),
  ('2023-07-29', 'NCS 4107', 'MANUALLY RESETTED GPS UNIT', '', '', 'DISNEY 6', 'active'),
  ('2023-07-29', 'AAN2734', 'MANUALLY RESETTED GPS UNIT', '', '', 'DISNEY 6', 'active'),
  ('2023-07-29', 'NEI 3272', 'MANUALLY RESETTED GPS UNIT', '', '', 'DISNEY 6', 'active'),
  ('2023-07-29', 'NCS 4109', 'MANUALLY RESETTED GPS UNIT', '', '', 'DISNEY 6', 'active'),
  ('2023-07-29', 'AAO 1117', 'MANUALLY RESETTED GPS UNIT', '', '', 'DISNEY 6', 'active'),
  ('2023-07-29', 'NEI3273', 'MANUALLY RESETTED GPS UNIT', '', '', 'DISNEY 6', 'active'),
  ('2023-07-29', 'NCS 4106', 'N/A', '', '', 'DISNEY 6', 'maintenance'),
  ('2023-07-29', 'NCS 4108', 'N/A CASA', '', '', 'DISNEY 6', 'maintenance'),
  ('2023-07-29', 'AAY 3082', 'INSTALLED GPS UNIT', '', '', 'DISNEY 6', 'active'),
  ('2023-07-29', 'NCS 2629', 'UNDER MAINTENANCE', '', '', 'DISNEY 6', 'maintenance'),
  ('2023-07-29', 'NEI 3273', 'UNDER MAINTENANCE', '', '', 'DISNEY 6', 'maintenance'),
  ('2023-07-29', 'NOU 9697', 'UNDER MAINTENANCE', '', '', 'DISNEY 6', 'maintenance'),
  ('2024-01-14', 'AAY 3082', 'SAFETY SWTCH OFF', '', '', 'DISNEY 6', 'maintenance'),
  ('2024-01-14', 'NDU 9697', 'SAFETY SWITCH OFF', '', '', 'DISNEY 6', 'maintenance'),
  ('2024-01-14', 'NEI 3272', 'NO POWER', '', '', 'DISNEY 6', 'maintenance'),
  ('2024-01-14', 'NEI 3274', 'NO POWER', '', '', 'DISNEY 6', 'maintenance'),
  ('2024-01-14', 'NCS 4107', 'SRS REAR AXLE LAMP MALFUNCTION', '', '', 'DISNEY 6', 'maintenance'),
  ('2024-01-14', 'NEI3274', 'BATTERY OFF', '', '', 'DISNEY 6', 'maintenance'),
  ('2024-01-14', 'DCP 6567', 'ENGINE WARNING LIGHT ON', '', '', 'DISNEY 6', 'maintenance'),
  ('2024-01-14', 'NCA 2679', 'NO KEY', '', '', 'DISNEY 6', 'maintenance'),
  ('2024-01-14', 'NDU 9697', 'ENGINE COOLING FAULT WARNING ON SAFETY SWITCH ON OFF MODE', '', '', 'DISNEY 6', 'maintenance'),
  ('2024-01-14', 'AAO 1117', 'MALFUNCTION ON BOARD COMPUTER WARNING ON', '', '', 'DISNEY 6', 'maintenance'),
  ('2024-01-14', 'AAY 3082', 'ENGINE COOLING OFF WARNING ON SAFETY SWITCH FOUND OFF', '', '', 'DISNEY 6', 'maintenance'),
  ('2024-01-14', 'NEI 3272', 'NO POWER', '', '', 'DISNEY 6', 'maintenance'),
  ('2024-01-14', 'RNE 587', 'RADIATOR WARNING LIGHT ON', '', '', 'DISNEY 6', 'maintenance'),
  ('2024-01-14', 'DCQ 8065', 'NO KEY', '', '', 'DISNEY 6', 'maintenance'),
  ('2023-10-23', 'NEI 3274', 'NO REGULATOR GPS INSTALLED TO TRUCK', '', '', 'DISNEY 6', 'maintenance'),
  ('2023-10-23', 'DCP 6567', 'FIX DASHCAM POSITION / NO BRACKET', '', '', 'DISNEY 6', 'maintenance'),
  ('2023-10-23', 'MGE 632', 'WORKING GPS / CHECK FUSE / WIRING SYSTEM', '', '', 'DISNEY 6', 'maintenance'),
  ('2023-10-23', 'NCS 4106', 'CHECK WIRING SYSTEM / PULL OUT REGULATOR', '', '', 'DISNEY 6', 'maintenance'),
  ('2023-10-23', 'NEI 3274', 'ENGINE WARNING / BUSTER REGULATOR', '', '', 'DISNEY 6', 'maintenance'),
  ('2023-03-16', 'RME 429', 'BUSTED REGULATOR / OVER CHARGE', '', '357730090567190', 'DISNEY 6', 'maintenance'),
  ('2023-03-16', 'RMB 650', 'BUSTED REGULATOR / OVER CHARGE', '', '357730090567497', 'DISNEY 6', 'maintenance'),
  ('2023-03-16', 'RME 912', 'BUSTED REGULATOR / OVER CHARGE', '', '357730090565236', 'DISNEY 6', 'maintenance'),
  ('2023-03-16', 'DCP 6567', 'BUSTED REGULATOR / OVER CHARGE', '', '357730090522294', 'DISNEY 6', 'maintenance'),
  ('2023-03-16', 'NCS 4108', 'BUSTED REGULATOR / OVER CHARGE', '', '357730090565632', 'DISNEY 6', 'maintenance'),
  ('2023-03-16', 'NBK 4296', 'BUSTED REGULATOR / OVER CHARGE', '', '357730090565707', 'DISNEY 6', 'maintenance'),
  ('2023-03-16', 'NCS 4109', 'BUSTED REGULATOR / OVER CHARGE', '', '357730090567653', 'DISNEY 6', 'maintenance'),
  ('2023-03-16', 'DCQ 8065', 'BUSTED REGULATOR / OVER CHARGE', '', '357730090565046', 'DISNEY 6', 'maintenance'),
  ('2023-03-16', 'NEI 3272', 'BUSTED REGULATOR / OVER CHARGE', '', '357730090567612', 'DISNEY 6', 'maintenance'),


  ('2026-04-01', 'AAN 2734', 'Maintenance check', 'GPS device maintenance scheduled', '456789012345678', 'DISNEY 3', 'maintenance');

  -- ============================================================
  -- 9. VEHICLE TOOLS TABLE
  -- ============================================================
  DROP TABLE IF EXISTS public.vehicle_tools CASCADE;

  CREATE TABLE public.vehicle_tools (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    plate_no TEXT UNIQUE NOT NULL REFERENCES public.vehicle_registry (plate) ON DELETE CASCADE,
    mechanical_key BOOLEAN DEFAULT FALSE,
    battery_case_key BOOLEAN DEFAULT FALSE,
    adblue_key BOOLEAN DEFAULT FALSE,
    wheel_chock BOOLEAN DEFAULT FALSE,
    first_aid_kit BOOLEAN DEFAULT FALSE,
    hazard_warning_triangle BOOLEAN DEFAULT FALSE,
    warning_lamp BOOLEAN DEFAULT FALSE,
    spare_bulb BOOLEAN DEFAULT FALSE,
    manual BOOLEAN DEFAULT FALSE,
    tire_inflating_hose BOOLEAN DEFAULT FALSE,
    tilt_bar BOOLEAN DEFAULT FALSE,
    tire_jack BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
  );

  ALTER TABLE public.vehicle_tools DISABLE ROW LEVEL SECURITY;

  -- Create index for faster lookups
  CREATE INDEX idx_vehicle_tools_plate_no ON public.vehicle_tools(plate_no);

  -- Insert sample data for vehicle tools
  INSERT INTO public.vehicle_tools (plate_no, mechanical_key, battery_case_key, adblue_key, wheel_chock, first_aid_kit, hazard_warning_triangle, warning_lamp, spare_bulb, manual, tire_inflating_hose, tilt_bar, tire_jack) VALUES
  ('AAY 3082', TRUE, TRUE, FALSE, TRUE, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE, FALSE, TRUE),
  ('NBK 4295', FALSE, TRUE, TRUE, FALSE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE, FALSE),
  ('AAN 2734', TRUE, FALSE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE);

  -- ============================================================
  -- 10. ADD IMAGE COLUMNS TO EXISTING TABLES (for existing databases)
  -- ============================================================

  -- Add image columns to trailers table if they don't exist
  DO $$
  BEGIN
    -- Add image1_url column if it doesn't exist
    IF NOT EXISTS (
      SELECT 1 FROM information_schema.columns 
      WHERE table_name = 'trailers' AND column_name = 'image1_url'
    ) THEN
      ALTER TABLE public.trailers ADD COLUMN image1_url TEXT;
    END IF;

    -- Add image2_url column if it doesn't exist
    IF NOT EXISTS (
      SELECT 1 FROM information_schema.columns 
      WHERE table_name = 'trailers' AND column_name = 'image2_url'
    ) THEN
      ALTER TABLE public.trailers ADD COLUMN image2_url TEXT;
    END IF;

    -- Add image3_url column if it doesn't exist
    IF NOT EXISTS (
      SELECT 1 FROM information_schema.columns 
      WHERE table_name = 'trailers' AND column_name = 'image3_url'
    ) THEN
      ALTER TABLE public.trailers ADD COLUMN image3_url TEXT;
    END IF;

    -- Add image4_url column if it doesn't exist
    IF NOT EXISTS (
      SELECT 1 FROM information_schema.columns 
      WHERE table_name = 'trailers' AND column_name = 'image4_url'
    ) THEN
      ALTER TABLE public.trailers ADD COLUMN image4_url TEXT;
    END IF;
  END $$;

  -- Add image columns to containers table if they don't exist
  DO $$
  BEGIN
    -- Add image1_url column if it doesn't exist
    IF NOT EXISTS (
      SELECT 1 FROM information_schema.columns 
      WHERE table_name = 'containers' AND column_name = 'image1_url'
    ) THEN
      ALTER TABLE public.containers ADD COLUMN image1_url TEXT;
    END IF;

    -- Add image2_url column if it doesn't exist
    IF NOT EXISTS (
      SELECT 1 FROM information_schema.columns 
      WHERE table_name = 'containers' AND column_name = 'image2_url'
    ) THEN
      ALTER TABLE public.containers ADD COLUMN image2_url TEXT;
    END IF;

    -- Add image3_url column if it doesn't exist
    IF NOT EXISTS (
      SELECT 1 FROM information_schema.columns 
      WHERE table_name = 'containers' AND column_name = 'image3_url'
    ) THEN
      ALTER TABLE public.containers ADD COLUMN image3_url TEXT;
    END IF;

    -- Add image4_url column if it doesn't exist
    IF NOT EXISTS (
      SELECT 1 FROM information_schema.columns 
      WHERE table_name = 'containers' AND column_name = 'image4_url'
    ) THEN
      ALTER TABLE public.containers ADD COLUMN image4_url TEXT;
    END IF;
  END $$;

-- ============================================================
-- CLIENTS TABLE
-- ============================================================
DROP TABLE IF EXISTS public.clients CASCADE;

CREATE TABLE public.clients (
  id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  plant TEXT NOT NULL DEFAULT 'DISNEY 3',
  destination TEXT NOT NULL,
  address TEXT NOT NULL,
  going_to TEXT,
  going_back TEXT,
  total_km TEXT,
  average_time TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.clients DISABLE ROW LEVEL SECURITY;

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_clients_plant ON public.clients(plant);
CREATE INDEX IF NOT EXISTS idx_clients_destination ON public.clients(destination);
CREATE INDEX IF NOT EXISTS idx_clients_created_at ON public.clients(created_at);

-- Enable Row Level Security (RLS) for clients table
ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;

-- Create policy for all users to read clients (more permissive for testing)
CREATE POLICY "Enable read access for all users" ON public.clients
  FOR SELECT USING (true);

-- Create policy for all users to insert clients
CREATE POLICY "Enable insert for all users" ON public.clients
  FOR INSERT WITH CHECK (true);

-- Create policy for all users to update clients
CREATE POLICY "Enable update for all users" ON public.clients
  FOR UPDATE USING (true);

-- Create policy for all users to delete clients
CREATE POLICY "Enable delete for all users" ON public.clients
  FOR DELETE USING (true);

-- Insert sample client data (optional - for testing)
INSERT INTO public.clients (destination, address, going_to, going_back, total_km, average_time) VALUES
('Manila', 'Makati City, Philippines', '25', '25', '50', '2 hours'),
('Cavite', 'Dasmariñas, Cavite', '15', '15', '30', '1.5 hours'),
('Cebu', 'Cebu City, Philippines', '40', '40', '80', '3 hours')
ON CONFLICT DO NOTHING;
