# Supabase Dashboard Integration

This guide shows how to connect your dashboard to Supabase for dynamic database functionality.

## Step 1: Set up Supabase

1. Go to [supabase.com](https://supabase.com) and create a free account
2. Create a new project
3. Wait for the project to be set up (takes a few minutes)
4. Go to Settings → API in your Supabase dashboard
5. Copy your Project URL and anon/public key

## Step 2: Configure Your Code

1. In `assets/js/main.js`, replace:
   - `YOUR_SUPABASE_URL` with your project URL
   - `YOUR_SUPABASE_ANON_KEY` with your anon key

## Step 3: Set up Database Tables

1. In your Supabase dashboard, go to the SQL Editor
2. Copy and run the SQL from `database-setup.sql`
3. This creates `orders` and `customers` tables with sample data

## Step 4: Test the Connection

1. Open `index.html` in your browser
2. The dashboard should now load data from Supabase
3. Check the browser console for any errors

## Database Schema

### Orders Table
- id (auto-increment)
- product_name
- price
- payment_status
- status
- created_at

### Customers Table
- id (auto-increment)
- name
- location
- avatar
- email
- created_at

### Vehicles Table
- id (auto-increment)
- plate
- model
- size
- year_model
- created_at

## Next Steps

- Add authentication for secure access
- Implement CRUD operations (Create, Read, Update, Delete)
- Add real-time subscriptions for live updates
- Set up proper Row Level Security policies

## Troubleshooting

- Make sure your Supabase keys are correct
- Check browser console for JavaScript errors
- Verify your table names match the code
- Ensure CORS is enabled (should be by default in Supabase)