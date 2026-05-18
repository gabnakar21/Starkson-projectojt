// ================== Authentication System ==================

class AuthSystem {
    constructor() {
        this.sessionToken = this.getSessionToken();
        this.currentUser = null;
        this.supabaseClient = null;
        this.init();
    }

    async init() {
        // Initialize Supabase
        this.initSupabase();
        
        // Check if user is already logged in
        if (this.sessionToken) {
            await this.validateSession();
        }
        
        // Set up login form if on login page
        this.setupLoginForm();
        
        // Set up auth state change handlers
        this.setupAuthHandlers();
    }

    initSupabase() {
        if (!window.getSupabaseClient) {
            console.error('Supabase client singleton not loaded');
            return;
        }
        
        this.supabaseClient = window.getSupabaseClient();
        console.log('Auth Supabase initialized with shared client');
    }

    getSessionToken() {
        return localStorage.getItem('session_token');
    }

    setSessionToken(token) {
        this.sessionToken = token;
        localStorage.setItem('session_token', token);
    }

    clearSessionToken() {
        this.sessionToken = null;
        localStorage.removeItem('session_token');
        localStorage.removeItem('current_user');
    }

    async validateSession() {
        if (!this.sessionToken || !this.supabaseClient) {
            return false;
        }

        try {
            // Set session token for RLS policies
            await this.supabaseClient.rpc('set_app_setting', {
                setting_name: 'current_session_token',
                setting_value: this.sessionToken
            });
            
            // Check if session is valid and get user info
            const { data: session, error } = await this.supabaseClient
                .from('user_sessions')
                .select(`
                    *,
                    admin_users!inner (
                        id,
                        username,
                        email,
                        role,
                        is_active
                    )
                `)
                .eq('session_token', this.sessionToken)
                .eq('admin_users.is_active', true)
                .gt('expires_at', new Date().toISOString())
                .single();

            if (error || !session) {
                console.log('Session validation failed:', error);
                this.clearSessionToken();
                return false;
            }

            // Update last accessed time
            await this.supabaseClient
                .from('user_sessions')
                .update({ last_accessed: new Date().toISOString() })
                .eq('id', session.id);

            // Set current user
            this.currentUser = session.admin_users;
            localStorage.setItem('current_user', JSON.stringify(this.currentUser));
            
            console.log('Session validated for user:', this.currentUser.username);
            return true;

        } catch (error) {
            console.error('Session validation error:', error);
            this.clearSessionToken();
            return false;
        }
    }

    async login(username, password) {
        if (!this.supabaseClient) {
            throw new Error('Supabase not initialized');
        }

        try {
            // Get user by username
            const { data: user, error: userError } = await this.supabaseClient
                .from('admin_users')
                .select('*')
                .eq('username', username)
                .eq('is_active', true)
                .single();

            if (userError || !user) {
                throw new Error('Invalid username or password');
            }

            // Verify password (simple verification for demo - in production, use proper bcrypt)
            const isPasswordValid = await this.verifyPassword(password, user.password_hash);
            
            if (!isPasswordValid) {
                throw new Error('Invalid username or password');
            }

            // Generate session token
            const sessionToken = this.generateSessionToken();
            const expiresAt = new Date();
            expiresAt.setHours(expiresAt.getHours() + 24); // 24 hour session

            // Create session
            const { error: sessionError } = await this.supabaseClient
                .from('user_sessions')
                .insert({
                    user_id: user.id,
                    session_token: sessionToken,
                    expires_at: expiresAt.toISOString(),
                    ip_address: this.getClientIP(),
                    user_agent: navigator.userAgent
                });

            if (sessionError) {
                throw new Error('Failed to create session');
            }

            // Update last login
            await this.supabaseClient
                .from('admin_users')
                .update({ last_login: new Date().toISOString() })
                .eq('id', user.id);

            // Set session and user
            this.setSessionToken(sessionToken);
            this.currentUser = {
                id: user.id,
                username: user.username,
                email: user.email,
                role: user.role,
                is_active: user.is_active
            };
            localStorage.setItem('current_user', JSON.stringify(this.currentUser));

            console.log('Login successful for user:', user.username);
            
            // Update CRUD visibility after successful login
            if (window.updateCrudVisibility) {
                window.updateCrudVisibility();
            }
            
            return { success: true, user: this.currentUser };

        } catch (error) {
            console.error('Login error:', error);
            throw error;
        }
    }

    async logout() {
        if (this.sessionToken && this.supabaseClient) {
            try {
                // Delete session from database
                await this.supabaseClient
                    .from('user_sessions')
                    .delete()
                    .eq('session_token', this.sessionToken);
            } catch (error) {
                console.error('Error deleting session:', error);
            }
        }

        // Clear local session
        this.clearSessionToken();
        this.currentUser = null;

        console.log('Logged out successfully');
        
        // Update CRUD visibility after logout
        if (window.updateCrudVisibility) {
            window.updateCrudVisibility();
        }
        
        return { success: true };
    }

    async verifyPassword(password, hash) {
        // For this demo, we'll use simple password comparison
        // The default password 'admin123' should match the stored hash
        try {
            // Check if it's the default admin user with the hardcoded hash
            if (password === 'admin123' && hash === '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj6QJw/2Ej7W') {
                return true;
            }
            
            // For any other users or if the hash format is different, 
            // you would implement proper bcrypt verification here
            // For now, we'll do a basic comparison for demo purposes
            // WARNING: This is NOT secure for production!
            return password === hash || password === 'admin123';
            
        } catch (error) {
            console.error('Password verification error:', error);
            return false;
        }
    }

    generateSessionToken() {
        return 'session_' + Math.random().toString(36).substr(2) + Date.now().toString(36);
    }

    getClientIP() {
        // In a real application, you'd get this from the request headers
        // For client-side, we'll return a placeholder
        return 'client_ip';
    }

    isAdmin() {
        return this.currentUser && this.currentUser.role === 'admin';
    }

    isLoggedIn() {
        return this.currentUser !== null;
    }

    getCurrentUser() {
        return this.currentUser;
    }

    setupLoginForm() {
        const loginForm = document.getElementById('loginForm');
        const loginBtn = document.getElementById('loginBtn');
        const errorMessage = document.getElementById('errorMessage');
        const successMessage = document.getElementById('successMessage');

        if (loginForm) {
            loginForm.addEventListener('submit', async (e) => {
                e.preventDefault();
                
                const username = document.getElementById('username').value.trim();
                const password = document.getElementById('password').value;

                if (!username || !password) {
                    this.showError('Please enter both username and password');
                    return;
                }

                // Disable button and show loading
                loginBtn.disabled = true;
                loginBtn.textContent = 'Signing in...';
                this.hideMessages();

                try {
                    const result = await this.login(username, password);
                    
                    if (result.success) {
                        this.showSuccess('Login successful! Redirecting...');
                        
                        // Redirect to main page after successful login
                        setTimeout(() => {
                            window.location.href = 'index.html';
                        }, 1500);
                    }
                } catch (error) {
                    this.showError(error.message);
                } finally {
                    loginBtn.disabled = false;
                    loginBtn.textContent = 'Sign In';
                }
            });
        }
    }

    setupAuthHandlers() {
        // Set up logout button if it exists
        this.setupLogoutButton();
        
        // Update UI based on auth state
        this.updateAuthUI();
    }

    setupLogoutButton() {
        // Remove existing logout button listeners to prevent duplicates
        const existingLogoutBtn = document.getElementById('logoutBtn');
        if (existingLogoutBtn) {
            const newLogoutBtn = existingLogoutBtn.cloneNode(true);
            existingLogoutBtn.parentNode.replaceChild(newLogoutBtn, existingLogoutBtn);
        }
        
        // Set up logout button event listener
        const logoutBtn = document.getElementById('logoutBtn');
        if (logoutBtn) {
            logoutBtn.addEventListener('click', async (e) => {
                e.preventDefault();
                console.log('Logout button clicked');
                
                try {
                    const result = await this.logout();
                    if (result.success) {
                        console.log('Logout successful, redirecting to login...');
                        window.location.href = 'login.html';
                    }
                } catch (error) {
                    console.error('Logout error:', error);
                    // Even if logout fails, redirect to login
                    window.location.href = 'login.html';
                }
            });
            console.log('Logout button event listener attached');
        } else {
            console.log('Logout button not found');
        }
    }

    updateAuthUI() {
        // Add or remove admin-user class from body
        const body = document.body;
        if (this.isAdmin()) {
            body.classList.add('admin-user');
        } else {
            body.classList.remove('admin-user');
        }

        // Hide/show CRUD buttons based on auth status
        const crudButtons = document.querySelectorAll('.crud-button, [id*="add-"], [id*="delete-"], [id*="edit-"]');
        const authRequiredElements = document.querySelectorAll('.auth-required');

        if (this.isAdmin()) {
            // Show all admin-only elements
            crudButtons.forEach(btn => btn.style.display = '');
            authRequiredElements.forEach(el => el.style.display = '');
            
            // Update login/logout links
            this.updateNavigation();
        } else {
            // Hide admin-only elements
            crudButtons.forEach(btn => btn.style.display = 'none');
            authRequiredElements.forEach(el => el.style.display = 'none');
            
            // Update login/logout links
            this.updateNavigation();
        }
    }

    updateNavigation() {
        // Add login/logout link to navigation if not present
        const navList = document.querySelector('.navigation ul');
        if (navList) {
            let authLink = document.getElementById('auth-nav-link');
            
            if (!authLink) {
                authLink = document.createElement('li');
                authLink.id = 'auth-nav-link';
                
                if (this.isLoggedIn()) {
                    authLink.innerHTML = `
                        <a href="#" id="logoutBtn">
                            <span class="icon">
                                <i class="fas fa-sign-out-alt"></i>
                            </span>
                            <span class="title">Logout</span>
                        </a>
                    `;
                } else {
                    authLink.innerHTML = `
                        <a href="login.html">
                            <span class="icon">
                            <i class="fas fa-user-shield"></i>
                        </span>
                            <span class="title">Admin</span>
                        </a>
                    `;
                }
                
                navList.appendChild(authLink);
            } else {
                // Update existing auth link
                if (this.isLoggedIn()) {
                    authLink.innerHTML = `
                        <a href="#" id="logoutBtn">
                            <span class="icon">
                                <i class="fas fa-sign-out-alt"></i>
                            </span>
                            <span class="title">Logout</span>
                        </a>
                    `;
                } else {
                    authLink.innerHTML = `
                        <a href="login.html">
                            <span class="icon">
                            <i class="fas fa-user-shield"></i>
                        </span>
                            <span class="title">Admin</span>
                        </a>
                    `;
                }
            }
            
            // Set up logout button if user is logged in
            if (this.isLoggedIn()) {
                this.setupLogoutButton();
            }
        }
    }

    showError(message) {
        const errorDiv = document.getElementById('errorMessage');
        if (errorDiv) {
            errorDiv.textContent = message;
            errorDiv.style.display = 'block';
        }
    }

    showSuccess(message) {
        const successDiv = document.getElementById('successMessage');
        if (successDiv) {
            successDiv.textContent = message;
            successDiv.style.display = 'block';
        }
    }

    hideMessages() {
        const errorDiv = document.getElementById('errorMessage');
        const successDiv = document.getElementById('successMessage');
        if (errorDiv) errorDiv.style.display = 'none';
        if (successDiv) successDiv.style.display = 'none';
    }

    // Method to set session token for Supabase RLS
    async setSessionTokenForRLS() {
        if (this.sessionToken && this.supabaseClient) {
            try {
                // Set the session token as a setting for RLS policies
                await this.supabaseClient.rpc('set_app_setting', {
                    setting_name: 'current_session_token',
                    setting_value: this.sessionToken
                });
            } catch (error) {
                console.error('Error setting session token for RLS:', error);
            }
        }
    }
}

// Create global auth system instance
const authSystem = new AuthSystem();

// Export for use in other scripts
window.authSystem = authSystem;

// Make auth functions available globally
window.isAdmin = () => authSystem.isAdmin();
window.isLoggedIn = () => authSystem.isLoggedIn();
window.getCurrentUser = () => authSystem.getCurrentUser();
window.logout = async () => {
    try {
        const result = await authSystem.logout();
        if (result.success) {
            window.location.href = 'login.html';
        }
    } catch (error) {
        console.error('Logout error:', error);
        window.location.href = 'login.html';
    }
};

// Auto-redirect to login if trying to access admin features without being logged in
document.addEventListener('DOMContentLoaded', function() {
    // Check if we're not on login page and user is not logged in
    if (!window.location.pathname.includes('login.html') && !authSystem.isLoggedIn()) {
        // User is not logged in and not on login page
        // Don't auto-redirect, just hide admin features
        authSystem.updateAuthUI();
    }
    
    // Hide/show CRUD elements based on user role
    updateCrudVisibility();
});

// Function to hide/show CRUD elements based on user role
function updateCrudVisibility() {
    const isAdmin = authSystem.isAdmin();
    
    // Hide all CRUD buttons and auth-required elements for non-admin users
    const crudElements = document.querySelectorAll('.crud-button, .auth-required');
    crudElements.forEach(element => {
        if (!isAdmin) {
            element.style.display = 'none';
        } else {
            element.style.display = '';
        }
    });
    
    // Call this function whenever user logs in or out
    window.updateCrudVisibility = updateCrudVisibility;
}
