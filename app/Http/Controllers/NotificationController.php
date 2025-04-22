<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Notification;
use Illuminate\Support\Facades\DB;
use App\Events\NewNotificationEvent;
use Carbon\Carbon;

class NotificationController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();
    
        $notificationsQuery = Notification::query();
    
        if ($user->role === 'admin') {
            $notificationsQuery->where(function ($query) use ($user) {
                $query->whereNull('user_id') // Global notifications
                      ->orWhere('user_id', $user->id);
            });
        } else {
            $notificationsQuery->where('user_id', $user->id);
        }
    
        $notifications = $notificationsQuery->orderBy('created_at', 'desc')->get();
    
        // Format the notifications with readable date/time
        $formatted = $notifications->map(function ($notif) {
            return [
                'id' => $notif->id,
                'message' => $notif->message,
                'type' => $notif->type,
                'read' => $notif->is_read,
                'created_at' => $notif->created_at->format('M d, Y - h:i A'), // 👈 Example: Apr 19, 2025 - 02:45 PM
                'relative_time' => $notif->created_at->diffForHumans(), // 👈 Example: "3 minutes ago"
            ];
        });
    
        return response()->json($formatted);
    }
    
    public function markAsRead($id)
    {
        $notification = \App\Models\Notification::findOrFail($id);
        $notification->is_read = true;
        $notification->save();
    
        return response()->json(['message' => 'Notification marked as read']);
    }
    

    public function destroy($id)
    {
        $notification = Notification::findOrFail($id);
    
        if ($notification->user_id === auth()->id()) {
            $notification->delete();
            return response()->json(['message' => 'Notification deleted successfully']);
        }
    
        return response()->json(['error' => 'Unauthorized'], 403);
    }
    
    public function createBookingNotification($bookingId)
    {
        $booking = DB::table('booked_tour')->where('id', $bookingId)->first();
    
        if (!$booking) {
            return response()->json(['error' => 'Booking not found'], 404);
        }
    
        $notification = Notification::create([
            'user_id' => auth()->id(),
            'message' => "New booking made by {$booking->name} for {$booking->date_booked} at {$booking->time_slot}.",
            'is_read' => false,
        ]);
    
        broadcast(new NewNotificationEvent(
            $notification->message,
            Carbon::now()->format('M d, Y - h:i A')
        ))->toOthers();
    
        return response()->json(['message' => 'Notification created successfully']);
    }
    
}
