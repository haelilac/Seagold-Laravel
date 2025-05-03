<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Kreait\Firebase\Factory;
use Illuminate\Support\Facades\Log;

class GoogleVerifyEmailController extends Controller
{
    protected $auth;

    public function __construct()
    {
        try {
            Log::info('[Firebase] Initializing service account...');

            $firebase = (new Factory)->withServiceAccount([
                'type' => env('FIREBASE_TYPE'),
                'project_id' => env('FIREBASE_PROJECT_ID'),
                'private_key_id' => env('FIREBASE_PRIVATE_KEY_ID'),
                'private_key' => str_replace("\\n", "\n", env('FIREBASE_PRIVATE_KEY')),
                'client_email' => env('FIREBASE_CLIENT_EMAIL'),
                'client_id' => env('FIREBASE_CLIENT_ID'),
                'auth_uri' => env('FIREBASE_AUTH_URI'),
                'token_uri' => env('FIREBASE_TOKEN_URI'),
                'auth_provider_x509_cert_url' => env('FIREBASE_AUTH_PROVIDER_X509_CERT_URL'),
                'client_x509_cert_url' => env('FIREBASE_CLIENT_X509_CERT_URL'),
            ]);

            $this->auth = $firebase->createAuth();

            Log::info('[Firebase] Firebase Auth initialized successfully.');
        } catch (\Throwable $e) {
            Log::error('[Firebase] Initialization error: ' . $e->getMessage());
            $this->auth = null;
        }
    }

    public function verify(Request $request)
    {
        Log::info('[Verify] Incoming request.', $request->all());

        $token = $request->input('token'); // ✅ Only grab token
        $provider = $request->input('provider'); // ✅ (Optional, safe to have)

        if (!$token) {
            Log::warning('[Verify] No token provided.');
            return response()->json(['error' => 'Token missing.'], 400);
        }

        if (!$this->auth) {
            Log::error('[Verify] Firebase Auth service not initialized.');
            return response()->json(['error' => 'Auth service not ready.'], 500);
        }

        try {
            Log::info('[Verify] Verifying token...');
            $verifiedIdToken = $this->auth->verifyIdToken($token);

            $uid = $verifiedIdToken->claims()->get('sub');
            Log::info("[Verify] Token verified. UID: $uid");

            $firebaseUser = $this->auth->getUser($uid);
            Log::info("[Verify] Firebase user loaded: " . $firebaseUser->email);

            return response()->json([
                'email' => $firebaseUser->email,
                'name' => $firebaseUser->displayName,
                'uid' => $firebaseUser->uid,
                'provider' => $provider, // ✅ If you want to return the provider too
            ]);
        } catch (\Throwable $e) {
            Log::error('[Verify] Token verification error: ' . $e->getMessage());
            return response()->json(['error' => 'Token invalid or expired.'], 400);
        }
    }
}
