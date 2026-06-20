<?php

use Illuminate\Support\Facades\Route;
// Import semua controller kamu di atas gess biar gak typo dan kebaca sistem
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\PreferenceController;
use App\Http\Controllers\Api\FoodController;

// 1. OTENTIKASI (AUTH)
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// 2. MANAJEMEN PROFIL (USER PROFILE)
Route::get('/user/{id}', [ProfileController::class, 'loadProfile']);
Route::post('/profile/update/{id}', [ProfileController::class, 'updateProfile']);

// 3. PREFERENSI MAKANAN & ALERGI (USER PREFERENCES)
Route::post('/save-preference', [PreferenceController::class, 'savePreference']);
Route::get('/preference/{userId}', [PreferenceController::class, 'getPreference']);

// 4. MANAJEMEN NUTRISI (FOOD, SNACK, & MACRONUTRIENTS)
Route::get('/food-items', [FoodController::class, 'getAllFood']);
Route::post('/food-items', [FoodController::class, 'storeFood']);