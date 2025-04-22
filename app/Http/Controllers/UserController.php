<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use CloudinaryLabs\CloudinaryLaravel\Facades\Cloudinary;
use Illuminate\Support\Facades\Hash;
class UserController extends Controller
{


public function uploadProfile(Request $request)
{
    $request->validate([
        'profile' => 'required|image|mimes:jpeg,png,jpg|max:2048',
    ]);

    $user = auth()->user(); // works for tenant or admin

    $uploadedFileUrl = Cloudinary::upload($request->file('profile')->getRealPath(), [
        'folder' => 'profile_pictures',
        'public_id' => 'user_' . $user->id,
        'overwrite' => true,
    ])->getSecurePath();

    $user->profile_picture = $uploadedFileUrl;
    $user->save();

    return response()->json([
        'message' => 'Profile picture updated successfully.',
        'image_url' => $uploadedFileUrl,
    ]);
}

    public function index()
    {
        // Fetch users with the 'tenant' role
        $tenants = User::where('role', 'tenant')->get();

        return response()->json($tenants);
    }

    public function changePassword(Request $request)
    {
        try {
            $user = auth()->user();
    
            \Log::info('Password Change Request:', $request->all());
    
            $request->validate([
                'current_password' => 'required',
                'new_password' => 'required|min:8',
                'new_password_confirmation' => 'required|same:new_password',
            ]);
    
            if (!Hash::check($request->current_password, $user->password)) {
                return response()->json(['message' => 'Current password is incorrect.'], 403);
            }
    
            \Log::info('Before password update:', ['user' => $user->id]);
            $user->password = bcrypt($request->new_password);
            $user->save();
            \Log::info('After password update:', ['user' => $user->id]);
            return response()->json(['message' => 'Password updated successfully.']);
    
        } catch (\Exception $e) {
            \Log::error('Change Password Error: ' . $e->getMessage());
            return response()->json(['message' => 'Server error. Please try again.'], 500);
        }
    }
}    
