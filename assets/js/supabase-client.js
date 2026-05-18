// Shared Supabase Client Singleton
// Prevents multiple instances and ensures single connection

class SupabaseClientSingleton {
    constructor() {
        this.client = null;
        this.initialized = false;
    }

    getClient() {
        if (!this.client && !this.initialized) {
            if (!window.supabase) {
                console.error('Supabase library not loaded');
                return null;
            }
            
            const url = 'https://kultalsjdlxvgixnswqb.supabase.co';
            const key = 'sb_publishable_rRLGDvbi9h0zWoSBQ8w-LA_nHGOXsHp';
            
            this.client = window.supabase.createClient(url, key);
            this.initialized = true;
            console.log('Shared Supabase client initialized');
        }
        
        return this.client;
    }

    isInitialized() {
        return this.initialized && this.client !== null;
    }
}

// Create global singleton instance
window.supabaseClientSingleton = new SupabaseClientSingleton();

// Export the getClient function for easy access
window.getSupabaseClient = () => window.supabaseClientSingleton.getClient();
