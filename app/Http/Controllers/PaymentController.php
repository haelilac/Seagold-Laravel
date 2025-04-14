<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Event;
use App\Events\PaymentRejected;
use App\Models\Payment;
use Illuminate\Http\Request;
use Carbon\Carbon;
use App\Models\User;
use App\Models\Unit;
class PaymentController extends Controller
{

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
    
    
    // Store Payment
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
        
        // ✅ Fetch the unit model
        $unit = \App\Models\Unit::find($unitId);
        if (!$unit) {
            return response()->json(['error' => 'Unit not found.'], 404);
        }
        
        $unitPrice = $user->rent_price ?? $unit->price ?? 0; // Default to rent_price if available, otherwise fallback to unit price
        
        $stayType = $request->stay_type;
        $duration = $request->duration; // Duration in days
        
        // Calculate the total amount based on the stay type
        switch ($stayType) {
            case 'daily':
                $totalAmount = $unitPrice * $duration; // Daily calculation
                break;
            case 'weekly':
                $totalWeeks = ceil($duration / 7); // Calculate weeks
                $totalAmount = $unitPrice * $totalWeeks; // Weekly calculation
                break;
            case 'half-month':
                $totalAmount = $unit->half_month_price; // Use fixed half-month price
                break;
            case 'monthly':
                $totalAmount = $unitPrice; // Use full unit price for monthly
                break;
            default:
                $totalAmount = $unitPrice; // Default to unit price
        }
        
    
        // Handle duplicate payment reference number
        if (Payment::where('reference_number', $request->reference_number)->exists()) {
            return response()->json([
                'error' => 'Duplicate Reference Number',
                'details' => 'The reference number has already been used. Please enter a new one.'
            ], 400);
        }
    
        // Check if there's an existing pending payment for the same month
        $hasPending = Payment::where('user_id', $user->id)
            ->where('payment_period', $request->payment_for)
            ->where('status', 'Pending')
            ->exists();
    
        if ($hasPending) {
            return response()->json([
                'error' => 'Pending Payment Exists',
                'details' => 'You already have a pending payment for this billing period.'
            ], 400);
        }
    

        // Store payment
        $payment = Payment::create([
            'user_id' => $user->id,
            'unit_id' => $unitId,
            'amount' => $totalAmount,
            'remaining_balance' => $totalAmount - $request->amount,
            'payment_type' => $request->amount < $totalAmount ? 'Partially Paid' : 'Fully Paid',
            'payment_method' => $request->payment_method,
            'reference_number' => $request->reference_number,
            'payment_period' => $request->payment_for,
            'receipt_path' => $request->hasFile('receipt') ? $request->file('receipt')->store('uploads/receipts', 'public') : null,
            'status' => 'Pending',
        ]);
    
        // Trigger the payment submitted event
        event(new \App\Events\NewPaymentSubmitted($payment));
    
        return response()->json([
            'message' => 'Payment recorded successfully!',
            'payment' => $payment,
        ], 200);
    }    
    
    
    private function calculateNextDueDate($checkInDate, $duration)
    {
        if (!$checkInDate || !$duration) {
            return null;
        }
    
        $checkIn = Carbon::parse($checkInDate);
    
        // Ensure the first payment is due one month after the check-in date
        $nextDueDate = $checkIn->copy()->addMonth();
    
        // Calculate the final due date based on duration
        $finalDueDate = $checkIn->copy()->addMonths($duration);
    
        // If the next due date is greater than the final duration, mark as "Completed"
        if ($nextDueDate->greaterThan($finalDueDate)) {
            return 'Completed';
        }
    
        return $nextDueDate->toDateString();
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
                    'payment_type' => $payment->payment_type,
                    'payment_method' => $payment->payment_method,
                    'reference_number' => $payment->reference_number,
                    'payment_period' => Carbon::parse($payment->payment_period)->toDateString(),
                    'remaining_balance' => $payment->remaining_balance,
                    'submitted_at' => $payment->created_at->toDateString(),
                    'status' => $payment->status,
                    'receipt_path' => $payment->receipt_path
                        ? asset('storage/' . $payment->receipt_path)
                        : null,
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
    
    public function validateReceipt(Request $request)
    {
        \Log::info("📥 Received validateReceipt request", [
            'headers' => $request->headers->all(),
            'method' => $request->method(),
            'files' => $request->allFiles(),
        ]);
    
        if (!$request->hasFile('receipt')) {
            return response()->json(['message' => 'No receipt uploaded.'], 400);
        }
    
        $request->validate([
            'receipt' => 'required|file|mimes:png,jpg,jpeg,pdf|max:2048',
            'user_reference' => 'required|string|min:13|max:13',
            'user_amount' => 'required|numeric|min:1',
        ]);
    
        $receipt = $request->file('receipt');
        $receiptPath = $receipt->getPathname();
    
        try {
            // 🔍 Prepare the file to be sent to FastAPI
            $client = new \GuzzleHttp\Client();
            $response = $client->post('https://seagold-python-production.up.railway.app/upload-id/', [
                'multipart' => [
                    [
                        'name' => 'file',
                        'contents' => fopen($receiptPath, 'r'),
                        'filename' => $receipt->getClientOriginalName(),
                    ],
                    [
                        'name' => 'id_type',
                        'contents' => 'gcash',
                    ],
                ]
            ]);
            
    
            $responseContent = $response->getBody()->getContents();
            \Log::info("📜 FastAPI Response: " . $responseContent);
    
            $ocrData = json_decode($responseContent, true);
    
            if (!$ocrData || !isset($ocrData['extracted_reference']) || !isset($ocrData['extracted_amount'])) {
                return response()->json(['message' => 'Could not extract reference number or amount.'], 400);
            }
    
            $extractedReference = trim(strval($ocrData['extracted_reference']));
            $extractedAmount = floatval($ocrData['extracted_amount']);
            
            $userReference = trim(strval($request->user_reference));
            $userAmount = floatval($request->user_amount);
    
            if ($extractedReference !== $userReference) {
                return response()->json([
                    'match' => false,
                    'message' => '❌ Reference number does not match!',
                    'ocr_data' => $ocrData
                ], 400);
            }
    
            if ($extractedAmount !== $userAmount) {
                return response()->json([
                    'match' => false,
                    'message' => '❌ Amount does not match! Please enter the exact amount from the receipt.',
                    'ocr_data' => $ocrData
                ], 400);
            }
    
            return response()->json([
                'match' => true,
                'message' => '✅ Receipt validated successfully!',
                'ocr_data' => $ocrData
            ]);
        } catch (\Exception $e) {
            \Log::error('Error during receipt validation: ' . $e->getMessage());
            return response()->json(['message' => 'Server error: Unable to process the receipt.'], 500);
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
    
            // ✔️ Use set_price from applications table if available, otherwise use original unit price
            $unitPrice = $tenant->rent_price ?? ($application->set_price ?? $unit->price);
    
            // Retrieve all payments made by the user
            $payments = \App\Models\Payment::where('user_id', $tenantId)
            ->where('status', 'Confirmed')
            ->get();

            $unpaidBalances = [];
            $dueDate = $this->calculateNextDueDate($application->check_in_date, $application->duration);
    
            // Generate months based on duration and check-in date
            $startDate = Carbon::parse($application->check_in_date);
            $months = [];
    
            for ($i = 0; $i < $application->duration; $i++) {
                $currentMonth = $startDate->copy()->addMonths($i)->format('Y-m-d');
                $months[] = $currentMonth;
            }
            
            $intervalDays = match($application->stay_type) {
                'daily' => 1,
                'weekly' => 7,
                'half-month' => 15,
                'monthly' => 30,
            };

            for ($i = 0; $i < $application->duration; $i++) {
                $paymentDate = $startDate->copy()->addDays($i * $intervalDays)->format('Y-m-d');
                $months[] = $paymentDate;
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
                'unpaid_balances' => $unpaidBalances,
            ], 200);
        } catch (\Exception $e) {
            \Log::error('Failed to fetch tenant payments: ' . $e->getMessage());
            return response()->json(['error' => 'Failed to fetch tenant payments.'], 500);
        }
    }
    
}
