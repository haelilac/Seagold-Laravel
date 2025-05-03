<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Broadcasting\PrivateChannel;

class NewTenantNotificationEvent implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public $tenantId;
    public $title;
    public $message;
    public $time;

    public $type; 

    public function __construct($tenantId, $title, $message, $time, $type = 'general')
    {
        $this->tenantId = $tenantId;
        $this->title = $title;
        $this->message = $message;
        $this->time = $time;
        $this->type = $type; 
    }
    public function broadcastWith()
{
    return [
        'tenantId' => $this->tenantId,
        'title' => $this->title,
        'message' => $this->message,
        'time' => $this->time,
        'type' => $this->type, // Include this in the payload
    ];
}

    public function broadcastOn()
    {
        return new PrivateChannel("tenant.notifications.{$this->tenantId}");
    }

    public function broadcastAs()
    {
        return 'tenant-notification';
    }
}