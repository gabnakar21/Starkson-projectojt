-- Drop GPS Status Table and Associated Objects

-- Drop the GPS trigger first
DROP TRIGGER IF EXISTS update_gps_status_updated_at ON gps_status;

-- Drop the indexes
DROP INDEX IF EXISTS idx_gps_status_plate;
DROP INDEX IF EXISTS idx_gps_status_plant;
DROP INDEX IF EXISTS idx_gps_status_date;

-- Drop the table
DROP TABLE IF EXISTS gps_status;

-- Note: The update_updated_at_column() function is preserved because
-- it's being used by other tables in the database
