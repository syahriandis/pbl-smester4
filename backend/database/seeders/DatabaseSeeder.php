<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        User::factory()->create([
            'name' => 'Test User',
            'email' => 'test@example.com',
            'password' => bcrypt('password'),

            'tanggal_lahir' => '2000-01-01',
            'gender' => 'Laki-laki',

            'tinggi_badan' => 170,
            'berat_badan' => 65,
            'gula_darah' => 100,
            'alergi' => null,

            'is_profile_completed' => 1,
            'is_personalized' => 1,
        ]);
    }
}