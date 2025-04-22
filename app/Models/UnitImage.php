<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UnitImage extends Model
{
    use HasFactory;

    protected $fillable = [
        'unit_code',
        'image_path',
    ];

    public function unit()
    {
        return $this->belongsTo(Unit::class, 'unit_code', 'unit_code');
    }
}
