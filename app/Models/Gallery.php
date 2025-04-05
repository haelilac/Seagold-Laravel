<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Gallery extends Model
{
    use HasFactory;

    protected $appends = ['image_url'];

public function getImageUrlAttribute()
{
    return $this->image_path;
}
    protected $table = 'gallery';
    protected $fillable = [
        'image_path',
        'title',
        'description',
        'category',
    ];
}
