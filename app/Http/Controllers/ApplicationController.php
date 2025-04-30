<?php

namespace App\Http\Controllers;
use Illuminate\Support\Facades\Http; 
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
    
        // Preload counts by stay_type and unit_id
        $stayTypeCounts = User::selectRaw('unit_id, stay_type, COUNT(*) as count')
            ->groupBy('unit_id', 'stay_type')
            ->get()
            ->keyBy(fn($row) => $row->unit_id . '_' . strtolower($row->stay_type));

        // Then, inject into each unit:
        foreach ($units as $unit) {
            $key = $unit->id . '_' . strtolower($unit->stay_type ?? '');
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
        'price', 'stay_type', 'status' // 🔥 Correct field 'stay_types' not 'stay_type'
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
        $key = $unit->id . '_' . strtolower($unit->stay_type ?? '');
        $unit->same_staytype_users_count = $stayTypeCounts[$key]->count ?? 0;
    }

    return response()->json(['units' => $units]);
}


    public function getUnits()
    {
        try {
            $units = Unit::select('id', 'name', 'unit_code', 'stay_type', 'capacity', 'price', 'status')
            ->withCount(['users as total_users_count'])
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
        try {
            \Log::info('Store method triggered', $request->all());
    
            // Validate inputs (this still works for FormData)
            $request->validate([
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
                'reservation_fee' => 'required|numeric',
                'receipt_url' => 'required|string|url',
                'reference_number' => 'required|string',
                'payment_amount' => 'required|numeric',
                'reservation_details' => 'required|string',
                'id_type' => 'required|string',
                'valid_id_url' => 'required|string|url', // This should be the field used for valid ID image URL
                'valid_id' => 'nullable|string|url', // Optional if valid_id_url is used
                'house_number' => 'required|string|max:50',
                'street' => 'required|string|max:100',
                'barangay' => 'required|string|max:100',
                'city' => 'required|string|max:100',
                'province' => 'required|string|max:100',
                'zip_code' => 'required|string|max:4',
            ]);
    
            // Avoid duplicate applications
            if (Application::where('email', $request->input('email'))->exists()) {
                return response()->json([
                    'message' => 'You have already submitted an application.',
                ], 409);
            }
    
            // Resolve unit from reservation_details
            $unit = Unit::where('unit_code', $request->input('reservation_details'))->first();
            if (!$unit) {
                return response()->json(['message' => 'Unit code not found.'], 400);
            }
    
            // Determine pricing
            $setPrice = $request->input('set_price');
            if (empty($setPrice)) {
                $stayType = $request->input('stay_type');
                if ($stayType === 'half-month') {
                    $setPrice = $unit->price * 0.5;
                } else {
                    $setPrice = $unit->price;
                }
            }
    
            // Use valid_id_url (valid ID URL) for valid_id
            $validIdUrl = $request->input('valid_id_url') ?: $request->input('valid_id');
    
            // Create application
            $application = Application::create([
                'first_name' => $request->input('first_name'),
                'last_name' => $request->input('last_name'),
                'middle_name' => $request->input('middle_name'),
                'email' => $request->input('email'),
                'birthdate' => $request->input('birthdate'),
                'facebook_profile' => $request->input('facebook_profile'),
                'contact_number' => $request->input('contact_number'),
                'occupation' => $request->input('occupation'),
                'check_in_date' => $request->input('check_in_date'),
                'duration' => $request->input('duration'),
                'reservation_details' => $request->input('reservation_details'),
                'unit_id' => $unit->id,
                'id_type' => $request->input('id_type'),
                'valid_id' => $validIdUrl, // Store the valid_id URL (either valid_id or valid_id_url)
                'status' => 'pending',
                'stay_type' => $request->input('stay_type'),
                'reference_number' => $request->input('reference_number'),
                'payment_amount' => $request->input('payment_amount'),
                'reservation_fee' => $request->input('reservation_fee'),
                'receipt_url' => $request->input('receipt_url'),
                'set_price' => $setPrice,
                'house_number' => $request->input('house_number'),
                'street' => $request->input('street'),
                'barangay' => $request->input('barangay'),
                'city' => $request->input('city'),
                'province' => $request->input('province'),
                'zip_code' => $request->input('zip_code'),
            ]);
    
            // Trigger events
            event(new NewApplicationSubmitted($application));
            event(new NewAdminNotificationEvent(
                "📄 New application submitted by {$application->first_name} {$application->last_name}.",
                'tenant_update'
            ));
    
            return response()->json([
                'message' => 'Application submitted successfully!',
                'application' => $application,
            ], 201);
    
        } catch (\Illuminate\Validation\ValidationException $e) {
            \Log::error('❌ Validation failed', ['errors' => $e->errors()]);
            return response()->json(['message' => 'Validation failed', 'errors' => $e->errors()], 422);
        } catch (\Exception $e) {
            \Log::error('❌ Application store error', ['exception' => $e->getMessage()]);
            return response()->json(['message' => 'Something went wrong.'], 500);
        }
    }
    
    
    public function storePaymentData(Request $request)
    {
        $validated = $request->validate([
            'application_id'   => 'required|exists:applications,id',
            'reference_number' => 'required|string',
            'amount'           => 'required|numeric',
        ]);
    
        $application = Application::find($validated['application_id']);
    
        $application->update([
            'reference_number' => $validated['reference_number'],
            'payment_amount'    => $validated['amount'],
            'payment_date'      => $validated['date_time'],
        ]);
    
        return response()->json(['message' => 'Payment data saved to application successfully!']);
    }
    

    public function validateReceipt(Request $request)
    {
        if (!$request->hasFile('receipt')) {
            \Log::warning('⚠️ No receipt file uploaded.', [
                'request' => $request->all()
            ]);
            return response()->json(['message' => 'No receipt file uploaded.'], 400);
        }
    
        $file = $request->file('receipt');
    
        try {
            $ocrApiUrl = app()->environment('local') 
                ? 'http://localhost:9090/validate-receipt/' 
                : 'https://seagold-python-production.up.railway.app/validate-receipt/';
    
            $ocrResponse = Http::attach(
                'receipt', // name expected by Python
                file_get_contents($file->getRealPath()),
                $file->getClientOriginalName()
            )->post($ocrApiUrl);
    
            \Log::info('📨 OCR API Called to validate receipt.');
        } catch (\Exception $e) {
            \Log::error('❌ OCR API Call Failed', ['error' => $e->getMessage()]);
            return response()->json(['message' => 'OCR service error.'], 500);
        }
    
        if ($ocrResponse->failed()) {
            \Log::error('❌ OCR Failed to Process Receipt', [
                'status' => $ocrResponse->status(),
                'body'   => $ocrResponse->body()
            ]);
            return response()->json(['message' => 'OCR failed to process the receipt.'], 500);
        }
    
        $ocrData = $ocrResponse->json();
    
        \Log::info('🔎 OCR Receipt Response', $ocrData);
    
        return response()->json([
            'match' => $ocrData['match'] ?? false,
            'ocr_data' => [
                'extracted_reference' => $ocrData['reference'] ?? null,
                'extracted_amount'    => $ocrData['amount'] ?? null,
                'receipt_url'         => $ocrData['receipt_url'] ?? null,
                'text'                => $ocrData['text'] ?? ''
            ],
        ]);
    }
    
    
    

// Accept an application
public function accept(Request $request, $id)
{
    \Log::info('🟢 POST /accept route hit!', [
        'method' => $request->method(),
        'data' => $request->all(),
    ]);
    
    try {
        \Log::info('Accept Method Triggered', ['application_id' => $id]);

        $application = Application::findOrFail($id);
        $unitCode = $application->reservation_details;
        $unit = Unit::where('unit_code', $unitCode)->first();

        if (!$unit) {
            \Log::error('Unit Not Found', ['unit_code' => $unitCode]);
            return response()->json(['message' => 'Unit code not found.'], 400);
        }

        // Check for existing user
        if (User::where('email', $application->email)->exists()) {
            return response()->json(['message' => 'User already exists.'], 409);
        }

        // Create user
        $password = substr(md5(time()), 0, 8);
        $user = User::create([
            'name' => $application->first_name . ' ' . $application->last_name,
            'email' => $application->email,
            'password' => Hash::make($password),
            'unit_id' => $unit->id,
            'role' => 'tenant',
            'rent_price' => $application->set_price ?: $unit->price,
        ]);

        // Update application
        $application->update([
            'status' => 'Accepted',
            'unit_id' => $unit->id
        ]);

        // Try sending email (with error handling)
        try {
            $emailContent = "Dear {$application->first_name} {$application->last_name},\n\n"
                . "Your tenant account has been successfully created.\n\n"
                . "Login Details:\n"
                . "Email: {$application->email}\n"
                . "Password: {$password}\n\n"
                . "You can now access your account at: ".env('APP_URL')."/login\n\n"
                . "Thank you,\n"
                . "Seagold Dormitory Management";

            Mail::raw($emailContent, function ($message) use ($application) {
                $message->to($application->email)
                       ->subject('Your Tenant Account Details - Seagold Dormitory');
            });
            
            \Log::info('Email sent successfully with credentials');
        } catch (\Exception $e) {
            \Log::error('Email failed but account created', [
                'error' => $e->getMessage(),
                'credentials' => [
                    'email' => $application->email,
                    'password' => $password
                ]
            ]);
        }

        return response()->json([
            'message' => 'Tenant account created successfully.',
            'email_sent' => !isset($e) // Indicate if email was sent
        ]);

    } catch (\Exception $e) {
        \Log::error('Error accepting application', ['error' => $e->getMessage()]);
        return response()->json([
            'message' => 'An error occurred',
            'error' => $e->getMessage()
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