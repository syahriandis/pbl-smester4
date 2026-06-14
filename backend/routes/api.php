<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\PreferenceController;
use App\Http\Controllers\Api\GulaDarahController;

// AUTH
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// PROFILE (Diubah ke ProfileController)
Route::get('/user/{id}', [ProfileController::class, 'loadProfile']);
Route::post('/profile/update/{id}', [ProfileController::class, 'updateProfile']);

// PREFERENCE
Route::post('/save-preference', [PreferenceController::class, 'savePreference']);
Route::get('/preference/{userId}', [PreferenceController::class, 'getPreference']);

Route::get('/gula-darah/{id_user}', [GulaDarahController::class, 'index']);
Route::post('/gula-darah', [GulaDarahController::class, 'store']);
Route::delete('/gula-darah/{id}', [GulaDarahController::class, 'destroy']);