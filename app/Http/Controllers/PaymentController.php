<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Event;
use App\Events\PaymentRejected;
use App\Models\Payment;
use Illuminate\Http\Request;
use Carbon\Carbon;
use App\Models\User;
use App\Models\Unit;
use App\Events\NewAdminNotificationEvent;
use App\Events\NewTenantNotificationEvent;
use CloudinaryLabs\CloudinaryLaravel\Facades\Cloudinary;
class PaymentController extends Controller
{

    private function calculateTotalAmount($stayType, $unitPrice, $duration, $unit)
{
    return match ($stayType) {
        'daily' => $unitPrice * $duration,
        'weekly' => $unitPrice * ceil($duration / 7),
        'half-month' => $unitPrice / 2,
        'monthly' => $unitPrice,
        default => $unitPrice,
    };
}
    public function unpaidTenants()
    {
        $currentMonth = now()->format('F');
    
        $unpaidTenants = User::where('role', 'tenant')
            ->whereDoesntHave('payments', function ($query) use ($currentMonth) {
                $query->where('payment_period', $currentMonth)->where('status', 'Confirmed');
            })
            ->with('unit')
            ->get()
            ->map(function ($tenant) {
                return [
                    'id' => $tenant->id,
                    'name' => $tenant->name,
                    'unit_code' => $tenant->unit?->unit_code ?? 'N/A',
                    'total_due' => $tenant->unit?->price ?? 0,
                    'balance' => $tenant->unit?->price ?? 0,
                    'due_date' => now()->startOfMonth()->toDateString(),
                    'status' => 'Unpaid',
                    'last_payment' => null,
                    'unpaid_months' => 1
                ];
            });
    
        return response()->json($unpaidTenants);
    }
    
    
    public function store(Request $request)
    {
        $user = $request->user();
        
        if (!$user) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }
    
        // Validate the incoming request
        $request->validate([
            'amount' => 'required|numeric|min:1',
            'payment_method' => 'required|string|max:50',
            'payment_type' => 'required|string|max:50',
            'reference_number' => 'nullable|string|max:50',
            'payment_for' => 'required|date',
            'receipt' => 'nullable|file|mimes:png,jpg,jpeg,pdf|max:2048',
        ]);
    
        $unitId = $user->unit_id ?? null; 
        if (!$unitId) {
            return response()->json(['error' => 'Server error', 'details' => 'Tenant has no assigned unit.'], 400);
        }
    
        // Fetch the unit model
        $unit = \App\Models\Unit::find($unitId);
        if (!$unit) {
            return response()->json(['error' => 'Unit not found.'], 404);
        }
    
        $unitPrice = $user->rent_price ?? $unit->price ?? 0;
    
        // Handle the receipt file upload to Cloudinary if exists
        $receiptPath = null;
        if ($request->hasFile('receipt')) {
            $receipt = $request->file('receipt');
            // Upload the receipt to Cloudinary
            $upload = Cloudinary::upload($receipt->getRealPath(), [
                'folder' => 'payments/receipts',  // Folder where the receipts will be stored
                'resource_type' => 'auto' // Automatically detects file type (image, pdf, etc.)
            ]);
    
            // Save the secure URL for the receipt
            $receiptPath = $upload->getSecurePath(); // Cloudinary secure URL
        }
    
        // Calculate the total amount based on the stay type
        $stayType = $request->stay_type;
        $duration = $request->duration; // Duration in days
        $totalAmount = $this->calculateTotalAmount($stayType, $unitPrice, $duration, $unit);
    
        // Prevent partial payments for non-monthly tenants
        if ($stayType !== 'monthly' && $request->amount < $totalAmount) {
            return response()->json(['error' => 'Partial payments are not allowed for this stay type.'], 400);
        }
    
        // Handle duplicate payment reference number
        if (Payment::where('reference_number', $request->reference_number)->exists()) {
            return response()->json([
                'error' => 'Duplicate Reference Number',
                'details' => 'The reference number has already been used. Please enter a new one.'
            ], 400);
        }
    
        // Store payment
        $payment = Payment::create([
            'user_id' => $user->id,
            'unit_id' => $unitId,
            'amount' => $request->amount,
            'remaining_balance' => $totalAmount - $request->amount,
            'payment_type' => $request->amount < $totalAmount ? 'Partially Paid' : 'Fully Paid',
            'payment_method' => $request->payment_method,
            'reference_number' => $request->reference_number,
            'payment_period' => $request->payment_for,
            'receipt_path' => $receiptPath,  // Cloudinary URL for the receipt
            'status' => 'Pending',
        ]);
    
        event(new \App\Events\NewTenantNotificationEvent(
            $user->id,
            'Payment Submitted',
            "Your payment for {$request->payment_for} has been submitted and is awaiting confirmation.",
            now()->format('M d, Y - h:i A'),
            'billing' // ✅ Pass type
        ));
        

        return response()->json([
            'message' => 'Payment recorded successfully!',
            'payment' => $payment,
        ], 200);
    }
    
    
    private function calculateNextDueDate($checkInDate, $duration, $stayType, $payments)
    {
        if (!$checkInDate || !$duration) {
            return null;
        }
    
        $checkIn = Carbon::parse($checkInDate);
    
        $interval = match($stayType) {
            'daily' => 'addDay',
            'weekly' => 'addWeek',
            'half-month' => fn($date, $i) => $date->copy()->addDays($i * 15),
            'monthly' => 'addMonth',
            default => 'addMonth',
        };
    
        $expectedPeriods = [];
    
        for ($i = 0; $i < $duration; $i++) {
            $date = is_callable($interval)
                ? $interval($checkIn, $i)
                : $checkIn->copy()->{$interval}($i);
    
            $expectedPeriods[] = $date->format('Y-m-d');
        }
    
        $paidPeriods = collect($payments)->where('status', 'Confirmed')->pluck('payment_period')->toArray();
    
        foreach ($expectedPeriods as $period) {
            if (!in_array($period, $paidPeriods)) {
                return Carbon::parse($period)->toFormattedDateString(); // e.g., "June 30, 2025"
            }
        }
    
        return 'Completed';
    }
    
public function updateSpecificPayment($id)
{
    $payment = Payment::where('id', $id)->where('status', 'Pending')->firstOrFail();
    $payment->update(['status' => 'Confirmed']);

    return response()->json(['message' => 'Payment confirmed successfully!', 'payment' => $payment]);
}
public function confirmLatestPayment($user_id)
{
    $payment = Payment::where('user_id', $user_id)
        ->where('status', 'Pending')
        ->latest('created_at') // Fetch most recent payment
        ->first();

    if (!$payment) {
        return response()->json(['message' => 'No pending payment found for this user.'], 404);
    }

    $payment->update(['status' => 'Confirmed']);
    event(new \App\Events\NewTenantNotificationEvent(
        $payment->user_id,
        'Payment Confirmed',
        "✅ Your payment for {$payment->payment_period} has been confirmed by the admin.",
        now()->format('M d, Y - h:i A'),
        'billing'
    ));

    Notification::create([
        'user_id' => $payment->user_id,
        'title' => 'Payment Confirmed',
        'message' => "✅ Your payment for {$payment->payment_period} has been confirmed by the admin.",
        'type' => 'billing',
        'is_read' => false,
    ]);
    
    return response()->json(['message' => 'Payment confirmed successfully!', 'payment' => $payment]);
}


public function rejectLatestPayment($user_id)
{
    $payment = Payment::where('user_id', $user_id)
        ->where('status', 'Pending')
        ->latest('created_at') 
        ->first();

    if (!$payment) {
        return response()->json(['message' => 'No pending payment found for this user.'], 404);
    }

    $payment->update(['status' => 'Rejected']);

    // ✅ Trigger event
    event(new PaymentRejected($payment->user_id));
    event(new \App\Events\NewTenantNotificationEvent(
        $payment->user_id,
        'Payment Rejected',
        "❌ Your payment for {$payment->payment_period} was rejected. Please resubmit or contact admin.",
        now()->format('M d, Y - h:i A'),
        'billing'
    ));

    Notification::create([
        'user_id' => $payment->user_id,
        'title' => 'Payment Rejected',
        'message' => " Your payment for {$payment->payment_period} has been rejected by the admin.",
        'type' => 'billing',
        'is_read' => false,
    ]);
    return response()->json(['message' => 'Payment rejected successfully!', 'payment' => $payment]);
}


public function updateStatus($user_id)
{
    // Find the pending payment for the current month
    $currentMonth = now()->format('Y-m'); // e.g., "2024-06"
    
    $payment = Payment::where('user_id', $user_id)
                ->where('status', 'Pending')
                ->where('payment_period', $currentMonth)
                ->first();

    if (!$payment) {
        return response()->json(['message' => 'No pending payment found for the current month.'], 404);
    }

    $payment->update(['status' => 'Confirmed']);

    return response()->json([
        'message' => 'Payment confirmed successfully!',
        'payment' => $payment,
    ]);
}



    // Rename from rejectPayment to rejectPaymentById
    public function rejectPaymentById($id)
    {
        $payment = Payment::findOrFail($id);
        $payment->update(['status' => 'Rejected']);

        return response()->json(['message' => 'Payment rejected successfully!']);
    }


    // 🚨 Permanently delete a payment
    public function destroy($id)
    {
        $payment = Payment::withTrashed()->find($id); // Include soft-deleted too

        if (!$payment) {
            return response()->json(['message' => 'Payment not found.'], 404);
        }

        $payment->forceDelete(); // 💣 Permanently delete
        return response()->json(['message' => 'Payment permanently deleted.']);
    }

        
    // Fetch All Payments
    public function index(Request $request)
    {
        try {
            $status = $request->query('status');
            $month = $request->query('month');
            $year = $request->query('year');
            $search = $request->query('search');
            $startDate = $request->query('start_date');
            $endDate = $request->query('end_date');
    
            $query = Payment::with(['user', 'unit']);
    
            if (!empty($status)) {
                $query->where('status', $status);
            }
    
            if (!empty($month)) {
                $query->whereMonth('payment_period', $month);
            }
    
            if (!empty($year)) {
                $query->whereYear('payment_period', $year);
            }
    
            if (!empty($search)) {
                $query->whereHas('user', function ($q) use ($search) {
                    $q->where('name', 'like', "%{$search}%");
                });
            }
    
            if (!empty($startDate) && !empty($endDate)) {
                $query->whereBetween('created_at', [$startDate, $endDate]);
            }
    
            $payments = $query->get();
    
            $formattedPayments = $payments->map(function ($payment) {
                return [
                    'id' => $payment->id,
                    'user_id' => $payment->user_id,
                    'tenant_name' => $payment->user?->name ?? 'N/A',
                    'unit_code' => $payment->unit?->unit_code ?? 'N/A',
                    'amount' => $payment->amount,
                    'total_due' => $payment->amount + $payment->remaining_balance,
                    'payment_type' => $payment->payment_type,
                    'payment_method' => $payment->payment_method,
                    'reference_number' => $payment->reference_number,
                    'payment_period' => Carbon::parse($payment->payment_period)->toDateString(),
                    'remaining_balance' => $payment->remaining_balance,
                    'submitted_at' => $payment->created_at->toDateString(),
                    'status' => $payment->status,
                    'receipt_path' => $payment->receipt_path ?? null,
                ];
            });
    
            return response()->json($formattedPayments);
        } catch (\Exception $e) {
            \Log::error('💥 PaymentController@index error: ' . $e->getMessage());
            return response()->json(['error' => 'Something went wrong.'], 500);
        }
    }
    
    
    public function paymentSummary()
    {
        try {
            $totalConfirmed = Payment::where('status', 'Confirmed')->sum('amount');
            $pendingPayments = Payment::where('status', 'Pending')->count();
    
            // Dynamically calculate the outstanding balance for tenants
            $outstandingBalance = User::where('role', 'tenant')
                ->with('unit', 'payments')
                ->get()
                ->sum(function ($tenant) {
                    $totalDue = optional($tenant->unit)->price * optional($tenant->application)->duration ?? 1;
                    $totalPaid = $tenant->payments->where('status', 'Confirmed')->sum('amount');
                    return max($totalDue - $totalPaid, 0); // Ensure non-negative balance
                });
    
            return response()->json([
                'total_confirmed' => $totalConfirmed,
                'pending_payments' => $pendingPayments,
                'outstanding_balance' => $outstandingBalance,
            ]);
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to fetch summary', 'details' => $e->getMessage()], 500);
        }
    }
    
    public function validatePaymentReceipt(Request $request)
    {
        \Log::info('📥 Received validatePaymentReceipt request', [
            'headers' => $request->headers->all(),
            'method' => $request->method(),
            'body' => $request->except(['receipt']),
        ]);
    
        $request->validate([
            'receipt_url' => 'required|string',
            'user_reference'  => 'required|string',
            'user_amount'     => 'required|numeric',
        ]);
    
        $receiptUrl = $request->input('receipt_url');
    
        try {
            $tempFile = tempnam(sys_get_temp_dir(), 'receipt_');
            file_put_contents($tempFile, file_get_contents($receiptUrl));
    
            $ocrApiUrl = 'https://seagold-python-production.up.railway.app/validate-payment-receipt/';

            $ocrResponse = Http::attach(
                'receipt', file_get_contents($tempFile), 'receipt.jpg'
            )->asForm()->post($ocrApiUrl, [
                'user_reference' => $request->input('user_reference'),
                'user_amount'    => $request->input('user_amount'),
            ]);
    
            unlink($tempFile); // 🔥 Clean up the temp file
    
            if ($ocrResponse->failed()) {
                \Log::error('❌ OCR FastAPI failed', ['status' => $ocrResponse->status()]);
                return response()->json(['message' => 'OCR service failed.'], 500);
            }
    
            return response()->json($ocrResponse->json());
    
        } catch (\Exception $e) {
            \Log::error('❌ validatePaymentReceipt error', ['error' => $e->getMessage()]);
            return response()->json(['message' => 'Internal server error'], 500);
        }
    }
    
    
        
    public function getTenantPayments($tenantId)
    {
        try {
            $tenant = User::findOrFail($tenantId);
            $application = \App\Models\Application::where('email', $tenant->email)->firstOrFail();
    
            // Fetch the unit assigned to the tenant
            $unit = Unit::find($application->unit_id);
    
            if (!$unit) {
                return response()->json(['error' => 'No unit assigned to this tenant.'], 404);
            }
    
            // Use set_price from applications table if available, otherwise use original unit price
            $unitPrice = $tenant->rent_price ?? ($application->set_price ?? $unit->price);
    
            // Retrieve all payments made by the user
            $payments = \App\Models\Payment::where('user_id', $tenantId)
            ->get();
    
            $unpaidBalances = [];
            $dueDate = $this->calculateNextDueDate(
                $application->check_in_date,
                $application->duration,
                $application->stay_type,
                $payments
            );
            
            // Generate months based on duration and check-in date
            $startDate = Carbon::parse($application->check_in_date);
            $months = [];
    
            $months = [];

            $interval = match($application->stay_type) {
                'daily' => 'addDays',
                'weekly' => 'addWeeks',
                'half-month' => function($date, $i) { return $date->copy()->addDays($i * 15); }, // Special case
                'monthly' => 'addMonths',
                default => 'addMonths',
            };
            
            for ($i = 0; $i < $application->duration; $i++) {
                if (is_callable($interval)) {
                    $paymentDate = $interval($startDate, $i);
                } else {
                    $paymentDate = $startDate->copy()->{$interval}($i);
                }
                $months[] = $paymentDate->format('Y-m-d');
            }
    
            // Calculate the unpaid balances for each month
            $totalPaidPerMonth = [];
    
            foreach ($payments as $payment) {
                $month = $payment->payment_period;
                if (!isset($totalPaidPerMonth[$month])) {
                    $totalPaidPerMonth[$month] = 0;
                }
                $totalPaidPerMonth[$month] += $payment->amount;
            }
    
            // Calculate remaining balance for each month
            foreach ($months as $month) {
                $amountPaid = $totalPaidPerMonth[$month] ?? 0; // Defaults to 0 if no payment found
                $remainingBalance = max(0, $unitPrice - $amountPaid);
                $unpaidBalances[$month] = $remainingBalance;
            }
    
            return response()->json([
                'unit_price' => $unitPrice,
                'payments' => $payments,
                'due_date' => $dueDate,
                'check_in_date' => $application->check_in_date,
                'duration' => $application->duration,
                'stay_type' => $application->stay_type,
                'unpaid_balances' => $unpaidBalances,
            ], 200);
        } catch (\Exception $e) {
            \Log::error('Failed to fetch tenant payments: ' . $e->getMessage());
            return response()->json(['error' => 'Failed to fetch tenant payments.'], 500);
        }
    }
    
    
}
