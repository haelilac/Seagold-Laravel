<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;
use App\Models\Unit;

class UnitUpdated implements ShouldBroadcast
{
    use InteractsWithSockets, SerializesModels;

    public $unit;

    public function __construct(Unit $unit)
    {
        $this->unit = $unit;
    }

    public function broadcastOn()
    {
        return new \Illuminate\Broadcasting\Channel('admin.units');
    }

    public function broadcastAs()
    {
        return 'unit.updated';
    }
}
