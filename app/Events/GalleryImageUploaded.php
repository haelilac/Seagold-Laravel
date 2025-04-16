<?php

namespace App\Events;

use Illuminate\Broadcasting\Channel;
use Illuminate\Queue\SerializesModels;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PresenceChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class GalleryImageUploaded implements ShouldBroadcast
{
    use InteractsWithSockets, SerializesModels;

    public $image;

    public function __construct($image)
    {
        $this->image = $image;
    }

    public function broadcastOn()
    {
        return new Channel('gallery');
    }

    public function broadcastWith()
    {
        return [
            'image' => $this->image
        ];
    }
}
