<?php
/* Simple test page to verify OpenEMR is working */
echo "<h1>OpenEMR Login Test</h1>";
echo "<p><strong>Server Status:</strong> ✅ PHP Server Running</p>";
echo "<p><strong>Time:</strong> " . date('Y-m-d H:i:s') . "</p>";

// Test database connection
try {
    require_once(__DIR__ . '/sites/default/sqlconf.php');
    $pdo = new PDO("mysql:host={$host};port={$port};dbname={$dbase}", $login, $pass);
    echo "<p><strong>Database:</strong> ✅ Connected</p>";
} catch (Exception $e) {
    echo "<p><strong>Database:</strong> ❌ Error: " . $e->getMessage() . "</p>";
}

echo "<hr>";
echo "<h2>🔐 Standard OpenEMR Login</h2>";
echo "<p><a href='/interface/login/login.php?site=default' style='font-size: 18px; color: blue;'>➡️ Click Here to Access OpenEMR Login</a></p>";

echo "<h3>Login Credentials:</h3>";
echo "<ul>";
echo "<li><strong>Username:</strong> admin</li>";
echo "<li><strong>Password:</strong> pass</li>";
echo "</ul>";

echo "<h3>URLs for Manual Access:</h3>";
echo "<ul>";
echo "<li><strong>Local:</strong> http://127.0.0.1:8080/interface/login/login.php?site=default</li>";
echo "<li><strong>Remote:</strong> https://ddns.badgertechnologies.us/interface/login/login.php?site=default</li>";
echo "</ul>";
?>