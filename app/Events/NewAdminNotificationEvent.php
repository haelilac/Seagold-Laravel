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
}

