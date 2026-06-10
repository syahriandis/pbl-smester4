<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserPreference extends Model
{
    protected $fillable = [
        'user_id',
        'makanan_suka',
        'alergi_makanan',
    ];

    protected $casts = [
        'makanan_suka' => 'array',
        'alergi_makanan' => 'array',
    ];
}

