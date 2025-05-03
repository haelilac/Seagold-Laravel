<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\User;
use App\Models\Payment;
use Carbon\Carbon;
use App\Events\NewTenantNotificationEvent;

class NotifyUnpaidTenants extends Command
{
    protected $signature = 'notify:unpaid-tenants';
    protected $description = 'Send payment reminder notifications to tenants with unpaid dues';

    public function handle()
    {
        $today = now()->startOfDay();
        $currentMonth = $today->format('Y-m');

        $tenants = User::where('role', 'tenant')
            ->whereHas('unit')
            ->get();

        $notifiedCount = 0;

        foreach ($tenants as $tenant) {
            $hasPaid = Payment::where('user_id', $tenant->id)
                ->where('payment_period', 'like', "$currentMonth%")
                ->where('status', 'Confirmed')
                ->exists();

            if (!$hasPaid) {
                event(new NewTenantNotificationEvent(
                    $tenant->id,
                    'Payment Reminder',
                    "💸 Your payment for this month is still unpaid. Kindly settle before penalty applies.",
                    now()->format('M d, Y - h:i A')
                ));
                $notifiedCount++;
            }
        }

        $this->info("✅ Sent $notifiedCount unpaid payment reminders.");
    }
}
