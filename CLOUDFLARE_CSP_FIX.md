# 🛡️ Cloudflare Security Settings for OpenEMR

## 🚨 **CSP Issue Resolution**

The Content Security Policy warnings you're seeing are from Cloudflare's security features being too restrictive for OpenEMR's JavaScript requirements.

## 🔧 **Fix in Cloudflare Dashboard:**

### **Step 1: Access Security Settings**
1. Go to [dash.cloudflare.com](https://dash.cloudflare.com)
2. Select `badgertechnologies.us`
3. Navigate to **Security** → **WAF**

### **Step 2: Modify Security Level**
Navigate to **Security** → **Settings**
- **Security Level**: Change from "High" to **"Medium"** or **"Low"**

### **Step 3: Disable Browser Integrity Check (Temporarily)**
- Find **"Browser Integrity Check"**
- **Disable** it for OpenEMR subdomain

### **Step 4: Create Page Rule for OpenEMR**
Navigate to **Rules** → **Page Rules** → **Create Page Rule**

**URL Pattern**: `openemr.badgertechnologies.us/*`

**Settings to Add**:
- **Security Level**: Low
- **Browser Integrity Check**: Off
- **Email Obfuscation**: Off
- **Server Side Excludes**: Off
- **Hotlink Protection**: Off

### **Step 5: Custom CSP Headers (Advanced)**
Navigate to **Rules** → **Transform Rules** → **HTTP Response Header Modification**

**Create Rule**:
- **Rule Name**: `OpenEMR CSP Fix`
- **When incoming requests match**: `openemr.badgertechnologies.us`
- **Then modify response header**:
  - **Operation**: Set static
  - **Header name**: `Content-Security-Policy`
  - **Value**: `default-src 'self' 'unsafe-inline' 'unsafe-eval' data: blob:; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline';`

## ⚡ **Quick Fix Alternative:**

If the above seems complex, try this simpler approach:

1. **Pause Cloudflare** temporarily:
   - Go to **Overview** tab
   - Click **"Pause Cloudflare on Site"**
   - Test OpenEMR functionality
   - Re-enable when ready

2. **Development Mode**:
   - Go to **Caching** → **Configuration**
   - Enable **"Development Mode"** (3 hours)
   - This bypasses most security restrictions

## 🎯 **Expected Result:**
After applying these changes:
- ✅ CSP warnings will disappear
- ✅ All JavaScript will load properly
- ✅ OpenEMR functionality fully restored
- ✅ Maintains reasonable security

## 🔒 **Security Note:**
These changes make the site slightly less secure but are necessary for OpenEMR's complex JavaScript requirements. This is normal for medical applications.