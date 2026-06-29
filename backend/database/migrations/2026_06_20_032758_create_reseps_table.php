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
        if (!Schema::hasTable('reseps')) {

            Schema::create('reseps', function (Blueprint $table) {

                $table->id();

                $table->string('nama');

                $table->enum('kategori', [
                    'sarapan',
                    'siang',
                    'malam'
                ])->default('sarapan');

                $table->string('gambar');

                $table->text('komposisi');

                $table->text('cara');

                // Sesuai urutan yang kamu mau
                $table->double('gula')->default(0);
                $table->double('kalori')->default(0);
                $table->double('protein')->default(0);
                $table->double('lemak')->default(0);
                $table->double('karbo')->default(0);

                $table->string('alergi')->nullable();

                $table->timestamps();
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