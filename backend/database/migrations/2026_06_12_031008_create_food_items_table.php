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

            $table->string('nama');

            $table->string('gambar')->nullable();

            $table->string('takaran');

            $table->enum('kategori', [
                'minuman',
                'snack'
            ]);

            $table->double('kalori')->default(0);
            $table->double('protein')->default(0);
            $table->double('lemak')->default(0);
            $table->double('karbo')->default(0);

            // baru
            $table->string('alergi')->nullable();

            $table->double('gula')->default(0);

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