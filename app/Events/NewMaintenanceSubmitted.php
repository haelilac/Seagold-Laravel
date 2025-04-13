<?php

namespace App\Events;

use App\Models\MaintenanceRequest;
use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class NewMaintenanceSubmitted implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $request;

    /**
     * Create a new event instance.
     */
    public function __construct(MaintenanceRequest $request)
    {
        $this->request = $request->load('user.unit');
    }

    /**
     * Get the channels the event should broadcast on.
     */
    public function broadcastOn(): Channel
    {
        return new Channel('admin.maintenance');
    }

    /**
     * Event name for frontend listening.
     */
    public function broadcastAs(): string
    {
        return 'new.maintenance';
    }
}
