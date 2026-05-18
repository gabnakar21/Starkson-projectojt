-- Add issue fields to vehicle tables
-- Run these SQL commands in your Supabase SQL Editor

-- 1. Add truck_issue field to drivers_status table
ALTER TABLE public.drivers_status 
ADD COLUMN truck_issue TEXT;

-- 2. Add trailer_issue field to trailers table  
ALTER TABLE public.trailers 
ADD COLUMN trailer_issue TEXT;

-- 3. Add container_issue field to containers table
ALTER TABLE public.containers 
ADD COLUMN container_issue TEXT;

-- Update existing records with default values (optional)
UPDATE public.drivers_status SET truck_issue = '-' WHERE truck_issue IS NULL;
UPDATE public.trailers SET trailer_issue = '-' WHERE trailer_issue IS NULL;
UPDATE public.containers SET container_issue = '-' WHERE container_issue IS NULL;
