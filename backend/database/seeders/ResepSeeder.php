<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class ResepSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('reseps')->insert([
            [
                'nama' => 'Sup Sayur Sehat',
                'gambar' => 'assets/sup.jpg', // Nanti sesuaikan kalau gambarnya diambil dari url storage Laravel
                'komposisi' => 'Wortel 100 gram (diiris), Kol 50 gram, Kentang 1 buah ukuran sedang, Air 400 ml, Garam & lada secukupnya.',
                'cara' => "1. Rebus air hingga mendidih.\n2. Masukkan kentang dan wortel terlebih dahulu karena teksturnya keras.\n3. Setelah agak empuk, masukkan kol dan bumbu.\n4. Masak hingga matang dan sajikan selagi hangat.",
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'nama' => 'Ayam Dada Rebus',
                'gambar' => 'assets/ayam.jpg',
                'komposisi' => 'Dada ayam tanpa kulit 1 potong (sekitar 150 gram), Air 500 ml, Bawang putih 2 siung (digeprek), Jahe 1 ruas jari.',
                'cara' => "1. Didihkan air bersama bawang putih dan jahe untuk menghilangkan bau amis.\n2. Masukkan dada ayam.\n3. Rebus dengan api sedang selama 15-20 menit hingga matang sempurna tanpa minyak.",
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'nama' => 'Nasi Merah & Ayam Panggang',
                'gambar' => 'assets/nasimerah.jpg',
                'komposisi' => 'Nasi merah 1 mangkok kecil (100 gram), Fillet paha ayam tanpa kulit 1 potong (100 gram), Kecap asin rendah natrium 1 sdt.',
                'cara' => "1. Siapkan nasi merah yang sudah matang.\n2. Lumuri ayam dengan kecap asin, lalu panggang di atas teflon anti lengket tanpa minyak hingga kedua sisi matang kecokelatan.\n3. Sajikan bersama di satu piring.",
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
}