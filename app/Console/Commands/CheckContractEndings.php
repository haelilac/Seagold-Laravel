<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\User;
use App\Models\Application;
use App\Models\Notification;
use Carbon\Carbon;

class CheckContractEndings extends Command
{
    protected $signature = 'check:contract-endings';
    protected $description = 'Notify tenants and admin if contracts are ending this month';

    public function handle()
    {
        $tenants = User::where('role', 'tenant')->get();

        foreach ($tenants as $tenant) {
            $application = Application::where('email', $tenant->email)->first();

            if (!$application || !$application->check_in_date || !$application->duration) {
                continue;
            }

            $checkInDate = Carbon::parse($application->check_in_date);
            $contractEndMonth = $checkInDate->copy()->addMonths($application->duration - 1)->month;
            $contractEndYear = $checkInDate->copy()->addMonths($application->duration - 1)->year;

            if (now()->month === $contractEndMonth && now()->year === $contractEndYear) {
                // Notify tenant
                Notification::updateOrCreate([
                    'user_id' => $tenant->id,
                    'type' => 'contract_ending',
                    'title' => 'Final Month of Contract',
                ], [
                    'message' => 'Your rental contract is ending this month. Please contact the admin for renewal options.',
                    'is_read' => false,
                ]);

                // Notify admin
                Notification::create([
                    'user_id' => null, // global for admin
                    'type' => 'contract_ending',
                    'title' => 'Tenant Contract Ending',
                    'message' => "{$tenant->name}'s contract is ending this month.",
                    'is_read' => false,
                ]);
            }
        }

        $this->info('Checked tenant contract endings.');
    }
}
