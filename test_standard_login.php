<?php
/* BEGIN AI-GENERATED CODE - GitHub Copilot assisted with OpenEMR login testing */
// Test the standard OpenEMR login process without modifications

// Include OpenEMR configuration
require_once(__DIR__ . '/sites/default/sqlconf.php');

echo "=== OpenEMR Standard Login Test ===\n";
echo "Testing database connection...\n";

// Test database connection
try {
    $dsn = "mysql:host={$host};port={$port};dbname={$dbase};charset={$db_encoding}";
    $pdo = new PDO($dsn, $login, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "✓ Database connection successful\n";
    
    // Check if users table exists and has data
    $stmt = $pdo->query("SHOW TABLES LIKE 'users'");
    if ($stmt->rowCount() > 0) {
        echo "✓ Users table exists\n";
        
        // Check for admin user
        $stmt = $pdo->prepare("SELECT id, username, active, password FROM users WHERE username = 'admin'");
        $stmt->execute();
        $user = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($user) {
            echo "✓ Admin user found (ID: {$user['id']}, Active: {$user['active']})\n";
            echo "✓ Password hash exists: " . (!empty($user['password']) ? "Yes" : "No") . "\n";
        } else {
            echo "✗ Admin user not found\n";
        }
        
        // Check users_secure table
        $stmt = $pdo->query("SHOW TABLES LIKE 'users_secure'");
        if ($stmt->rowCount() > 0) {
            $stmt = $pdo->prepare("SELECT id, password FROM users_secure WHERE id = ?");
            $stmt->execute([$user['id']]);
            $secure = $stmt->fetch(PDO::FETCH_ASSOC);
            if ($secure) {
                echo "✓ Admin user has users_secure entry\n";
                echo "✓ Secure password exists: " . (!empty($secure['password']) ? "Yes" : "No") . "\n";
            } else {
                echo "✗ Admin user missing users_secure entry\n";
            }
        }
    } else {
        echo "✗ Users table not found\n";
    }
    
} catch (Exception $e) {
    echo "✗ Database error: " . $e->getMessage() . "\n";
}

// Test if login page loads
echo "\nTesting login page access...\n";
$loginPath = __DIR__ . '/interface/login/login.php';
if (file_exists($loginPath)) {
    echo "✓ Login page file exists\n";
} else {
    echo "✗ Login page file missing\n";
}

// Test if globals.php loads
$globalsPath = __DIR__ . '/interface/globals.php';
if (file_exists($globalsPath)) {
    echo "✓ Globals file exists\n";
} else {
    echo "✗ Globals file missing\n";
}

// Test vendor autoload
$vendorPath = __DIR__ . '/vendor/autoload.php';
if (file_exists($vendorPath)) {
    echo "✓ Composer dependencies installed\n";
} else {
    echo "✗ Composer dependencies missing\n";
}

echo "\n=== Configuration Status ===\n";
echo "Config flag: $config\n";
echo "Host: $host\n";
echo "Database: $dbase\n";
echo "Username: $login\n";

// Test original OpenEMR password verification
echo "\n=== Password Verification Test ===\n";
if (isset($user) && $user) {
    // Test if we can verify the password 'pass' (original default)
    $testPasswords = ['pass', 'admin', 'Badger1234!'];
    foreach ($testPasswords as $testPass) {
        if (isset($user['password']) && !empty($user['password'])) {
            if (password_verify($testPass, $user['password'])) {
                echo "✓ Password '$testPass' works with users table\n";
            }
        }
        if (isset($secure['password']) && !empty($secure['password'])) {
            if (password_verify($testPass, $secure['password'])) {
                echo "✓ Password '$testPass' works with users_secure table\n";
            }
        }
    }
}
/* END AI-GENERATED CODE */
?>