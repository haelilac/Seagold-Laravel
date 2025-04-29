<?php

namespace App\Services;

use Kreait\Firebase\Factory;
use Kreait\Firebase\Auth;

class FirebaseService
{
    protected $auth;

    public function __construct()
    {
        $this->auth = (new Factory)
            ->withServiceAccount(config('firebase.firebase_credentials')) // Loads from config
            ->createAuth();
    }

    public function auth(): Auth
    {
        return $this->auth;
    }
}
