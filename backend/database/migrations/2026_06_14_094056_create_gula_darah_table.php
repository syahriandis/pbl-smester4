<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Cek dulu apakah tabel sudah ada di database agar tidak error
        if (!Schema::hasTable('gula_darah')) {
            Schema::create('gula_darah', function (Blueprint $table) {
                $table->id();

                $table->foreignId('id_user')
                    ->constrained('users')
                    ->onDelete('cascade');

                $table->date('tanggal');
                $table->enum('waktu', ['Pagi', 'Siang', 'Malam']);
                $table->integer('nilai_gula');

                $table->timestamps();
            });
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('gula_darah');
    }
};