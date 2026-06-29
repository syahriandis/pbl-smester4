<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\PreferenceController;
use App\Http\Controllers\Api\FoodController;
use App\Http\Controllers\Api\GulaDarahController;
use App\Http\Controllers\Api\ResepController;
use App\Http\Controllers\Api\RekomendasiController;

// 1. OTENTIKASI (AUTH)
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// 2. MANAJEMEN PROFIL (USER PROFILE)
Route::get('/user/{id}', [ProfileController::class, 'loadProfile']);
Route::post('/profile/update/{id}', [ProfileController::class, 'updateProfile']);

// 3. PREFERENSI MAKANAN & ALERGI (USER PREFERENCES)
Route::post('/save-preference', [PreferenceController::class, 'savePreference']);
Route::get('/preference/{user_id}', [PreferenceController::class, 'getPreference']); // <-- FIX: Menggunakan user_id

// 4. MANAJEMEN NUTRISI (FOOD, SNACK, & MACRONUTRIENTS)
Route::get('/food-items', [FoodController::class, 'getAllFood']);
Route::post('/food-items', [FoodController::class, 'storeFood']);

// 5. MANAJEMEN GULA DARAH
Route::get('/gula-darah/{id_user}', [GulaDarahController::class, 'index']);
Route::post('/gula-darah', [GulaDarahController::class, 'store']);
Route::delete('/gula-darah/{id}', [GulaDarahController::class, 'destroy']);

// 6. KATALOG RESEP DIABETES
Route::get('/resep', [ResepController::class, 'index']);

// Endpoint untuk mengambil rekomendasi berdasarkan ID User
Route::get('/menu-rekomendasi/{id_user}', [RekomendasiController::class, 'getRekomendasi']);

