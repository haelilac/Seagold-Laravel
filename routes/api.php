<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\TenantController;
use App\Http\Controllers\ApplicationController;
use App\Http\Controllers\UnitController;
use App\Http\Controllers\MaintenanceRequestController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\PaymentController;
use App\Http\Controllers\SettingController;
use App\Events\MyEvent;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\PlaceController;
use App\Http\Controllers\EventController;
use App\Http\Controllers\TourAvailabilityController;
use App\Http\Controllers\GalleryController;
use App\Http\Controllers\FeedbackController;
use App\Models\Payment;
use Symfony\Component\Process\Process;
use Illuminate\Support\Facades\Artisan;
use Symfony\Component\Process\Exception\ProcessFailedException;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;
use App\Http\Controllers\LocationController;
use Illuminate\Support\Facades\Http;
use CloudinaryLabs\CloudinaryLaravel\Facades\Cloudinary;
use App\Http\Controllers\ForgotPasswordController;
use App\Http\Controllers\ResetPasswordController;
use App\Http\Controllers\SMSController;
use App\Http\Controllers\AmenityRequestController;  // <<== ADD this

Route::post('/google-verify-email', [AuthController::class, 'verifyGoogleEmail']);

Route::post('/forgot-password', [ForgotPasswordController::class, 'sendResetLink']);
Route::post('/reset-password', [ResetPasswordController::class, 'reset']);

Route::get('/test', function () {
    return response()->json(['status' => 'Laravel Backend is Working!']);
});

Route::middleware('auth:sanctum')->post('/auth/validate-token', [AuthController::class, 'validateToken']);
Route::middleware('auth:sanctum')->post('/auth/refresh-token', [AuthController::class, 'refreshToken']);

Route::post('/unit-images/pricing/upload', [UnitController::class, 'uploadPricingImage']);

Route::get('/provinces', [LocationController::class, 'getProvinces']);
Route::get('/cities/{provinceCode}', [LocationController::class, 'getCities']);
Route::get('/barangays/{cityMunCode}', [LocationController::class, 'getBarangays']);

Route::post('/validate-receipt', [PaymentController::class, 'validateReceipt']);
Route::post('/validate-receipt', [ApplicationController::class, 'validateReceipt']);
Route::post('/validate-payment-receipt', [PaymentController::class, 'validatePaymentReceipt']);


Route::post('/upload-id', function (Request $request) {
    Log::info('Upload ID API called');

    try {
        $validated = $request->validate([
            'file' => 'required|image|mimes:jpeg,png,jpg|max:2048',
            'id_type' => 'required|string',
        ]);

        // ✅ Upload to Cloudinary
        $uploadedFileUrl = Cloudinary::upload($request->file('file')->getRealPath())->getSecurePath();
        Log::info("Uploaded to Cloudinary: " . $uploadedFileUrl);

        // ✅ Call OCR API using Cloudinary URL
        $ocrApiUrl = app()->environment('local')
        ? 'http://localhost:9090/upload-id/'
        : env('RAILWAY_OCR_URL', 'https://seagold-python-production.up.railway.app/upload-id/');
    
    $response = Http::attach('id_type', $validated['id_type'])
                    ->attach('image_url', $uploadedFileUrl)
                    ->post($ocrApiUrl);
    

        if (!$response->ok()) {
            return response()->json([
                'message' => 'OCR failed',
                'error' => $response->body()
            ], 500);
        }

        $ocrResult = $response->json();

        return response()->json([
            'message' => $ocrResult['id_type_matched'] ? 'ID verified successfully' : 'ID mismatch',
            'ocr_text' => $ocrResult['text'],
            'file_path' => $uploadedFileUrl, // Cloudinary link returned
            'id_verified' => $ocrResult['id_type_matched'],
        ]);
    } catch (\Exception $e) {
        Log::error("Upload ID error: " . $e->getMessage());
        return response()->json([
            'message' => 'Server error.',
            'error' => $e->getMessage(),
        ], 500);
    }
});

Route::get('/check-reference/{reference_number}', function ($reference_number) {
    return response()->json([
        'exists' => Payment::where('reference_number', $reference_number)->exists(),
    ]);
});

Route::get('/gallery', [GalleryController::class, 'index']);
Route::middleware(['auth:sanctum'])->group(function () {
    Route::post('/gallery/upload', [GalleryController::class, 'store']); // Upload new image
    Route::put('/gallery/{id}', [GalleryController::class, 'update']); // Update image details
    Route::delete('/gallery/{id}', [GalleryController::class, 'destroy']); // Delete image
});


Route::post('/bookings/confirm/{id}', [TourAvailabilityController::class, 'confirmBooking']);
Route::post('/bookings/cancel/{id}', [TourAvailabilityController::class, 'cancelBooking']);

Route::options('{any}', function () {
    return response()->json(['status' => 'ok'], 200);
})->where('any', '.*');

Route::get('/test-firebase', function () {
    $file = storage_path('app/firebase-service-account.json');
    if (!is_readable($file)) {
        return response()->json(['error' => 'Firebase service account file not readable']);
    }
    return response()->json(['success' => 'Firebase service account file is accessible']);
});


// Admin/Tenant Authenticated Routes
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/auth/validate-token', [AuthController::class, 'validateToken']);
    Route::post('/auth/refresh-token', [AuthController::class, 'refreshToken']);
});

Route::post('/tour-availability/toggle', [TourAvailabilityController::class, 'toggleAvailability']);
// Get all bookings
Route::get('/tour-bookings', [TourAvailabilityController::class, 'getBookings']);

// Get all availability
Route::get('/tour-availability', [TourAvailabilityController::class, 'getAvailability']);

// Get slots for a specific date
Route::get('/tour-slots', [TourAvailabilityController::class, 'getSlots']);

Route::post('/tour-slots/unavailable', [TourAvailabilityController::class, 'makeAllUnavailable']);
Route::get('/tour-dates', [TourAvailabilityController::class, 'getAvailableDates']);
Route::get('/tour-calendar', [TourAvailabilityController::class, 'getCalendar']);
Route::middleware('auth:sanctum')->post('/book-tour', [TourAvailabilityController::class, 'bookTour']);


Route::middleware('auth:sanctum')->group(function () {
    Route::get('/events', [EventController::class, 'index']);
    Route::post('/events', [EventController::class, 'store']);
    Route::put('/events/{id}', [EventController::class, 'update']);
    Route::delete('/events/{id}', [EventController::class, 'destroy']);
});


// Guest Authentication Routes
Route::post('/google-login', [AuthController::class, 'googleLogin'])->middleware('guest');
Route::post('/register-guest', action: [AuthController::class, 'registerGuest']);
Route::post('/google-login-guest', [AuthController::class, 'googleLogin']); // For actual login

Route::get('/places', [PlaceController::class, 'index']);


Route::middleware(['auth:sanctum'])->group(function () {
    // Fetch all notifications for the logged-in user
    Route::get('/notifications', [NotificationController::class, 'index']);

    // Mark all notifications as read
    Route::post('/notifications/mark-as-read', [NotificationController::class, 'markAsRead']);

    // Delete a specific notification
    Route::delete('/notifications/{id}', [NotificationController::class, 'destroy']);
});

Route::get('/trigger-event', function () {
    event(new MyEvent('Hello, this is a real-time test message!'));
    return 'Event triggered successfully!';
});

// Landlord Contact Routes
Route::get('/settings/landlord-contact', [SettingController::class, 'getLandlordContact']);
Route::post('/settings/landlord-contact', [SettingController::class, 'updateLandlordContact']);

// Payments
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/auth/user', function (Request $request) {
        return response()->json($request->user());
    });

    Route::post('/payments', [PaymentController::class, 'store']);
    Route::get('/tenant-payments/{id}', [PaymentController::class, 'getTenantPayments']);
});
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/tenants', [AdminController::class, 'getTenants']);
    Route::get('/payments', [PaymentController::class, 'index']);
});
Route::get('/tenants', [TenantController::class, 'getTenants']);
Route::get('/payments/summary', [PaymentController::class, 'paymentSummary']);

Route::post('/payments/confirm/{user_id}', [PaymentController::class, 'confirmLatestPayment']);
Route::post('/payments/reject/{user_id}', [PaymentController::class, 'rejectLatestPayment']);

Route::post('/payments/{id}/confirm', [PaymentController::class, 'updateSpecificPayment']);

Route::delete('/payments/{id}/destroy', [PaymentController::class, 'destroy']);
Route::post('/payments/{id}/reject', [PaymentController::class, 'rejectPaymentById']);


// Unpaid Tenants
Route::get('/unpaid-tenants', [TenantController::class, 'unpaidTenants']);
Route::post('/tenants/{id}/send-reminder', [TenantController::class, 'sendReminder']);
Route::match(['post'], '/tenants/{id}/send-reminder', [TenantController::class, 'sendReminder']);

// Other Routes
Route::get('/users', [UserController::class, 'index']);
Route::post('/assign-unit', [UnitController::class, 'assignUnit']);
Route::put('/units/{unit}/force-occupy', [UnitController::class, 'forceOccupy']);



// Maintenance Routes
Route::middleware(['auth:sanctum'])->group(function () {
    Route::middleware('role:tenant')->group(function () {
        Route::post('/maintenance-requests', [MaintenanceRequestController::class, 'store']);
        Route::get('/tenant/maintenance-requests', [MaintenanceRequestController::class, 'tenantRequests']);
    });

    Route::middleware('role:admin')->group(function () {
        Route::get('/maintenance-requests', [MaintenanceRequestController::class, 'index']);
        Route::post('/maintenance-requests/{id}/update', [MaintenanceRequestController::class, 'updateStatus']);
        Route::post('/maintenance-requests/{id}/schedule', [MaintenanceRequestController::class, 'schedule']);
        Route::delete('/maintenance-requests/{id}', [MaintenanceRequestController::class, 'destroy']);
    });

    Route::post('/maintenance-requests/{id}/cancel', [MaintenanceRequestController::class, 'cancelRequest']);
});

// Application Routes
Route::post('/applications', [ApplicationController::class, 'store']);
Route::get('/applications', [ApplicationController::class, 'index']);
Route::middleware('auth:sanctum')->post('/applications/{id}/accept', [ApplicationController::class, 'accept']);
Route::delete('/applications/{id}/decline', [ApplicationController::class, 'decline']);
Route::put('/units/{id}/status', [UnitController::class, 'updateStatus']);

// Unit Routes
Route::apiResource('units', UnitController::class);

// Authentication Routes
Route::post('/login-guest', [AuthController::class, 'loginGuest'])->middleware('guest');
Route::post('/login-admin-tenant', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout'])->middleware('auth:sanctum');

// Tenant Routes
Route::middleware(['auth:sanctum', 'role:tenant'])->group(function () {
    Route::get('/tenant/dashboard', [TenantController::class, 'index']); // Tenant Dashboard
});
// Tenant Route to get assigned unit
Route::middleware(['auth:sanctum', 'role:tenant'])->group(function () {
    Route::get('/tenant/unit', [TenantController::class, 'getAssignedUnit']);
});

// Fetch the authenticated user's details
Route::middleware('auth:sanctum')->get('/auth/user', function (Request $request) {
    return response()->json($request->user());
});


Route::post('/feedback', [FeedbackController::class, 'store']); // For submitting feedback
Route::get('/feedback', [FeedbackController::class, 'index']); // For retrieving all feedback


Route::put('/tenants/{id}/update', [TenantController::class, 'updateTenant']);
Route::delete('/tenants/{id}/terminate', [TenantController::class, 'terminateContract']);
Route::get('/units/available', [UnitController::class, 'availableUnits']);
Route::put('/tenants/{id}/change-unit', [TenantController::class, 'changeUnit']);
Route::get('/terminated-tenants', [TenantController::class, 'getTerminatedTenants']);
Route::put('/applications/{id}/update', [ApplicationController::class, 'update']);
Route::delete('/tenants/{id}/terminate', [TenantController::class, 'terminateTenant']);


Route::get('/run-contract-check', function () {
    Artisan::call('check:contract-endings');

    return response()->json([
        'status' => 'success',
        'message' => 'Contract ending check triggered.',
    ]);
});

Route::get('/units', [UnitController::class, 'index']);
Route::get('/units/by-code/{unit_code}', [UnitController::class, 'getUnitsByCode']);


Route::get('/room-pricing', [UnitController::class, 'getRoomPricing']);
Route::get('/room-pricing/{unit_code}', [UnitController::class, 'getRoomPricingByUnit']);


Route::post('/unit-images/upload', [UnitController::class, 'uploadRoomImage']);
Route::get('/unit-images/{unit_code}', [UnitController::class, 'getUnitImages']);
Route::delete('/unit-images/{id}', [UnitController::class, 'deleteRoomImage']);
Route::get('/public-units', [UnitController::class, 'publicUnits']);
Route::get('/applications-only', [ApplicationController::class, 'applicationsOnly']);
Route::get('/units-only', [ApplicationController::class, 'unitsOnly']);



Route::middleware('auth:sanctum')->post('/upload-profile', [UserController::class, 'uploadProfile']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/change-password', [UserController::class, 'changePassword']);
});

Route::put('/notifications/{id}/read', [NotificationController::class, 'markAsRead']);

Route::middleware('auth:sanctum')->get('/tenant-room-info', [TenantController::class, 'getTenantRoomInfo']);

Route::post('/maintenance-requests/{id}/follow-up', [MaintenanceRequestController::class, 'followUp']);


//Sms reminder
Route::post('/send-sms-reminder', [SMSController::class, 'sendReminder']);

// Upload a pricing image
Route::post('/unit-images/pricing-upload', [UnitController::class, 'uploadPricingImage']);

// Amenity Requests
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/amenities/request', [AmenityRequestController::class, 'store']);
    Route::get('/amenities/requests', [AmenityRequestController::class, 'index']);
    Route::put('/amenities/approve/{id}', [AmenityRequestController::class, 'approve']);
    Route::put('/amenities/reject/{id}', [AmenityRequestController::class, 'reject']);
});

Route::post('/tenants/{id}/send-reminder', [TenantController::class, 'sendReminder']);

Route::get('/run-reminders', function () {
    \Artisan::call('payments:send-reminders');
    return response()->json(['message' => 'Reminders triggered!']);
});

Route::post('/broadcasting/auth', function (Request $request) {
    return Broadcast::auth($request);
});

Route::post('/login', [AuthController::class, 'login']);

Route::post('/broadcasting/auth', function (Request $request) {
    return Broadcast::auth($request);
})->middleware('auth:sanctum');  // Add the 'auth:sanctum' middleware