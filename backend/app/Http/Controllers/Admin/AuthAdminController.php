<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Admin;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class AuthAdminController extends Controller
{
    public function showLogin()
    {
        return view('admin.login');
    }

    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $admin = Admin::where('email', $request->email)->first();

        if (!$admin || !Hash::check($request->password, $admin->password)) {
            return back()->with('error', 'Email atau password salah');
        }

        session([
            'admin_login' => true,
            'admin_id' => $admin->id,
            'admin_nama' => $admin->nama,
        ]);

        return redirect('/admin/dashboard');
    }

    public function logout()
    {
        session()->flush();

        return redirect('/admin/login');
    }
}