<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\User; // ✅ Make sure User model is imported!

class AmenityRequest extends Model
{
    use HasFactory; // ✅ Include this, best practice!

    protected $fillable = ['tenant_id', 'amenity_type', 'status'];

    /**
     * Get the tenant (user) who made this amenity request.
     */
    public function tenant()
    {
        return $this->belongsTo(User::class, 'tenant_id');
    }
}
