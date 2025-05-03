<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Payment;
use App\Models\User;
use App\Models\Notification;
use Carbon\Carbon;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Broadcast;
use App\Services\SMSService;

class SendPaymentReminders extends Command
{
    protected $signature = 'payments:send-reminders';
    protected $description = 'Send payment reminders to tenants 3 days before the due date and for overdue payments';

    public function handle()
    {
        $today = Carbon::now()->startOfDay();
        $threeDaysFromNow = $today->copy()->addDays(3);

        // 1. Send reminders for payments due in 3 days
        $this->sendUpcomingPaymentReminders($threeDaysFromNow);

        // 2. Send reminders for overdue payments
        $this->sendOverduePaymentReminders($today);

        return 0;
    }

    private function sendUpcomingPaymentReminders($dueDate)
    {
        $tenants = User::where('role', 'tenant')
            ->whereDoesntHave('payments', function ($query) use ($dueDate) {
                $query->whereDate('payment_period', $dueDate)
                      ->where('status', 'confirmed'); // Ensure only unpaid payments are considered
            })
            ->with('unit')
            ->get();

        foreach ($tenants as $tenant) {
            // Save notification in the database
            Notification::create([
                'user_id' => $tenant->id,
                'title' => 'Payment Reminder',
                'message' => "Your payment is due on {$dueDate->toDateString()}. Submit it before the due date!",
                'is_read' => false,
            ]);

            // Send email reminder
            Mail::raw(
                "Dear {$tenant->name}, your payment is due on {$dueDate->toDateString()}. Please submit it before the due date.",
                function ($message) use ($tenant) {
                    $message->to($tenant->email)->subject('Upcoming Payment Reminder');
                }
            );

            if (!empty($tenant->phone_number)) {
                SMSService::sendBillNotice(
                    $tenant->name,
                    $tenant->phone_number,
                    $tenant->unit->price ?? 0,
                    $dueDate
                );
            }
            // Log the reminder for the console
            $this->info("Upcoming payment reminder sent to: {$tenant->email}");
        }
    }

    private function sendOverduePaymentReminders($today)
    {
        $applications = \App\Models\Application::whereNotNull('contact_number')->get();
    
        foreach ($applications as $app) {
            $user = \App\Models\User::where('email', $app->email)->first();
    
            if (!$user) {
                continue; // Skip if no matching registered user
            }
    
            $name = "{$app->first_name} {$app->last_name}";
            $phone = $app->contact_number;
            $email = $app->email;
    
            $latestOverdue = \App\Models\Payment::where('email', $email)
                ->where('status', '!=', 'confirmed')
                ->whereDate('payment_period', '<', $today)
                ->orderByDesc('payment_period')
                ->first();
    
            if (!$latestOverdue) {
                continue;
            }
    
            $period = Carbon::parse($latestOverdue->payment_period)->format('F Y');
            $message = "Your payment for the period {$period} is overdue. Please pay as soon as possible to avoid penalties.";
    
            // Save in notifications
            Notification::create([
                'user_id' => $user->id,
                'title' => 'Overdue Payment Reminder',
                'message' => $message,
                'is_read' => false,
            ]);
    
            // Send email
            Mail::raw(
                "Dear {$name}, {$message}",
                function ($mail) use ($email) {
                    $mail->to($email)->subject('Overdue Payment Reminder');
                }
            );
    
            // Send SMS
            if (!empty($phone)) {
                SMSService::sendOverdueNotice($name, $phone, $period);
            }
    
            $this->info("Overdue reminder sent to: {$email}");
        }
    }
    
    
}
