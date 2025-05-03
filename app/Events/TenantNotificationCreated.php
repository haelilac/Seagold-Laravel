<?php

namespace App\Events;

use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Queue\SerializesModels;

class TenantNotificationCreated implements ShouldBroadcast
{
    use InteractsWithSockets, SerializesModels;

    public $tenantId;

    public function __construct($tenantId)
    {
        $this->tenantId = $tenantId;
    }

    public function broadcastOn()
    {
        return new PrivateChannel('tenant.notifications.' . $this->tenantId);
    }

    public function broadcastAs()
    {
        return 'notification.created';
    }
}