# 🏥 OpenEMR Auto Insurance Billing on Checkout

## 📋 **Overview**
This modification automatically submits insurance claims when an appointment status is changed to "Checked Out", eliminating manual intervention in the billing process.

## 🔧 **Files Created**

### **1. Core Auto Billing Logic**
- **File**: `library/auto_billing.php`
- **Purpose**: Handles the automatic claim creation and submission
- **Functions**:
  - `auto_submit_insurance_claim()` - Main billing function
  - `create_insurance_claim()` - Creates claim records
  - `handle_appointment_status_change()` - Status change hook

### **2. Integration Hook**
- **File**: `interface/main/calendar/auto_billing_hook.php`
- **Purpose**: Connects status changes to auto billing
- **Features**:
  - AJAX handler for status updates
  - Permission checking
  - User feedback messages

### **3. JavaScript Integration**
- **File**: `public/assets/js/auto_billing_integration.js`
- **Purpose**: Frontend integration with calendar interface
- **Features**:
  - Automatic status change detection
  - User confirmation dialogs
  - Progress indicators

## ⚙️ **Installation Steps**

### **Step 1: Database Setup (Optional Enhancement)**
Run this SQL to add logging table:

```sql
CREATE TABLE IF NOT EXISTS billing_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pid INT NOT NULL,
    encounter INT NOT NULL,
    action VARCHAR(50) NOT NULL,
    user VARCHAR(50) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    INDEX idx_pid_encounter (pid, encounter)
);
```

### **Step 2: Include JavaScript in Calendar Pages**
Add to calendar template files (usually in `interface/main/calendar/`):

```html
<script src="/public/assets/js/auto_billing_integration.js"></script>
```

### **Step 3: Configure Checkout Status Values**
Edit the status values in `auto_billing.php` line 89:

```php
$checkout_statuses = array('>', 'CO', 'CHECKOUT', 'CHECKED_OUT', '3');
```

Update these to match your OpenEMR appointment status codes.

### **Step 4: Test the Integration**
1. Create a test appointment
2. Ensure patient has primary insurance
3. Add billable charges (CPT codes)
4. Change status to "Checked Out"
5. Verify claim is created automatically

## 🎯 **How It Works**

### **Workflow**:
1. **User Changes Status** → Appointment status changed to checkout
2. **JavaScript Detects** → Confirms action with user
3. **AJAX Call** → Sends request to auto_billing_hook.php
4. **Status Update** → Normal appointment status update
5. **Auto Billing Trigger** → Checks conditions and creates claim
6. **Claim Creation** → Generates insurance claim record
7. **User Feedback** → Shows success/error message

### **Conditions for Auto Billing**:
- ✅ Appointment status = "Checked Out"
- ✅ Patient has primary insurance
- ✅ Encounter has billable charges
- ✅ No existing claim for this encounter
- ✅ User has appropriate permissions

## 🛠️ **Customization Options**

### **1. Custom Status Codes**
Modify `$checkout_statuses` array to match your setup:

```php
$checkout_statuses = array('CHECKOUT', 'COMPLETE', 'DONE');
```

### **2. Additional Validations**
Add custom checks in `auto_submit_insurance_claim()`:

```php
// Example: Require diagnosis codes
$diagnoses = sqlStatement("SELECT * FROM billing WHERE pid = ? AND encounter = ? AND code_type = 'ICD10'", 
                         array($patient_id, $encounter_id));
if (sqlNumRows($diagnoses) == 0) {
    return false; // No diagnosis codes
}
```

### **3. Custom Notifications**
Modify the JavaScript messages or add email notifications:

```javascript
// Send email notification
fetch('/custom/notify_billing_department.php', {
    method: 'POST',
    body: JSON.stringify({encounter_id: eventId, claim_id: claimId})
});
```

## 🔍 **Troubleshooting**

### **Common Issues**:

1. **Claims Not Created**:
   - Check error logs: `/var/log/apache2/error.log`
   - Verify insurance information exists
   - Confirm billable charges present

2. **JavaScript Not Working**:
   - Check browser console for errors
   - Verify script is included in calendar pages
   - Confirm CSP settings allow inline scripts

3. **Permission Errors**:
   - Verify user has billing permissions
   - Check `users_secure` table for proper ACL settings

## 📊 **Monitoring & Reporting**

### **View Auto Billing Activity**:
```sql
SELECT bl.*, p.fname, p.lname, fe.date 
FROM billing_log bl
JOIN patient_data p ON bl.pid = p.pid  
JOIN form_encounter fe ON bl.encounter = fe.encounter AND bl.pid = fe.pid
WHERE bl.action = 'AUTO_SUBMIT_INSURANCE'
ORDER BY bl.timestamp DESC;
```

### **Check Success Rate**:
```sql
SELECT 
    COUNT(*) as total_checkouts,
    SUM(CASE WHEN c.claim_id IS NOT NULL THEN 1 ELSE 0 END) as auto_billed
FROM billing_log bl
LEFT JOIN claims c ON bl.pid = c.patient_id AND bl.encounter = c.encounter_id
WHERE bl.action = 'AUTO_SUBMIT_INSURANCE'
AND bl.timestamp >= DATE_SUB(NOW(), INTERVAL 30 DAY);
```

## ⚡ **Benefits**

- ✅ **Eliminates Manual Steps** - No more clicking "Bill Insurance"
- ✅ **Reduces Errors** - Consistent billing process
- ✅ **Faster Cash Flow** - Claims submitted immediately
- ✅ **Better Workflow** - Seamless checkout process
- ✅ **Audit Trail** - Complete logging of auto-billing actions

## 🚨 **Important Notes**

- **Test Thoroughly** before production use
- **Backup Database** before installation
- **Verify Insurance Setup** is correct
- **Check Local Regulations** for auto-billing compliance
- **Monitor Initially** to ensure proper operation

Your OpenEMR system will now automatically handle insurance billing on checkout! 🎉