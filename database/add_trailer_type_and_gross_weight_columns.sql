  -- Add trailer_type and gross_weight columns to trailer_registry table
  -- This script adds the missing columns for Trailer Type and Gross Weight functionality

  DO $$
  BEGIN
    -- Add trailer_type column if it doesn't exist
    IF NOT EXISTS (
      SELECT 1 FROM information_schema.columns 
      WHERE table_name = 'trailer_registry' AND column_name = 'trailer_type'
    ) THEN
      ALTER TABLE public.trailer_registry ADD COLUMN trailer_type TEXT DEFAULT NULL;
      RAISE NOTICE 'trailer_type column added to trailer_registry table';
    END IF;

    -- Add gross_weight column if it doesn't exist
    IF NOT EXISTS (
      SELECT 1 FROM information_schema.columns 
      WHERE table_name = 'trailer_registry' AND column_name = 'gross_weight'
    ) THEN
      ALTER TABLE public.trailer_registry ADD COLUMN gross_weight TEXT DEFAULT NULL;
      RAISE NOTICE 'gross_weight column added to trailer_registry table';
    END IF;
  END $$;

  -- Create indexes for better performance
  CREATE INDEX IF NOT EXISTS idx_trailer_registry_type ON public.trailer_registry(trailer_type);
  CREATE INDEX IF NOT EXISTS idx_trailer_registry_gross_weight ON public.trailer_registry(gross_weight);

  -- Verify the table structure
  SELECT 
      column_name, 
      data_type, 
      is_nullable,
      column_default
  FROM information_schema.columns 
  WHERE table_name = 'trailer_registry' 
  ORDER BY ordinal_position;
