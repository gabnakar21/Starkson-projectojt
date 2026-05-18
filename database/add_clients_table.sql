-- Add missing clients table
DROP TABLE IF EXISTS public.clients CASCADE;

CREATE TABLE public.clients (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    plant TEXT NOT NULL,
    destination TEXT NOT NULL,
    address TEXT NOT NULL,
    going_to TEXT,
    going_back TEXT,
    total_km DECIMAL(10,2),
    average_time TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE public.clients DISABLE ROW LEVEL SECURITY;

-- Create indexes for better performance
CREATE INDEX idx_clients_plant ON public.clients(plant);
CREATE INDEX idx_clients_destination ON public.clients(destination);

-- CLIENTS TABLE POLICIES
DROP POLICY IF EXISTS "Enable read access for all users" ON public.clients;
DROP POLICY IF EXISTS "Enable insert for admin users only" ON public.clients;
DROP POLICY IF EXISTS "Enable update for admin users only" ON public.clients;
DROP POLICY IF EXISTS "Enable delete for admin users only" ON public.clients;

CREATE POLICY "Enable read access for all users" ON public.clients
  FOR SELECT
  USING (true);

CREATE POLICY "Enable insert for admin users only" ON public.clients
  FOR INSERT
  WITH CHECK (is_admin_from_session());

CREATE POLICY "Enable update for admin users only" ON public.clients
  FOR UPDATE
  USING (is_admin_from_session())
  WITH CHECK (is_admin_from_session());

CREATE POLICY "Enable delete for admin users only" ON public.clients
  FOR DELETE
  USING (is_admin_from_session());

-- Create a function to automatically update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_clients_updated_at()
  RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_clients_updated_at 
    BEFORE UPDATE ON public.clients
    FOR EACH ROW 
    EXECUTE FUNCTION update_clients_updated_at();

-- Insert sample client data
INSERT INTO public.clients (plant, destination, address, going_to, going_back, total_km, average_time) VALUES
('DISNEY 3', 'Manila', '123 Main St, Manila', '08:00 AM', '05:00 PM', 150.5, '9 hours'),
('DISNEY 6', 'Cavite', '456 Highway, Cavite', '07:30 AM', '04:30 PM', 89.2, '9 hours'),
('DISNEY 3', 'Batangas', '789 Coastal Rd, Batangas', '09:00 AM', '06:00 PM', 234.8, '9 hours');
