<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Payment extends Model
{
    use SoftDeletes;
    protected $dates = ['deleted_at'];

    use HasFactory;

    protected $table = 'payments';

    protected $fillable = [
        'user_id',
        'unit_id',
        'amount',
        'payment_type',
        'payment_method',
        'reference_number',
        'receipt_path',
        'status',
        'payment_period',
        'payment_date',
        'remaining_balance',
    ];
    
    

    protected $casts = [
        'payment_date' => 'datetime',
    ];

    // Relationships
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function unit()
    {
        return $this->belongsTo(Unit::class, 'unit_id');
    }
}
