<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;

class AuthController extends Controller
{
    // =========================
    // REGISTER
    // =========================
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'username' => 'required',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|min:6',
            'umur' => 'nullable|integer',
            'jenis_kelamin' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => $validator->errors()->first(),
            ], 422);
        }

        DB::table('users')->insert([
            'username' => $request->username,
            'email' => $request->email,
            'PASSWORD' => Hash::make($request->password),
            'umur' => $request->umur,
            'jenis_kelamin' => $request->jenis_kelamin,
        ]); 

        return response()->json([
            'success' => true,
            'message' => 'Register berhasil',
        ]);
    }

    // =========================
    // LOGIN
    // =========================
    public function login(Request $request)
    {
        $user = DB::table('users')
            ->where('email', $request->email)
            ->first();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Email tidak ditemukan',
            ]);
        }

        if (!Hash::check($request->password, $user->PASSWORD)) {
            return response()->json([
                'success' => false,
                'message' => 'Password salah',
            ]);
        }

        return response()->json([
            'success' => true,
            'message' => 'Login berhasil',
            'user' => $user,
        ]);
    }
}