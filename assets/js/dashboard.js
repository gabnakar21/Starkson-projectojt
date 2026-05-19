// ====================== Dashboard View Functions ==========================

// Initialize dashboard when view is shown
function initializeDashboard() {
  console.log('Dashboard view initialized');
  
  // Load dashboard-specific data if needed
  loadDashboardData();
  
  // Setup dashboard-specific event listeners
  setupDashboardEventListeners();
}

// Setup dashboard event listeners
function setupDashboardEventListeners() {
  // Add any dashboard-specific event listeners here
  console.log('Dashboard event listeners setup');
}

// Load dashboard data
async function loadDashboardData() {
  if (!window.getSupabaseClient) return;
  
  try {
    const supabaseClient = window.getSupabaseClient();
    
    // Load dashboard statistics
    await loadDashboardStatistics();
    
    // Load recent activities
    await loadRecentActivities();
    
    console.log('Dashboard data loaded successfully');
    
  } catch (error) {
    console.error('Error loading dashboard data:', error);
    if (window.showError) {
      showError('Failed to load dashboard data: ' + error.message, 'Error');
    }
  }
}

// Load dashboard statistics
async function loadDashboardStatistics() {
  const supabaseClient = window.getSupabaseClient();
  if (!supabaseClient) return;
  
  try {
    // Get vehicle count - try vehicle_registry first, fallback to vehicles
    let vehicleCount = 0;
    const { data: vehicles, error: vehicleError } = await supabaseClient
      .from('vehicle_registry')
      .select('*');
    
    if (!vehicleError) {
      vehicleCount = vehicles?.length || 0;
    } else {
      // Fallback to vehicles table
      console.warn('vehicle_registry error, trying vehicles table:', vehicleError);
      const { data: fallbackVehicles, error: fallbackError } = await supabaseClient
        .from('vehicles')
        .select('*');
      if (!fallbackError) {
        vehicleCount = fallbackVehicles?.length || 0;
      }
    }
    updateDashboardStat('vehicle-count', vehicleCount);
    
    // Get trailer count
    let trailerCount = 0;
    const { data: trailers, error: trailerError } = await supabaseClient
      .from('trailer_registry')
      .select('*');
    
    if (!trailerError) {
      trailerCount = trailers?.length || 0;
    } else {
      console.warn('trailer_registry error:', trailerError);
    }
    updateDashboardStat('trailer-count', trailerCount);
    
    // Get active GPS count - removed since gps_status column doesn't exist
    // Setting to 0 for now until the column is added to the database
    updateDashboardStat('gps-active-count', 0);
    
  } catch (error) {
    console.error('Error loading dashboard statistics:', error);
  }
}

// Update dashboard statistic
function updateDashboardStat(elementId, value) {
  const element = document.getElementById(elementId);
  if (element) {
    element.textContent = value;
  }
}

// Load recent activities
async function loadRecentActivities() {
  // Implementation for loading recent activities
  console.log('Loading recent activities...');
}

// Export functions for use in main.js
window.dashboardModule = {
  initializeDashboard,
  loadDashboardData,
  loadDashboardStatistics,
  loadRecentActivities
};
