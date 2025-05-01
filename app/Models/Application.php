<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Application extends Model
{
    use HasFactory;

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    protected $fillable = [
        'first_name',
        'last_name',
        'middle_name',
        'email',
        'birthdate',
        'facebook_profile',
        'contact_number',
        'occupation',
        'check_in_date',
        'duration',
        'reservation_details',
        'receipt_url', 
        'unit_id',
        'id_type',
        'valid_id',
        'status',
        'stay_type',
        'reference_number',
        'payment_amount',
        'set_price',
        'house_number',  
        'street',        
        'barangay',      
        'city',          
        'province',      
        'zip_code',      
    ];
    
}
