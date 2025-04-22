<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Hash;
use App\Models\Application;
use App\Models\User;
use App\Models\Unit;
use App\Events\NewApplicationSubmitted;
use App\Events\NewAdminNotificationEvent;
use CloudinaryLabs\CloudinaryLaravel\Facades\Cloudinary;
class ApplicationController extends Controller
{
    // Fetch all pending applications
    public function index()
    {
        $applications = Application::select(
            'id', 'first_name', 'middle_name', 'last_name', 'email',
            'contact_number', 'check_in_date', 'duration', 'reservation_details',
            'valid_id', 'status', 'stay_type', 'set_price'
        )
        ->where('status', 'pending')
        ->get();
    
        $units = Unit::select(
            'id', 'unit_code', 'capacity', 'max_capacity', 'occupancy',
            'price', 'stay_type', 'status'
        )
        ->withCount(['users as total_users_count'])
        ->get();
    
        // Preload user counts by stay_type and unit_id
        $stayTypeCounts = User::selectRaw('unit_id, stay_type, COUNT(*) as count')
            ->join('units', 'users.unit_id', '=', 'units.id')
            ->groupBy('unit_id', 'stay_type')
            ->get()
            ->keyBy(fn($row) => $row->unit_id . '_' . strtolower($row->stay_type));
    
        // Inject into each unit
        foreach ($units as $unit) {
            $key = $unit->id . '_' . strtolower($unit->stay_type);
            $unit->same_staytype_users_count = $stayTypeCounts[$key]->count ?? 0;
        }
    
        return response()->json([
            'applications' => $applications,
            'units' => $units,
        ]);
    }
// Fetch only applications
public function applicationsOnly()
{
    \Log::info('✅ applicationsOnly route hit');

    $applications = Application::select(
        'id', 'first_name', 'middle_name', 'last_name', 'email',
        'contact_number', 'check_in_date', 'duration', 'reservation_details',
        'valid_id', 'status', 'stay_type', 'set_price'
    )
    ->where('status', 'pending')
    ->get();

    return response()->json(['applications' => $applications]);
}

// Fetch only units with counts (optimized)
public function unitsOnly()
{
    $units = Unit::select(
        'id', 'unit_code', 'capacity', 'max_capacity', 'occupancy',
        'price', 'stay_type', 'status'
    )
    ->withCount(['users as total_users_count'])
    ->get();

    // Preload counts by stay_type and unit_id
    $stayTypeCounts = User::selectRaw('unit_id, stay_type, COUNT(*) as count')
        ->join('units', 'users.unit_id', '=', 'units.id')
        ->groupBy('unit_id', 'stay_type')
        ->get()
        ->keyBy(fn($row) => $row->unit_id . '_' . strtolower($row->stay_type));

    foreach ($units as $unit) {
        $key = $unit->id . '_' . strtolower($unit->stay_type);
        $unit->same_staytype_users_count = $stayTypeCounts[$key]->count ?? 0;
    }

    return response()->json(['units' => $units]);
}

    public function getUnits()
    {
        try {
            $units = Unit::select('id', 'name', 'unit_code', 'capacity', 'price', 'status')
                         ->withCount(['users as total_users_count']) // 👈 this is the key
                         ->get();
    
            return response()->json($units);
        } catch (\Exception $e) {
            \Log::error('Error fetching units: ' . $e->getMessage());
            return response()->json(['error' => 'Failed to fetch units'], 500);
        }
    }
    

    // Save a new application
    public function store(Request $request)
    {
        \Log::info('Store method triggered', $request->all());
        // Validate incoming request
        $validated = $request->validate([
            'first_name' => 'required|string|max:100',
            'last_name' => 'required|string|max:100',
            'middle_name' => 'nullable|string|max:100',
            'email' => 'required|email|unique:applications,email',
            'birthdate' => 'required|date|before:today',
            'facebook_profile' => 'nullable|url|max:255',
            'contact_number' => 'required|string|max:20',
            'occupation' => 'required|string|max:100',
            'check_in_date' => 'required|date',
            'duration' => 'required|integer',
            'set_price' => 'nullable|numeric',
            'stay_type' => 'required|in:daily,weekly,half-month,monthly',
            'reservation_details' => 'required|string',
            'id_type' => 'required|string',
            'valid_id_url' => 'required|string|url',
            'house_number' => 'required|string|max:50',
            'street' => 'required|string|max:100',
            'barangay' => 'required|string|max:100', // Make sure it's expecting a name, not a code
            'city' => 'required|string|max:100', // Ensure it's a name
            'province' => 'required|string|max:100', // Ensure it's a name
            'zip_code' => 'required|string|max:4',
        ]);    
    
        // Handle file upload
        $validIdPath = $validated['valid_id_url'];
        // Check if user has already applied
        $existingApplication = Application::where('email', $validated['email'])->first();

        if ($existingApplication) {
            return response()->json([
                'message' => 'You have already submitted an application.',
            ], 409);
        }

        // Fetch the unit_id and set_price from the units table using reservation_details (unit_code)
        $unit = Unit::where('unit_code', $validated['reservation_details'])->first();
    
        if (!$unit) {
            return response()->json(['message' => 'Unit code not found.'], 400);
        }
    
        // Auto-set status and set_price based on unit
        $status = 'pending'; // Default status for new applications

        $tenantCount = User::where('unit_id', $unit->id)->count() + 1; // +1 to include current applicant

    // Fallback to unit price if set_price is not provided from the frontend
    $setPrice = $validated['set_price'] ?? null;

    if (empty($setPrice)) {
        // Calculate price based on the stay type
        if ($validated['stay_type'] === 'weekly') {
            // Apply logic for weekly price
            $setPrice = $unit->price;  // You may apply your own formula for weekly price calculation
        } elseif ($validated['stay_type'] === 'monthly') {
            // Apply logic for monthly price
            $setPrice = $unit->price;  // Use the unit price for monthly
        } elseif ($validated['stay_type'] === 'half-month') {
            // Apply logic for half-month price
            $setPrice = $unit->price * 0.5;
        } else {
            $setPrice = $unit->price;  // Default price if stay type isn't specified
        }
    }
        // Create the application
        $application = Application::create([
            'first_name' => $validated['first_name'],
            'last_name' => $validated['last_name'],
            'middle_name' => $validated['middle_name'],
            'email' => $validated['email'],
            'birthdate' => $validated['birthdate'],
            'facebook_profile' => $validated['facebook_profile'],
            'contact_number' => $validated['contact_number'],
            'occupation' => $validated['occupation'],
            'check_in_date' => $validated['check_in_date'],
            'duration' => $validated['duration'],
            'reservation_details' => $validated['reservation_details'], // Store unit_code
            'unit_id' => $unit->id, // Save unit_id
            'id_type' => $validated['id_type'],
            'valid_id' => $validIdPath,
            'status' => $status,
            'stay_type' => $validated['stay_type'],
            'set_price' => $setPrice,
            'house_number' => $validated['house_number'],
            'street' => $validated['street'],
            'barangay' => $validated['barangay'], // ✅ Store the Barangay Name
            'city' => $validated['city'], // ✅ Store the City/Municipality Name
            'province' => $validated['province'], // ✅ Store the Province Name
            'zip_code' => $validated['zip_code'],
        ]);

        // ✅ Fire event AFTER the application is created
        event(new NewApplicationSubmitted($application));
        // 🔔 Fire notification to admin
        event(new NewAdminNotificationEvent(
            "📄 New application submitted by {$application->first_name} {$application->last_name}.",
            'tenant_update'
        ));
        return response()->json(['message' => 'Application submitted successfully!', 'application' => $application], 201);
    }
    
// Accept an application
public function accept(Request $request, $id)
{
    \Log::info('🟢 POST /accept route hit!', [
        'method' => $request->method(),
        'data' => $request->all(),
    ]);
    try {
        \Log::info('Accept Method Triggered', ['application_id' => $id, 'request_data' => $request->all()]);

        // Find the application
        $application = Application::findOrFail($id);

        // Retrieve the unit_code from reservation_details
        $unitCode = $application->reservation_details;

        // Fetch the unit_id based on the unit_code
        $unit = Unit::where('unit_code', $unitCode)->first();

        if (!$unit) {
            \Log::error('Unit Not Found', ['unit_code' => $unitCode]);
            return response()->json(['message' => 'Unit code not found for the selected unit.'], 400);
        }

        \Log::info('Unit Found', ['unit_id' => $unit->id, 'unit_code' => $unitCode]);

        // Check if a user with this email already exists
        $existingUser = User::where('email', $application->email)->first();
        if ($existingUser) {
            \Log::error('User Already Exists', ['email' => $application->email]);
            return response()->json(['message' => 'A user with this email already exists.'], 409);
        }

        // Generate random credentials
        $password = substr(md5(time()), 0, 8);

        // Explicitly cast unit_id to ensure it's passed correctly
        $unitId = (int) $unit->id;

        // Determine rent price for billing (set_price > 0 ? use it : use unit->price)
        $finalRentPrice = ($application->set_price && $application->set_price > 0)
            ? $application->set_price
            : $unit->price;
        // Create a new tenant account in the users table
        $user = User::create([
            'name' => $application->first_name . ' ' . $application->last_name,
            'email' => $application->email,
            'password' => Hash::make($password),
            'unit_id' => $unitId,
            'role' => 'tenant',
            'rent_price' => $finalRentPrice,
        ]);

        \Log::info('User Created', ['user_id' => $user->id, 'unit_id' => $user->unit_id]);

        // Update the application's status to 'Accepted' and assign the unit_id
        $application->status = 'Accepted';
        $application->unit_id = $unitId;
        $application->save();
        // 🔔 Fire notification to admin
        event(new NewAdminNotificationEvent(
            "✅ Application for {$application->first_name} {$application->last_name} has been accepted. A tenant account was created.",
            'tenant_update'
        ));
        \Log::info('Application Updated', ['application_id' => $application->id, 'unit_id' => $application->unit_id]);

        // ✅ Send credentials to the tenant via email using Mailjet
        Mail::raw("Dear {$application->first_name} {$application->last_name},\n\nYour tenant account has been successfully created.\n\nLogin Details:\nUsername: {$application->email}\nPassword: {$password}\n\nYou can now access your account.\n\nThank you!", 
            function ($message) use ($application) {
                $message->to($application->email)
                        ->subject('Your Tenant Account Details - Seagold Dormitory');
            }
        );

        \Log::info('Email Sent Successfully', ['email' => $application->email]);

        return response()->json(['message' => 'Tenant account created successfully, and unit assigned.']);

    } catch (\Exception $e) {
        \Log::error('Error accepting application', ['error' => $e->getMessage()]);
        return response()->json([
            'message' => 'An error occurred while accepting the application.',
            'error' => $e->getMessage(),
        ], 500);
    }
}

public function update(Request $request, $id)
{
    $application = Application::findOrFail($id);

    // Update fields from formData
    $application->duration = $request->duration;
    $application->reservation_details = $request->reservation_details;
    $application->set_price = $request->set_price;

    $application->save();

    return response()->json(['message' => 'Application updated successfully.']);
}


}
