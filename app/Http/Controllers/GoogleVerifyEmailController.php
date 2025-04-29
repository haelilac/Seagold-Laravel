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
        $firebase = (new Factory)
            ->withServiceAccount(config('firebase.credentials'));

        $this->auth = $firebase->createAuth();
    }

    public function verify(Request $request)
    {
        $token = $request->input('token');

        if (!$token) {
            return response()->json(['error' => 'Token missing.'], 400);
        }

        try {
            $verifiedIdToken = $this->auth->verifyIdToken($token);
            $firebaseUser = $this->auth->getUser($verifiedIdToken->claims()->get('sub'));

            return response()->json([
                'email' => $firebaseUser->email,
                'name' => $firebaseUser->displayName,
                'uid' => $firebaseUser->uid,
            ]);
        } catch (\Throwable $e) {
            Log::error('Google token verification failed: ' . $e->getMessage());
            return response()->json(['error' => 'Invalid or expired token.'], 400);
        }
    }
}
