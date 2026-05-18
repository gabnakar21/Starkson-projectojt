-- ============================================================
-- DIESEL RECORDS TABLES
-- ============================================================

-- ============================================================
-- 1. DIESEL RECORDS AVERAGE TABLE
-- ============================================================
DROP TABLE IF EXISTS public.diesel_records_ave CASCADE;

CREATE TABLE public.diesel_records_ave (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    date DATE NOT NULL,
    destination TEXT NOT NULL,
    four_w_six_w DECIMAL(10,2),  -- 4W/6W field
    eight_w DECIMAL(10,2),       -- 8W field
    ten_w DECIMAL(10,2),         -- 10W field
    twelve_w DECIMAL(10,2),      -- 12W field (renamed from 18W)
    tractor_head TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Constraints
    CONSTRAINT diesel_ave_date_check CHECK (date IS NOT NULL),
    CONSTRAINT diesel_ave_destination_check CHECK (destination IS NOT NULL AND length(destination) > 0)
);

-- ============================================================
-- 2. DIESEL RECORDS MINIMUM TABLE
-- ============================================================
DROP TABLE IF EXISTS public.diesel_records_min CASCADE;

CREATE TABLE public.diesel_records_min (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    date DATE NOT NULL,
    destination TEXT NOT NULL,
    four_w_six_w DECIMAL(10,2),  -- 4W/6W field
    eight_w DECIMAL(10,2),       -- 8W field
    ten_w DECIMAL(10,2),         -- 10W field
    twelve_w DECIMAL(10,2),      -- 12W field (renamed from 18W)
    tractor_head TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Constraints
    CONSTRAINT diesel_min_date_check CHECK (date IS NOT NULL),
    CONSTRAINT diesel_min_destination_check CHECK (destination IS NOT NULL AND length(destination) > 0)
);

-- ============================================================
-- INDEXES FOR BETTER PERFORMANCE
-- ============================================================

-- Indexes for diesel_records_ave
CREATE INDEX idx_diesel_ave_date ON public.diesel_records_ave(date DESC);
CREATE INDEX idx_diesel_ave_destination ON public.diesel_records_ave(destination);
CREATE INDEX idx_diesel_ave_tractor_head ON public.diesel_records_ave(tractor_head);
CREATE INDEX idx_diesel_ave_eight_w ON public.diesel_records_ave(eight_w);
CREATE INDEX idx_diesel_ave_twelve_w ON public.diesel_records_ave(twelve_w);

-- Indexes for diesel_records_min
CREATE INDEX idx_diesel_min_date ON public.diesel_records_min(date DESC);
CREATE INDEX idx_diesel_min_destination ON public.diesel_records_min(destination);
CREATE INDEX idx_diesel_min_tractor_head ON public.diesel_records_min(tractor_head);
CREATE INDEX idx_diesel_min_eight_w ON public.diesel_records_min(eight_w);
CREATE INDEX idx_diesel_min_twelve_w ON public.diesel_records_min(twelve_w);

-- ============================================================
-- ROW LEVEL SECURITY POLICIES
-- ============================================================

-- Disable RLS initially
ALTER TABLE public.diesel_records_ave DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.diesel_records_min DISABLE ROW LEVEL SECURITY;

-- DIESEL RECORDS AVERAGE TABLE POLICIES
DROP POLICY IF EXISTS "Enable read access for all users" ON public.diesel_records_ave;
DROP POLICY IF EXISTS "Enable insert for admin users only" ON public.diesel_records_ave;
DROP POLICY IF EXISTS "Enable update for admin users only" ON public.diesel_records_ave;
DROP POLICY IF EXISTS "Enable delete for admin users only" ON public.diesel_records_ave;

CREATE POLICY "Enable read access for all users" ON public.diesel_records_ave
    FOR SELECT
    USING (true);

CREATE POLICY "Enable insert for admin users only" ON public.diesel_records_ave
    FOR INSERT
    WITH CHECK (is_admin_from_session());

CREATE POLICY "Enable update for admin users only" ON public.diesel_records_ave
    FOR UPDATE
    USING (is_admin_from_session())
    WITH CHECK (is_admin_from_session());

CREATE POLICY "Enable delete for admin users only" ON public.diesel_records_ave
    FOR DELETE
    USING (is_admin_from_session());

-- DIESEL RECORDS MINIMUM TABLE POLICIES
DROP POLICY IF EXISTS "Enable read access for all users" ON public.diesel_records_min;
DROP POLICY IF EXISTS "Enable insert for admin users only" ON public.diesel_records_min;
DROP POLICY IF EXISTS "Enable update for admin users only" ON public.diesel_records_min;
DROP POLICY IF EXISTS "Enable delete for admin users only" ON public.diesel_records_min;

CREATE POLICY "Enable read access for all users" ON public.diesel_records_min
    FOR SELECT
    USING (true);

CREATE POLICY "Enable insert for admin users only" ON public.diesel_records_min
    FOR INSERT
    WITH CHECK (is_admin_from_session());

CREATE POLICY "Enable update for admin users only" ON public.diesel_records_min
    FOR UPDATE
    USING (is_admin_from_session())
    WITH CHECK (is_admin_from_session());

CREATE POLICY "Enable delete for admin users only" ON public.diesel_records_min
    FOR DELETE
    USING (is_admin_from_session());

-- ============================================================
-- TRIGGERS FOR AUTOMATIC TIMESTAMP UPDATES
-- ============================================================

-- Function to update updated_at for diesel_records_ave
CREATE OR REPLACE FUNCTION update_diesel_records_ave_updated_at()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for diesel_records_ave
CREATE TRIGGER update_diesel_records_ave_updated_at 
    BEFORE UPDATE ON public.diesel_records_ave
    FOR EACH ROW 
    EXECUTE FUNCTION update_diesel_records_ave_updated_at();

-- Function to update updated_at for diesel_records_min
CREATE OR REPLACE FUNCTION update_diesel_records_min_updated_at()
    RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for diesel_records_min
CREATE TRIGGER update_diesel_records_min_updated_at 
    BEFORE UPDATE ON public.diesel_records_min
    FOR EACH ROW 
    EXECUTE FUNCTION update_diesel_records_min_updated_at();

-- ============================================================
-- SAMPLE DATA
-- ============================================================

-- Insert sample data into diesel_records_ave
INSERT INTO public.diesel_records_ave (date, destination, four_w_six_w, eight_w, ten_w, twelve_w, tractor_head) VALUES
('2026-04-15', 'Manila', 25.50, 18.00, 15.75, 35.25, 'AAY 3082'),
('2026-04-14', 'Cebu', 22.00, 16.50, 18.50, 28.00, 'NBK 4295'),
('2026-04-13', 'Davao', 30.75, 22.00, 20.25, 40.50, 'NCS 4106'),
('2026-04-12', 'Iloilo', 27.25, 19.50, 17.00, 32.75, 'AAN 2734'),
('2026-04-11', 'Baguio', 24.50, 17.25, 16.50, 29.00, 'NDU 9697');

-- Insert sample data into diesel_records_min
INSERT INTO public.diesel_records_min (date, destination, four_w_six_w, eight_w, ten_w, twelve_w, tractor_head) VALUES
('2026-04-15', 'Manila', 20.00, 14.00, 12.50, 25.00, 'AAY 3082'),
('2026-04-14', 'Cebu', 18.00, 13.00, 15.00, 22.00, 'NBK 4295'),
('2026-04-13', 'Davao', 25.00, 18.00, 17.50, 35.00, 'NCS 4106'),
('2026-04-12', 'Iloilo', 22.00, 15.50, 14.00, 28.00, 'AAN 2734'),
('2026-04-11', 'Baguio', 20.00, 14.50, 13.50, 24.00, 'NDU 9697');

-- ============================================================
-- COMMENTS FOR DOCUMENTATION
-- ============================================================

COMMENT ON TABLE public.diesel_records_ave IS 'Average diesel consumption records for vehicles by destination and vehicle type';
COMMENT ON COLUMN public.diesel_records_ave.date IS 'Date of the diesel record';
COMMENT ON COLUMN public.diesel_records_ave.destination IS 'Destination location for the trip';
COMMENT ON COLUMN public.diesel_records_ave.four_w_six_w IS '4W/6W diesel consumption';
COMMENT ON COLUMN public.diesel_records_ave.eight_w IS '8W diesel consumption';
COMMENT ON COLUMN public.diesel_records_ave.ten_w IS '10W diesel consumption';
COMMENT ON COLUMN public.diesel_records_ave.twelve_w IS '12W diesel consumption (renamed from 18W)';
COMMENT ON COLUMN public.diesel_records_ave.tractor_head IS 'Tractor head plate number';

COMMENT ON TABLE public.diesel_records_min IS 'Minimum diesel consumption records for vehicles by destination and vehicle type';
COMMENT ON COLUMN public.diesel_records_min.date IS 'Date of the diesel record';
COMMENT ON COLUMN public.diesel_records_min.destination IS 'Destination location for the trip';
COMMENT ON COLUMN public.diesel_records_min.four_w_six_w IS '4W/6W diesel consumption';
COMMENT ON COLUMN public.diesel_records_min.eight_w IS '8W diesel consumption';
COMMENT ON COLUMN public.diesel_records_min.ten_w IS '10W diesel consumption';
COMMENT ON COLUMN public.diesel_records_min.twelve_w IS '12W diesel consumption (renamed from 18W)';
COMMENT ON COLUMN public.diesel_records_min.tractor_head IS 'Tractor head plate number';
