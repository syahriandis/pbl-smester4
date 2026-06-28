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
        Schema::create('user_preferences', function (Blueprint $table) {
            $table->id();
            
            // Relasi ke tabel users. Kalau user dihapus, data preferensi otomatis ikut terhapus (cascade)
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            
            // Kolom text untuk menampung format JSON string dari PreferenceController
            $table->text('makanan_suka')->nullable();
            $table->text('alergi_makanan')->nullable();
            
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('user_preferences');
    }
};