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
        Schema::create('food_items', function (Blueprint $table) {
            $table->id();
            $table->string('nama'); // Nama makanan atau minuman
            $table->string('gambar')->nullable(); // Path atau URL gambar (boleh kosong/nullable)
            $table->string('takaran'); // Contoh: "250 ml", "30 g"
            $table->enum('kategori', ['minuman', 'snack']); // Menggunakan enum sebagai pemisah tab di Flutter gess
            
            // Kandungan Makronutrisi & Energi (Menggunakan float agar mendukung angka desimal)
            $table->float('kalori')->default(0);  // Satuan: kcal
            $table->float('protein')->default(0); // Satuan: gram
            $table->float('lemak')->default(0);   // Satuan: gram
            $table->float('karbo')->default(0);   // Satuan: gram
            $table->float('gula')->default(0);    // Satuan: gram
            
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('food_items');
    }
};