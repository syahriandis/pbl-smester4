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
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('email')->unique();
            $table->timestamp('email_verified_at')->nullable();
            $table->string('password');
            
            // Tambahan field kustom untuk aplikasi diabetes kamu gess
            $table->date('tanggal_lahir');
            $table->string('gender');
            $table->boolean('is_profile_completed')->default(false);
            $table->boolean('is_personalized')->default(false); // <--- Sekarang sudah digabung di sini gess
            
            // Field opsional / nullable yang nanti dilengkapi di halaman profil
            $table->integer('tinggi_badan')->nullable();
            $table->integer('berat_badan')->nullable();
            $table->integer('gula_darah')->nullable();
            $table->string('alergi')->nullable();

            $table->rememberToken();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
    }
};  