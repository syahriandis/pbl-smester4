<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Cek dulu apakah tabel sudah ada di database agar tidak error
        if (!Schema::hasTable('reseps')) {
            Schema::create('reseps', function (Blueprint $table) {
                $table->id(); // Ini otomatis Integer PRIMARY KEY AUTO_INCREMENT gess
                $table->string('nama'); // Menyimpan nama masakan resep
                $table->string('gambar'); // Menyimpan path/url gambar masakan
                $table->text('komposisi'); // Detail takaran bahan masakan
                $table->text('cara'); // Langkah-langkah cara memasak
                $table->timestamps(); // Otomatis membuat kolom created_at dan updated_at
            });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('reseps');
    }
};