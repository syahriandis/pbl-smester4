<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class GulaDarah extends Model
{
    protected $table = 'gula_darah';

    protected $fillable = [
        'id_user',
        'tanggal',
        'waktu',
        'nilai_gula',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'id_user');
    }
}