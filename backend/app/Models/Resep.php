<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Resep extends Model
{
    protected $table = 'reseps';

    protected $fillable = [
        'nama',
        'kategori',
        'gambar',
        'komposisi',
        'cara',
        'gula',
        'kalori',
        'protein',
        'lemak',
        'karbo',
        'alergi',
    ];
}