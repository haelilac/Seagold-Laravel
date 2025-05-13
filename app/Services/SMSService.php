<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class SMSService
{

    /*
    public static function normalizeNumber($phone)
{
    $digits = preg_replace('/\D/', '', $phone); // Strip non-digits

    if (preg_match('/^9\d{9}$/', $digits)) {
        return '63' . $digits;
    }

    if (preg_match('/^63\d{10}$/', $digits)) {
        return $digits;
    }

    return null; // Invalid number
}
    */

    public static function normalizeNumber($phone)
    {
        $digits = preg_replace('/\D/', '', $phone); // Strip non-digits
    
        if (preg_match('/^63\d{10}$/', $digits)) {
            return $digits; // Already in correct format
        }
    
        if (preg_match('/^9\d{9}$/', $digits)) {
            return '0' . $digits; // Convert to 09...
        }
    
        if (preg_match('/^09\d{9}$/', $digits)) {
            return $digits; // Already correct local format
        }
    
        return null;
    }

public static function send($phone, $message)
{
    $normalized = self::normalizeNumber($phone);
    if (!$normalized) {
        Log::error("❌ Invalid phone number format: {$phone}");
        return false;
    }

    // 🛠️ ADD THESE LOGS:
    Log::info("☎️ Final normalized number: {$normalized}");
    Log::info("📨 Message to send: {$message}");

    try {
        $response = Http::post('https://api.semaphore.co/api/v4/messages', [
            'apikey' => env('SEMAPHORE_API_KEY'),
            'number' => $phone,
            'message' => $message,
            'sender_name' => 'SEAGOLD' // 👈 Added sender name
        ]);

        if ($response->successful()) {
            Log::info("✅ SMS sent to {$normalized}: {$message}");
            return true;
        } else {
            Log::error("❌ SMS failed for {$normalized}: " . $response->body());
            return false;
        }
    } catch (\Exception $e) {
        Log::error("❌ SMS Exception for {$normalized}: " . $e->getMessage());
        return false;
    }
}
    public static function sendBillNotice($name, $phone, $amount, $dueDate)
    {
        $formattedAmount = number_format($amount);
        $formattedDate = \Carbon\Carbon::parse($dueDate)->format('F j, Y');

        //$message = "Hi {$name}, this is Seagold Dormitory. We'd like to remind you that your rent of ₱{$formattedAmount} is due on {$formattedDate}. Please make sure to settle it on time. Thank you!";
        $message = "Hi {$name}, this is Seagold Dormitory.";
        return self::send($phone, $message);
    }

    public static function sendOverdueNotice($name, $phone, $period)
    {
        $message = "Hi {$name}, this is Seagold Dormitory. Your rent for the period {$period} is overdue. Please pay as soon as possible to avoid penalties. Thank you!";
        
        return self::send($phone, $message);
    }
}
