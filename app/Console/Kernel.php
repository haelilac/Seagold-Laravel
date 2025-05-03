<?php

namespace App\Console;

use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel
{
    /**
     * Define the application's command schedule.
     */
    protected function schedule(Schedule $schedule)
    {
        $schedule->command('notify:unpaid-tenants')->dailyAt('09:00');
        $schedule->command('booking:send-reminders')->dailyAt('05:00'); // Send at 5 AM daily
        $schedule->command('check:contract-endings')->daily();
    }
    protected $commands = [
        \App\Console\Commands\NotifyUnpaidTenants::class,
    ];
    /**
     * Register the commands for the application.
     */
    protected function commands(): void
    {
        $this->load(__DIR__.'/Commands');

        require base_path('routes/console.php');
    }


    protected $middleware = [
        \Fruitcake\Cors\HandleCors::class, // Ensure this is added
    ];
    
}
