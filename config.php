<?php

// --- Database Configuration ---
// The database type (e.g., 'mysql', 'pgsql')
define('DB_TYPE', 'mysql');

// Database host (usually 'localhost' or an IP address)
define('DB_HOST', 'localhost');

// Database name
define('DB_NAME', 'my_application_db');

// Database username
define('DB_USER', 'db_user');

// Database password
define('DB_PASS', 'secure_password_123');


// --- Application Configuration ---
// Site name for titles/headers
define('SITE_NAME', 'My Awesome PHP App');

// Base URL (important for assets and links)
// e.g., 'http://localhost/myapp/' or 'https://www.mysite.com/'
define('BASE_URL', 'http://localhost/');

// Flag for development/production mode
// Set to true during development to show detailed errors
define('DEVELOPMENT_MODE', true);

// Set error reporting based on mode
if (DEVELOPMENT_MODE) {
    error_reporting(E_ALL);
    ini_set('display_errors', 1);
} else {
    error_reporting(0);
    ini_set('display_errors', 0);
}

// Set default timezone to avoid PHP warnings
date_default_timezone_set('UTC');

?>
