// ====================== GPS Status View Functions ==========================

// GPS Status Variables
let gpsStatusRecords = [];

// Initialize GPS status when view is shown
function initializeGpsStatus() {
  console.log('GPS Status view initialized');
  loadGpsStatus();
}

// Load GPS status records
async function loadGpsStatus() {
  if (!window.getSupabaseClient) return;
  
  const supabaseClient = window.getSupabaseClient();
  
  // Table is intentionally kept empty
  console.log('GPS Status table cleared');
  return;
}

// Generate random location for demo purposes
function getRandomLocation() {
  const locations = [
    'Manila, Philippines',
    'Quezon City, Philippines', 
    'Cavite, Philippines',
    'Cebu, Philippines',
    'Makati, Philippines',
    'Pasay, Philippines'
  ];
  
  return locations[Math.floor(Math.random() * locations.length)];
}

// Display GPS status records in table
function displayGpsStatus(records) {
  const tableBody = document.querySelector('#gps-status-table tbody');
  if (!tableBody) return;

  if (records.length === 0) {
    tableBody.innerHTML = `
      <tr>
        <td colspan="6" style="text-align: center; padding: 40px; color: #666;">
          <div style="margin-bottom: 10px;">
            <ion-icon name="location-outline" style="font-size: 48px; color: #ccc;"></ion-icon>
          </div>
          <div>No GPS tracking data available</div>
          <div style="font-size: 12px; margin-top: 5px;">GPS tracking will appear here when vehicles are equipped with GPS devices</div>
        </td>
      </tr>
    `;
    return;
  }

  const rows = records.map(record => {
    const statusClass = record.gps_status === 'Active' ? 'status-active' : 'status-inactive';
    const signalBars = generateSignalBars(record.signal_strength);
    
    return `
      <tr>
        <td>${record.plate}</td>
        <td>${record.vehicle}</td>
        <td><span class="status-badge ${statusClass}">${record.gps_status}</span></td>
        <td>${formatDateTime(record.last_update)}</td>
        <td>${record.location}</td>
        <td>${signalBars}</td>
      </tr>
    `;
  }).join('');

  tableBody.innerHTML = rows;
}

// Generate signal bars visualization
function generateSignalBars(strength) {
  const bars = [];

  for (let i = 1; i <= 5; i++) {
    const filled = i <= strength ? 'filled' : '';
    bars.push(`<div class="signal-bar ${filled}"></div>`);
  }

  return `<div class="signal-strength">${bars.join('')}</div>`;
}

// Format date time
function formatDateTime(dateString) {
  if (!dateString) return 'N/A';

  const date = new Date(dateString);
  
  // Format: MM/DD/YYYY HH:MM AM/PM
  const options = {
    month: '2-digit',
    day: '2-digit',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    hour12: true
  };
  
  return date.toLocaleString('en-US', options);
}

// Load GPS status data (alias for compatibility)
async function loadGpsStatusData() {
  return loadGpsStatus();
}

// Export functions for use in main.js
window.gpsStatusModule = {
  initializeGpsStatus,
  loadGpsStatus,
  loadGpsStatusData,
  displayGpsStatus,
  getRandomLocation,
  generateSignalBars,
  formatDateTime
};
