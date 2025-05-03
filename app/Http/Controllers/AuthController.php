<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Kreait\Firebase\Auth as FirebaseAuth;

class AuthController extends Controller
{
    protected $firebase;

    public function __construct(FirebaseAuth $firebase)
    {
        $this->firebase = $firebase;
    }

    public function verifyGoogleEmail(Request $request)
    {
        $request->validate(['token' => 'required']);

        try {
            $verifiedToken = $this->firebase->verifyIdToken($request->token);
            Log::info('✅ Token Claims:', $verifiedToken->claims()->all());

            $email = $verifiedToken->claims()->get('email');
            $name = $verifiedToken->claims()->get('name');

            if (!$email) {
                Log::error('❌ No email found in token claims.');
                throw new \Exception('No email found in token claims.');
            }

            Log::info("✅ Google Email Verified: $email");
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
            $verifiedToken = $this->firebase->verifyIdToken($request->token);
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

    public function validateToken(Request $request)
    {
        $user = Auth::guard('sanctum')->user();
        if (!$user) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        if (in_array($user->role, ['admin', 'tenant'])) {
            return response()->json(['role' => $user->role], 200);
        }

        $guestUser = DB::table('guest_user')->where('user_email', $user->email)->first();
        if ($guestUser) {
            return response()->json(['role' => 'guest_user'], 200);
        }

        return response()->json(['error' => 'Invalid user type'], 403);
    }

    public function refreshToken(Request $request)
    {
        $user = Auth::guard('sanctum')->user();
        if (!$user) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        $user->tokens()->delete();
        $newToken = $user->createToken('API Token', ['admin-tenant'])->plainTextToken;

        return response()->json(['access_token' => $newToken], 200);
    }

    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|string|min:4',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            return response()->json(['error' => 'Invalid credentials'], 401);
        }

        if ($user->status === 'terminated') {
            return response()->json(['error' => 'Your account has been terminated.'], 403);
        }

        $token = $user->createToken('API Token', ['admin-tenant'])->plainTextToken;

        return response()->json([
            'access_token' => $token,
            'role' => $user->role,
            'user_id' => $user->id,
            'status' => $user->status,
        ]);
    }

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
            DB::table('guest_user')->insert([
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

    public function loginGuest(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|string|min:4',
        ]);

        $guest = DB::table('guest_user')->where('user_email', $request->email)->first();

        if (!$guest || !Hash::check($request->password, $guest->password)) {
            return response()->json(['error' => 'Invalid credentials'], 401);
        }

        $user = User::firstOrCreate(
            ['email' => $request->email],
            ['name' => $guest->name, 'password' => bcrypt($request->password)]
        );

        $token = $user->createToken('API Token', ['guest'])->plainTextToken;

        return response()->json(['access_token' => $token, 'user_email' => $guest->user_email], 200);
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
