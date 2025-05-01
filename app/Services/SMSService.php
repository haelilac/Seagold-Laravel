<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class SMSService
{
    public static function send($phone, $message)
    {
        try {
            $response = Http::post('https://api.semaphore.co/api/v4/messages', [
                'apikey' => env('SEMAPHORE_API_KEY'),
                'number' => $phone,
                'message' => $message,
            ]);

            if ($response->successful()) {
                Log::info("✅ SMS sent to {$phone}: {$message}");
                return true;
            } else {
                Log::error("❌ SMS failed for {$phone}: " . $response->body());
                return false;
            }
        } catch (\Exception $e) {
            Log::error("❌ SMS Exception for {$phone}: " . $e->getMessage());
            return false;
        }
    }

    public static function sendBillNotice($name, $phone, $amount, $dueDate)
    {
        $formattedAmount = number_format($amount);
        $formattedDate = \Carbon\Carbon::parse($dueDate)->format('F j, Y');

        $message = "Hi {$name}, this is Seagold Dormitory. We'd like to remind you that your rent of ₱{$formattedAmount} is due on {$formattedDate}. Please make sure to settle it on time. Thank you!";
        
        return self::send($phone, $message);
    }

    public static function sendOverdueNotice($name, $phone, $period)
    {
        $message = "Hi {$name}, this is Seagold Dormitory. Your rent for the period {$period} is overdue. Please pay as soon as possible to avoid penalties. Thank you!";
        
        return self::send($phone, $message);
    }
}
