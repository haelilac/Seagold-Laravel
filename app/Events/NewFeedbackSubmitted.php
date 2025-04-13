<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class NewFeedbackSubmitted
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $feedback;

    public function __construct($feedback)
    {
        $this->feedback = $feedback;
    }
    
    public function broadcastOn()
    {
        return ['feedback'];
    }
    
    public function broadcastAs()
    {
        return 'new.feedback';
    }
}
