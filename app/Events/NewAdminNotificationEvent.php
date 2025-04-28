<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Queue\SerializesModels;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class NewAdminNotificationEvent implements ShouldBroadcast
{
    use InteractsWithSockets, SerializesModels;

    public $message;
    public $type;
    public $time;

    public function __construct($message, $type = 'general', $time = null)
    {
        $this->message = $message;
        $this->type = $type;
        $this->time = $time ?? now()->format('M d, Y - h:i A');
    }

    public function broadcastOn()
    {
        return new Channel('admin.notifications');
    }

    public function broadcastAs()
    {
        return 'admin.notification';
    }

    public function broadcastWith()
    {
        return [
            'message' => $this->message,
            'type' => $this->type,
            'time' => $this->time,
        ];
    }

    public function followUp($id)
{
    $maintenanceRequest = MaintenanceRequest::with('user.unit')->findOrFail($id);

    $tenantName = $maintenanceRequest->user->name;
    $unitCode = optional($maintenanceRequest->user->unit)->unit_code;

    // Send follow-up notification
    event(new NewAdminNotificationEvent(
        "🔔 Follow-up Reminder: $tenantName (Unit: $unitCode) is requesting an update on Maintenance ID #$id",
        'maintenance_follow_up'
    ));

    return response()->json(['message' => 'Follow-up notification sent to admin.']);
}
}

