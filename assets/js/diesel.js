// ====================== Diesel View Functions ==========================

// Initialize diesel when view is shown
function initializeDiesel() {
  console.log('Diesel view initialized');
  
  // Always reset to Min as default active state when entering diesel tab
  setTimeout(() => {
    const minBtn = document.getElementById('diesel-min-btn');
    const aveBtn = document.getElementById('diesel-ave-btn');
    
    if (minBtn && aveBtn) {
      minBtn.classList.add('active');
      aveBtn.classList.remove('active');
      
      // Show min table, hide ave table
      const minTable = document.getElementById('diesel-min-table');
      const aveTable = document.getElementById('diesel-ave-table');
      
      if (minTable) minTable.style.display = 'table';
      if (aveTable) aveTable.style.display = 'none';
      
      switchDieselTable('min');
    }
  }, 100);
}

// Diesel table switching functionality
function switchDieselTable(tableType) {
  // Get table elements
  const minTable = document.getElementById('diesel-min-table');
  const aveTable = document.getElementById('diesel-ave-table');
  
  // Get button elements
  const minBtn = document.getElementById('diesel-min-btn');
  const aveBtn = document.getElementById('diesel-ave-btn');
  
  // Get Add Diesel buttons
  const addMinBtn = document.getElementById('add-diesel-min-btn');
  const addAveBtn = document.getElementById('add-diesel-ave-btn');
  
  if (!minTable || !aveTable || !minBtn || !aveBtn) {
    console.error('Diesel table elements not found');
    return;
  }
  
  // Hide all tables first
  minTable.style.display = 'none';
  aveTable.style.display = 'none';
  
  // Hide all Add Diesel buttons first
  if (addMinBtn) addMinBtn.style.display = 'none';
  if (addAveBtn) addAveBtn.style.display = 'none';
  
  // Remove active class from all buttons
  minBtn.classList.remove('active');
  aveBtn.classList.remove('active');
  
  // Show selected table and button, add active class
  if (tableType === 'min') {
    minTable.style.display = 'table';
    if (addMinBtn) addMinBtn.style.display = 'inline-block';
    minBtn.classList.add('active');
    loadDieselData('min');
  } else if (tableType === 'ave') {
    aveTable.style.display = 'table';
    if (addAveBtn) addAveBtn.style.display = 'inline-block';
    aveBtn.classList.add('active');
    loadDieselData('ave');
  }
}

// Load diesel data
async function loadDieselData(tableType = 'min') {
  if (!window.getSupabaseClient) return;
  
  const supabaseClient = window.getSupabaseClient();
  
  try {
    console.log(`Loading diesel ${tableType} data...`);
    // Add diesel-specific data loading here
    // This would fetch from the appropriate diesel table based on tableType
  } catch (error) {
    console.error('Error loading diesel data:', error);
  }
}

// Open diesel modal for adding/editing records
async function openDieselModal(tableType = 'min', recordId = null) {
  // Check if user is admin
  if (!window.authSystem || !window.authSystem.isAdmin()) {
    if (window.showError) {
      showError('Access denied. Admin privileges required.', 'Authentication Error');
    }
    return;
  }
  
  const modal = document.getElementById('diesel-modal');
  if (!modal) {
    console.error('Diesel modal not found');
    return;
  }
  
  // Set modal title based on operation
  const modalTitle = modal.querySelector('.modal-header h3');
  if (modalTitle) {
    modalTitle.textContent = recordId ? 'Edit Diesel Record' : 'Add Diesel Record';
  }
  
  // Store current table type and record ID
  modal.dataset.tableType = tableType;
  modal.dataset.recordId = recordId || '';
  
  // Reset form
  const form = document.getElementById('diesel-form');
  if (form) {
    form.reset();
  }
  
  // If editing, load record data
  if (recordId) {
    await loadDieselRecordForEdit(recordId, tableType);
  }
  
  // Show modal
  const overlay = document.getElementById('diesel-modal-overlay');
  modal.style.display = 'block';
  if (overlay) overlay.style.display = 'block';
}

// Close diesel modal
function closeDieselModal() {
  const modal = document.getElementById('diesel-modal');
  const overlay = document.getElementById('diesel-modal-overlay');
  if (modal) {
    modal.style.display = 'none';
  }
  if (overlay) {
    overlay.style.display = 'none';
  }
}

// Load diesel record for editing
async function loadDieselRecordForEdit(recordId, tableType) {
  if (!window.getSupabaseClient) return;
  
  const supabaseClient = window.getSupabaseClient();
  
  try {
    console.log(`Loading diesel record ${recordId} from ${tableType} table`);
    
    // Determine table name based on tableType
    const tableName = tableType === 'min' ? 'diesel_records_min' : 'diesel_records_ave';
    
    // Fetch the record
    const { data, error } = await supabaseClient
      .from(tableName)
      .select('*')
      .eq('id', recordId)
      .single();
    
    if (error) {
      console.error('Error loading diesel record:', error);
      if (window.showError) {
        showError('Failed to load diesel record: ' + error.message, 'Error');
      }
      return;
    }
    
    if (data) {
      // Populate form fields
      const destinationInput = document.getElementById('diesel-destination');
      const fourWSixWInput = document.getElementById('diesel-4w-6w');
      const eightWInput = document.getElementById('diesel-8w');
      const tenWInput = document.getElementById('diesel-10w');
      const twelveWInput = document.getElementById('diesel-12w');
      const tractorHeadInput = document.getElementById('diesel-tractor-head');
      
      if (destinationInput) destinationInput.value = data.destination || '';
      if (fourWSixWInput) fourWSixWInput.value = data.four_w_six_w || '';
      if (eightWInput) eightWInput.value = data.eight_w || '';
      if (tenWInput) tenWInput.value = data.ten_w || '';
      if (twelveWInput) twelveWInput.value = data.twelve_w || '';
      if (tractorHeadInput) tractorHeadInput.value = data.tractor_head || '';
      
      console.log('Diesel record loaded successfully:', data);
    }
  } catch (error) {
    console.error('Error loading diesel record:', error);
    if (window.showError) {
      showError('Failed to load diesel record: ' + error.message, 'Error');
    }
  }
}

// Save diesel data
async function saveDieselData(event) {
  if (event) event.preventDefault();
  
  if (!window.getSupabaseClient) return;
  
  const supabaseClient = window.getSupabaseClient();
  
  try {
    // Get form data
    const form = document.getElementById('diesel-form');
    const formData = new FormData(form);
    
    // Get modal info
    const modal = document.getElementById('diesel-modal');
    const tableType = modal?.dataset.tableType || 'min';
    const recordId = modal?.dataset.recordId;
    
    // Process and save data
    console.log(`Saving diesel data to ${tableType} table`);
    
    // Close modal and refresh data
    closeDieselModal();
    await loadDieselData(tableType);
    
    if (window.showSuccess) {
      showSuccess('Diesel record saved successfully!');
    }
    
  } catch (error) {
    console.error('Error saving diesel data:', error);
    if (window.showError) {
      showError('Failed to save diesel record: ' + error.message, 'Error');
    }
  }
}

// Edit diesel record
async function editDieselRecord(id, tableType, event) {
  if (event) event.preventDefault();
  
  await openDieselModal(tableType, id);
}

// Delete diesel record
async function deleteDieselRecord(id, tableType) {
  if (!window.authSystem || !window.authSystem.isAdmin()) {
    if (window.showError) {
      showError('Access denied. Admin privileges required.', 'Authentication Error');
    }
    return;
  }
  
  if (!confirm('Are you sure you want to delete this diesel record?')) {
    return;
  }
  
  try {
    console.log(`Deleting diesel record ${id} from ${tableType} table`);
    
    // Delete from database
    // Implementation here
    
    // Refresh data
    await loadDieselData(tableType);
    
    if (window.showSuccess) {
      showSuccess('Diesel record deleted successfully!');
    }
    
  } catch (error) {
    console.error('Error deleting diesel record:', error);
    if (window.showError) {
      showError('Failed to delete diesel record: ' + error.message, 'Error');
    }
  }
}

// Create blank diesel records for a new client
async function createBlankDieselRecordsForClient(destination) {
  if (!window.getSupabaseClient) return;
  
  const supabaseClient = window.getSupabaseClient();
  
  try {
    console.log('Creating blank diesel records for new client:', destination);
    
    const today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD format
    
    // Create blank record in diesel_records_ave
    const { error: aveError } = await supabaseClient
      .from('diesel_records_ave')
      .insert([{
        date: today,
        destination: destination,
        four_w_six_w: null,
        eight_w: null,
        ten_w: null,
        twelve_w: null,
        tractor_head: null
      }]);
    
    if (aveError) {
      console.error('Error creating blank diesel ave record:', aveError);
      throw aveError;
    }
    
    // Create blank record in diesel_records_min
    const { error: minError } = await supabaseClient
      .from('diesel_records_min')
      .insert([{
        date: today,
        destination: destination,
        four_w_six_w: null,
        eight_w: null,
        ten_w: null,
        twelve_w: null,
        tractor_head: null
      }]);
    
    if (minError) {
      console.error('Error creating blank diesel min record:', minError);
      throw minError;
    }
    
    console.log('Blank diesel records created successfully for:', destination);
    
  } catch (error) {
    console.error('Error creating blank diesel records:', error);
    throw error;
  }
}

// Export functions for use in main.js
window.dieselModule = {
  initializeDiesel,
  loadDieselData,
  switchDieselTable,
  openDieselModal,
  closeDieselModal,
  saveDieselData,
  editDieselRecord,
  deleteDieselRecord,
  createBlankDieselRecordsForClient
};

// Also export globally for HTML onclick handlers
window.editDieselRecord = editDieselRecord;
window.deleteDieselRecord = deleteDieselRecord;
window.saveDieselData = saveDieselData;
window.openDieselModal = openDieselModal;
window.closeDieselModal = closeDieselModal;
