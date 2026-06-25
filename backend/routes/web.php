<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\AuthAdminController;
use App\Http\Controllers\Admin\PenggunaController;
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\GulaDarahAdminController;
use App\Http\Controllers\Admin\FoodItemController;
use App\Http\Controllers\Admin\ResepController;


Route::get('/', function () {
    return redirect('/admin/login');
});

Route::get('/admin/login', [AuthAdminController::class, 'showLogin']);
Route::post('/admin/login', [AuthAdminController::class, 'login']);

Route::get('/admin/logout', [AuthAdminController::class, 'logout']);

Route::get('/admin/pengguna', [PenggunaController::class, 'index']);

Route::get('/admin/dashboard', function () {
    if (!session('admin_login')) {
        return redirect('/admin/login');
    }

    return app(DashboardController::class)->index();
});

Route::get('/admin/gula-darah', function () {
    if (!session('admin_login')) {
        return redirect('/admin/login');
    }

    return app(GulaDarahAdminController::class)->index();
});

Route::get('/admin/dashboard', function () {
    if (!session('admin_login')) {
        return redirect('/admin/login');
    }

    return app(DashboardController::class)->index();
});

Route::get('/admin/food-items', [FoodItemController::class, 'index']);
Route::get('/admin/food-items/create', [FoodItemController::class, 'create']);
Route::post('/admin/food-items', [FoodItemController::class, 'store']);
Route::delete('/admin/food-items/{id}', [FoodItemController::class, 'destroy']);

Route::get('/admin/reseps', [ResepController::class, 'index']);
Route::get('/admin/reseps/create', [ResepController::class, 'create']);
Route::post('/admin/reseps', [ResepController::class, 'store']);
Route::delete('/admin/reseps/{id}', [ResepController::class, 'destroy']);