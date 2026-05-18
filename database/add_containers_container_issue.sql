-- Add missing container_issue column to containers table
-- Run this script if the containers table exists but needs the container_issue column

-- Add container_issue column if it doesn't exist
DO $$
BEGIN
    -- Add container_issue column
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'containers' AND column_name = 'container_issue'
    ) THEN
        ALTER TABLE public.containers ADD COLUMN container_issue TEXT;
        RAISE NOTICE 'Added container_issue column to containers table';
    ELSE
        RAISE NOTICE 'container_issue column already exists in containers table';
    END IF;
END $$;

-- Update sample data to include container_issue
UPDATE public.containers 
SET container_issue = 'No issues - container in good condition'
WHERE container_issue IS NULL AND status = 'OPERATIONAL';

UPDATE public.containers 
SET container_issue = 'Minor dent on side panel - cosmetic only'
WHERE container_issue IS NULL AND status = 'OPERATIONAL/HUSTLING';

UPDATE public.containers 
SET container_issue = 'Door seal damaged - needs repair before use'
WHERE container_issue IS NULL AND status = 'DOWN';

-- Add index for container_issue column if frequently searched
CREATE INDEX IF NOT EXISTS idx_containers_container_issue ON public.containers(container_issue);

-- Verify the table structure
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'containers' 
ORDER BY ordinal_position;

-- Show sample data with container_issue
SELECT chassi_no, container, status, container_issue 
FROM public.containers 
LIMIT 5;
