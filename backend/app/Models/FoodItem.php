<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class FoodItem extends Model
{
    protected $table = 'food_items';

    protected $fillable = [
        'nama',
        'gambar',
        'takaran',
        'kategori',
        'kalori',
        'protein',
        'lemak',
        'karbo',
        'gula',
    ];
}