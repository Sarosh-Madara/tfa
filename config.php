<?php

/* ============================================================
 |  APPLICATION
 * ============================================================ */

define('APP_ENV', 'development');
define('APP_URL', 'https://dev-agreement-dashboard.example.com');
define('APP_DEBUG', true);
define('APP_TIMEZONE', 'UTC');


/* ============================================================
 |  DATABASE (AWS RDS MySQL 8.0)
 * ============================================================ */

define('DB_CONNECTION', 'mysql');
define('DB_HOST', '<RDS-ENDPOINT>');
define('DB_PORT', 3306);
define('DB_DATABASE', 'agreement_db');
define('DB_USERNAME', '<DB-USER>');
define('DB_PASSWORD', '<DB-PASSWORD>');
define('DB_CHARSET', 'utf8mb4');


/* ============================================================
 |  REDIS
 * ============================================================ */

define('REDIS_HOST', 'redis');
define('REDIS_PORT', 6379);
define('REDIS_PASSWORD', null);
define('REDIS_DB', 0);


/* ============================================================
 |  RABBITMQ
 * ============================================================ */

define('RABBITMQ_HOST', 'rabbitmq');
define('RABBITMQ_PORT', 5672);
define('RABBITMQ_USER', '<RABBIT_USER>');
define('RABBITMQ_PASSWORD', '<RABBIT_PASSWORD>');
define('RABBITMQ_VHOST', '/');


/* ============================================================
 |  SOKETI / WEBSOCKETS
 * ============================================================ */

define('SOKETI_HOST', 'soketi');
define('SOKETI_PORT', 6001);
define('SOKETI_APP_ID', '<APP_ID>');
define('SOKETI_APP_KEY', '<APP_KEY>');
define('SOKETI_APP_SECRET', '<APP_SECRET>');


/* ============================================================
 |  PYTHON WORKER (AI / OCR)
 * ============================================================ */

define('AI_OCR_ENABLED', true);
define('AI_OCR_CPU', 4);
define('AI_OCR_RAM', 4096);


/* ============================================================
 |  GOOGLE CLOUD SERVICES
 * ============================================================ */

define('GOOGLE_OAUTH_CLIENT_ID', '<CLIENT_ID>');
define('GOOGLE_OAUTH_CLIENT_SECRET', '<CLIENT_SECRET>');
define('GOOGLE_REDIRECT_URI', APP_URL . '/auth/google/callback');

define('GOOGLE_VISION_ENABLED', true);
define('GOOGLE_VISION_SERVICE_ACCOUNT', 'backend/storage/credentials/service-account.json');

define('GOOGLE_GEMINI_API_KEY_PRIMARY', '<API_KEY_1>');
define('GOOGLE_GEMINI_API_KEY_FALLBACK', '<API_KEY_2>');

define('GOOGLE_DRIVE_ENABLED', false);    // optional
define('GOOGLE_CALENDAR_ENABLED', false); // optional


/* ============================================================
 |  FILE UPLOAD RULES
 * ============================================================ */

define('UPLOAD_MAX_SIZE_MB', 20);
define('UPLOAD_ALLOWED_TYPES', 'pdf');


/* ============================================================
 |  SECURITY & RATE LIMITS
 * ============================================================ */

define('RATE_LIMIT_LOGIN', 10)
