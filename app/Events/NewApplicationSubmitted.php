<?php

namespace App\Events;

use App\Models\Application;
use Illuminate\Broadcasting\Channel;
use Illuminate\Queue\SerializesModels;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class NewApplicationSubmitted implements ShouldBroadcast
{
    use InteractsWithSockets, SerializesModels;

    public $application;

    public function __construct(Application $application)
    {
        $this->application = $application;
    }

    public function broadcastOn()
    {
        return new Channel('admin.applications'); // 👈 Echo will listen here
    }

    public function broadcastAs()
    {
        return 'new.application';
    }
}
