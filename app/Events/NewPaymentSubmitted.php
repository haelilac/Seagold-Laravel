<?php

// app/Events/NewPaymentSubmitted.php
namespace App\Events;

use App\Models\Payment;
use Illuminate\Broadcasting\Channel;
use Illuminate\Queue\SerializesModels;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;

class NewPaymentSubmitted implements ShouldBroadcast
{
    use InteractsWithSockets, SerializesModels;

    public $payment;

    public function __construct(Payment $payment)
    {
        $this->payment = $payment;
    }

    public function broadcastOn()
    {
        return new Channel('admin.payments');
    }

    public function broadcastAs()
    {
        return 'new.payment';
    }
}
