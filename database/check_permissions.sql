    -- Check current user and permissions
    SELECT 
        current_user as current_database_user,
        session_user as session_user,
        version();

    -- Check table ownership
    SELECT 
        schemaname,
        tablename,
        tableowner,
        has_table_privilege(current_user, tablename, 'UPDATE') as can_update,
        has_table_privilege(current_user, tablename, 'INSERT') as can_insert,
        has_table_privilege(current_user, tablename, 'SELECT') as can_select
    FROM pg_tables 
    WHERE tablename = 'drivers_status';

    -- Check if columns exist
    SELECT 
        column_name,
        data_type,
        is_nullable
    FROM information_schema.columns 
    WHERE table_name = 'drivers_status' 
    AND column_name IN ('or_image_url', 'or_image_name', 'cr_image_url', 'cr_image_name')
    ORDER BY column_name;
