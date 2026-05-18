-- Add plant column to clients table
-- This migration adds the plant column to the clients table
-- Created: 2026-05-08

-- Add the plant column if it doesn't exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'clients' AND column_name = 'plant'
  ) THEN
    ALTER TABLE public.clients 
    ADD COLUMN plant TEXT NOT NULL DEFAULT 'DISNEY 3';
    
    -- Add comment to describe the column
    COMMENT ON COLUMN public.clients.plant IS 'Plant location for the client (DISNEY 3, DISNEY 6, HASBRO, WARNER)';
    
    -- Create index for better query performance
    CREATE INDEX IF NOT EXISTS idx_clients_plant ON public.clients(plant);
    
    RAISE NOTICE 'Plant column added to clients table successfully';
  ELSE
    RAISE NOTICE 'Plant column already exists in clients table';
  END IF;
END $$;
