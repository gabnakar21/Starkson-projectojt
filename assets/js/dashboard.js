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
    // Get vehicle count
    const { count: vehicleCount, error: vehicleError } = await supabaseClient
      .from('vehicle_registry')
      .select('id', { count: 'exact', head: true });
    
    if (!vehicleError) {
      updateDashboardStat('vehicle-count', vehicleCount || 0);
    }
    
    // Get trailer count
    const { count: trailerCount, error: trailerError } = await supabaseClient
      .from('trailer_registry')
      .select('id', { count: 'exact', head: true });
    
    if (!trailerError) {
      updateDashboardStat('trailer-count', trailerCount || 0);
    }
    
    // Get active GPS count
    const { count: gpsActiveCount, error: gpsError } = await supabaseClient
      .from('vehicle_registry')
      .select('id', { count: 'exact', head: true })
      .eq('gps_status', 'Active');
    
    if (!gpsError) {
      updateDashboardStat('gps-active-count', gpsActiveCount || 0);
    }
    
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
