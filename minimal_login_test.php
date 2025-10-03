<?php
/* BEGIN AI-GENERATED CODE - GitHub Copilot assisted with minimal login testing */
// Minimal test to see what happens during standard OpenEMR login

error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "=== Testing Standard OpenEMR Login Process ===\n";

// Test if we can include the basic OpenEMR files
try {
    // Test vendor autoload first
    if (file_exists(__DIR__ . '/vendor/autoload.php')) {
        require_once(__DIR__ . '/vendor/autoload.php');
        echo "✓ Autoloader included\n";
    }
    
    // Test globals loading (what login.php does)
    echo "Testing globals.php inclusion...\n";
    
    // Start output buffering to catch any errors
    ob_start();
    $error = null;
    
    try {
        require_once(__DIR__ . '/interface/globals.php');
        echo "✓ Globals loaded successfully\n";
        
        // Test if GLOBALS are set properly
        if (isset($GLOBALS['site_id'])) {
            echo "✓ Site ID set: " . $GLOBALS['site_id'] . "\n";
        } else {
            echo "⚠ Site ID not set\n";
        }
        
        // Test session
        if (session_status() === PHP_SESSION_ACTIVE) {
            echo "✓ Session is active\n";
        } else {
            echo "⚠ Session not active\n";
        }
        
    } catch (Exception $e) {
        $error = $e->getMessage();
    } catch (Error $e) {
        $error = $e->getMessage();
    }
    
    $output = ob_get_clean();
    
    if ($error) {
        echo "✗ Error loading globals: $error\n";
    } else {
        echo "✓ No fatal errors during globals loading\n";
    }
    
    if ($output) {
        echo "Output during loading:\n$output\n";
    }
    
} catch (Exception $e) {
    echo "✗ Critical error: " . $e->getMessage() . "\n";
}

echo "\n=== Testing Login Form Access ===\n";

// Check if we can determine why login might fail
if (file_exists(__DIR__ . '/interface/login/login.php')) {
    echo "Login page exists. Checking for common issues...\n";
    
    // Read first few lines of login.php to see if there are any obvious issues
    $loginContent = file_get_contents(__DIR__ . '/interface/login/login.php', false, null, 0, 1000);
    
    if (strpos($loginContent, 'require_once') !== false) {
        echo "✓ Login page has proper includes\n";
    }
    
    if (strpos($loginContent, 'session_start') !== false || strpos($loginContent, 'globals.php') !== false) {
        echo "✓ Login page handles sessions\n";
    }
}

echo "\n=== Recommendation ===\n";
echo "Standard login should work with:\n";
echo "URL: /interface/login/login.php?site=default\n";
echo "Username: admin\n";
echo "Password: pass\n";
/* END AI-GENERATED CODE */
?>