<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class MaintenanceFile extends Model
{
    protected $fillable = ['maintenance_request_id', 'file_path', 'cloudinary_public_id'];

    public function request() {
        return $this->belongsTo(MaintenanceRequest::class, 'maintenance_request_id');
    }
}
