<?php

return [

    'paths' => ['api/*', 'sanctum/csrf-cookie', '/login-admin-tenant', '/logout'],

    'allowed_methods' => ['*'],

    'allowed_origins' => [
        'https://seagold-dormitory.vercel.app',
        'http://localhost:3000',
        'http://127.0.0.1:3000'
    ],

    'allowed_origins_patterns' => [],

    'allowed_headers' => ['Content-Type', 'X-Requested-With', 'X-CSRF-TOKEN', 'Authorization', 'Accept'],

    'exposed_headers' => ['*'],

    'max_age' => 0,

    'supports_credentials' => true,
];
