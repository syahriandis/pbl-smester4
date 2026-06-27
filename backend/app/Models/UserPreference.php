<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class UserPreference extends Model
{
    use HasFactory;

    // Pastikan nama tabelnya eksplisit gess
    protected $table = 'user_preferences';

    // FIX: Disamakan pakai 'suka' agar match dengan Controller & Database kamu
    protected $fillable = [
        'user_id',
        'suka', // <-- Diubah dari makanan_suka menjadi suka
        'alergi_makanan',
    ];

    // Otomatis convert JSON text dari database menjadi Array PHP pas dipanggil
    protected $casts = [
        'suka' => 'array', // <-- Diubah dari makanan_suka menjadi suka
        'alergi_makanan' => 'array',
    ];

    /**
     * Hubungan relasi ke model User
     */
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'id');
    }
}