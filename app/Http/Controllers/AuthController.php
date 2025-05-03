<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Kreait\Firebase\Factory;
use Illuminate\Support\Facades\Log;

class AuthController extends Controller
{


    private function createFirebaseAuth()
    {
        $serviceAccount = [
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
        ];
    
        return (new Factory)
            ->withServiceAccount($serviceAccount)
            ->createAuth();
    }
    
    
    public function verifyGoogleEmail(Request $request)
    {
        
        $request->validate(['token' => 'required']);
    
        try {
            $firebase = $this->createFirebaseAuth(); // 🔥 initialize Firebase Auth
            $verifiedToken = $firebase->verifyIdToken($request->token);
    
            Log::info('✅ Token Claims:', $verifiedToken->claims()->all());
    
            $email = $verifiedToken->claims()->get('email');
            $name = $verifiedToken->claims()->get('name');
    
            if (!$email) {
                throw new \Exception('No email found in token claims.');
            }
    
            return response()->json(['email' => $email, 'name' => $name], 200);
        } catch (\Throwable $e) {
            Log::error('Google Email Verification Error: ' . $e->getMessage());
            return response()->json(['error' => 'Invalid Google token'], 400);
        }
    }



    public function googleLogin(Request $request)
    {
        $request->validate(['token' => 'required']);

        try {
            $firebase = $this->createFirebaseAuth(); // 🔥 USE THIS
            $verifiedToken = $firebase->verifyIdToken($request->token);

            $email = $verifiedToken->claims()->get('email');
            $name = $verifiedToken->claims()->get('name');

            if (!$email) {
                throw new \Exception('No email found in token claims.');
            }

            DB::table('guest_user')->updateOrInsert(
                ['user_email' => $email],
                ['name' => $name, 'password' => bcrypt('default_password'), 'visit_count' => DB::raw('visit_count + 1')]
            );

            $user = User::firstOrCreate(
                ['email' => $email],
                ['name' => $name, 'password' => bcrypt('default_password')]
            );

            $token = $user->createToken('GoogleLogin')->plainTextToken;

            return response()->json(['access_token' => $token, 'email' => $email], 200);
        } catch (\Throwable $e) {
            Log::error('Google Login Error: ' . $e->getMessage());
            return response()->json(['error' => 'Invalid Google token'], 400);
        }
    }
    // Validate token and differentiate between roles
    public function validateToken(Request $request)
    {
        $user = Auth::guard('sanctum')->user();
        
        if (!$user) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }
    
        if ($user->role === 'admin' || $user->role === 'tenant') {
            return response()->json(['role' => $user->role], 200);
        }
    
        // Handle guest user logic if necessary
        $guestUser = DB::table('guest_user')->where('user_email', $user->email)->first();
        
        if ($guestUser) {
            return response()->json(['role' => 'guest_user'], 200);
        }
    
        return response()->json(['error' => 'Invalid user type'], 403);
    }
    
    

    // Refresh Token Endpoint
    public function refreshToken(Request $request)
    {
        $user = Auth::guard('sanctum')->user();
        if (!$user) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }
    
        // Revoke the old token
        $user->tokens()->delete();
    
        // Create a new token
        $newToken = $user->createToken('API Token', ['admin-tenant'])->plainTextToken;
    
        return response()->json(['access_token' => $newToken], 200);
    }
    



// Login for admin/tenant
public function login(Request $request)
{
    $request->validate([
        'email' => 'required|email',
        'password' => 'required|string|min:4',
    ]);

    // Find the user by email
    $user = User::where('email', $request->email)->first();

    // Check if user exists and passwords match
    if (!$user || !Hash::check($request->password, $user->password)) {
        return response()->json(['error' => 'Invalid credentials'], 401);
    }

    // Check if the user is terminated
    if ($user->status === 'terminated') {
        return response()->json(['error' => 'Your account has been terminated. Please contact the administrator.'], 403);
    }

    // Generate a new token for the user
    $token = $user->createToken('API Token', ['admin-tenant'])->plainTextToken;

    return response()->json([
        'access_token' => $token,
        'role' => $user->role,
        'user_id' => $user->id,
        'status' => $user->status,
    ]);
}

    // Register for guests
    public function registerGuest(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:guest_user,user_email',
            'password' => 'required|string|min:4',
            'date_of_birth' => 'required|date',
            'gender' => 'required|in:Male,Female,Other',
        ]);

        try {
            $guestId = DB::table('guest_user')->insertGetId([
                'name' => $request->name,
                'user_email' => $request->email,
                'password' => bcrypt($request->password),
                'date_of_birth' => $request->date_of_birth,
                'gender' => $request->gender,
                'visit_count' => 0,
            ]);

            $user = User::firstOrCreate(
                ['email' => $request->email],
                ['name' => $request->name, 'password' => bcrypt($request->password)]
            );

            $token = $user->createToken('API Token', ['guest'])->plainTextToken;

            return response()->json([
                'success' => true,
                'message' => 'Account created and authenticated successfully.',
                'access_token' => $token,
            ], 201);
        } catch (\Exception $e) {
            Log::error('Register Guest Error: ' . $e->getMessage());
            return response()->json(['error' => 'Failed to create account.'], 500);
        }
    }

    // Guest login
    public function loginGuest(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|string|min:4',
        ]);

        $user = DB::table('guest_user')->where('user_email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json(['error' => 'Invalid credentials'], 401);
        }

        $userModel = User::firstOrCreate(
            ['email' => $request->email],
            ['name' => $user->name, 'password' => bcrypt($request->password)]
        );

        $token = $userModel->createToken('API Token', ['guest'])->plainTextToken;

        return response()->json(['access_token' => $token, 'user_email' => $user->user_email], 200);
    }

    public function logout(Request $request)
    {
        $user = Auth::guard('sanctum')->user();
        if ($user) {
            $user->tokens()->delete();
        }
        return response()->json(['message' => 'Logged out successfully'], 200);
    }
}
