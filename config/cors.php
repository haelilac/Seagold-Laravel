<?php


return [
    'paths' => ['api/*', 'sanctum/csrf-cookie', 'login-admin-tenant', 'logout', 'upload-id'],

    'allowed_methods' => ['*'],

    'allowed_origins' => [
        'https://seagold-dormitory.vercel.app',
    ],

    'allowed_origins_patterns' => [],

    'allowed_headers' => ['*'],

    'exposed_headers' => ['Authorization', 'X-CSRF-TOKEN'],

    'max_age' => 0,

    'supports_credentials' => true,
];
