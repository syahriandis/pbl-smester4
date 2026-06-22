<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Resep extends Model
{
    use HasFactory;

    // Nama tabel di database Laravel (defaultnya plural/jamak)
    protected $table = 'reseps';

    // Kolom-kolom yang boleh diisi
    protected $fillable = [
        'nama',
        'gambar',
        'komposisi',
        'cara'
    ];
}