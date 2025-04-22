<?php

namespace App\Events;

use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Broadcasting\Channel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Queue\SerializesModels;

class NewNotificationEvent implements ShouldBroadcast
{
    use InteractsWithSockets, SerializesModels;

    public $message;
    public $time;

    public function __construct($message, $time)
    {
        $this->message = $message;
        $this->time = $time;
    }

    public function broadcastOn()
    {
        return new Channel('notifications'); // 👈 same as the one you subscribe to
    }

    public function broadcastAs()
    {
        return 'new-notification';
    }

    
}
