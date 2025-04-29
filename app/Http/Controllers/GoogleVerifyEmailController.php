<?php

namespace App\Http\Controllers\Api;

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

            if (!file_exists(storage_path('app/firebase-service-account.json'))) {
                Log::error('[Firebase] Missing service account JSON!');
                throw new \Exception('Service account file is missing.');
            }

            $firebase = (new Factory)
                ->withServiceAccount(storage_path('app/firebase-service-account.json'));

            $this->auth = $firebase->createAuth();

            Log::info('[Firebase] Firebase Auth initialized successfully.');
        } catch (\Throwable $e) {
            Log::error('[Firebase] Initialization error: ' . $e->getMessage());
            $this->auth = null;
        }
    }

    public function verify(Request $request)
    {
        Log::info('[Verify] Incoming request to verify Google ID token.');

        $token = $request->input('token');

        if (!$token) {
            Log::warning('[Verify] No token provided in request.');
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
            ]);
        } catch (\Throwable $e) {
            Log::error('[Verify] Token verification error: ' . $e->getMessage());
            return response()->json(['error' => 'Token invalid or expired.'], 400);
        }
    }
}
