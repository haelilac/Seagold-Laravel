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

        $this->sendUpcomingPaymentReminders($threeDaysFromNow);
        $this->sendOverduePaymentReminders($today);

        return 0;
    }

    private function sendUpcomingPaymentReminders($dueDate)
    {
        $tenants = User::where('role', 'tenant')
            ->whereDoesntHave('payments', function ($query) use ($dueDate) {
                $query->whereDate('payment_period', $dueDate)
                      ->where('status', 'confirmed');
            })
            ->with('unit')
            ->get();

        foreach ($tenants as $tenant) {
            Notification::create([
                'user_id' => $tenant->id,
                'title' => 'Payment Reminder',
                'message' => "Your payment is due on {$dueDate->toDateString()}. Submit it before the due date!",
                'is_read' => false,
            ]);

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

            $this->info("Upcoming payment reminder sent to: {$tenant->email}");
        }
    }

    private function sendOverduePaymentReminders($today)
    {
        $tenants = User::where('role', 'tenant')
            ->where(function ($query) use ($today) {
                $query->whereHas('payments', function ($subQuery) use ($today) {
                    $subQuery->where('status', '!=', 'confirmed')
                             ->whereDate('payment_period', '<', $today);
                })
                ->orWhereDoesntHave('payments');
            })
            ->with('unit', 'payments')
            ->get();

        foreach ($tenants as $tenant) {
            $latestOverdue = $tenant->payments->last();
            $period = $latestOverdue->payment_period ?? 'a previous period';

            $message = "Your payment for the period {$period} is overdue. Please pay as soon as possible to avoid penalties.";

            Notification::create([
                'user_id' => $tenant->id,
                'title' => 'Overdue Payment Reminder',
                'message' => $message,
                'is_read' => false,
            ]);

            Mail::raw(
                "Dear {$tenant->name}, {$message}",
                function ($message) use ($tenant) {
                    $message->to($tenant->email)->subject('Overdue Payment Reminder');
                }
            );

            if (!empty($tenant->phone_number)) {
                SMSService::sendOverdueNotice(
                    $tenant->name,
                    $tenant->phone_number,
                    $period
                );
            }

            $this->info("Overdue payment reminder sent to: {$tenant->email}");
        }
    }
}
