<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\AuthAdminController;
use App\Http\Controllers\Admin\PenggunaController;
use App\Http\Controllers\Admin\DashboardController;

Route::get('/', function () {
    return redirect('/admin/login');
});

Route::get('/admin/login', [AuthAdminController::class, 'showLogin']);
Route::post('/admin/login', [AuthAdminController::class, 'login']);

Route::get('/admin/dashboard', function () {
    if (!session('admin_login')) {
        return redirect('/admin/login');
    }

    return view('admin.dashboard');
});

Route::get('/admin/logout', [AuthAdminController::class, 'logout']);

Route::get('/admin/pengguna', [PenggunaController::class, 'index']);

Route::get('/admin/dashboard', function () {
    if (!session('admin_login')) {
        return redirect('/admin/login');
    }

    return app(DashboardController::class)->index();
});