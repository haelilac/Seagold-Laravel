<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class MaintenanceRequest extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'category',
        'description',
        'status',
        'schedule',
    ];

    public function unit()
{
    return $this->belongsTo(Unit::class);
}
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function files() {
        return $this->hasMany(MaintenanceFile::class);
    }
}
