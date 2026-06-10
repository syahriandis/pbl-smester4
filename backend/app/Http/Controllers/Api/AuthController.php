<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;

class AuthController extends Controller
{
    // --------------------------------------------------------
    // API REGISTER
    // --------------------------------------------------------
    public function register(Request $request)
    {
        // 1. Validasi Input dari Flutter
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users,email',
            'password' => 'required|string|min:6',
            'tanggal_lahir' => 'required|date',
            'gender' => 'required|string',
        ]);

        // Jika validasi gagal, kirim pesan error ke Flutter
        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal gess',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            // 2. Simpan ke database menggunakan Query Builder
            DB::table('users')->insert([
                'name' => $request->name,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'tanggal_lahir' => $request->tanggal_lahir,
                'gender' => $request->gender,
                'created_at' => Carbon::now(),
                'updated_at' => Carbon::now(),
            ]);

            // Ambil data user yang barusan didaftarkan untuk dikirim balik
            $user = DB::table('users')->where('email', $request->email)->first();

            return response()->json([
                'success' => true,
                'message' => 'Registrasi berhasil gess!',
                'user' => [
                    'id' => $user->id,
                    'nama' => $user->name,
                    'email' => $user->email,
                    'tanggal_lahir' => $user->tanggal_lahir,
                    'gender' => $user->gender,
                    'umur' => Carbon::parse($user->tanggal_lahir)->age, 
                ]
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan server: ' . $e->getMessage()
            ], 500);
        }
    }

    // --------------------------------------------------------
    // API LOGIN
    // --------------------------------------------------------
    public function login(Request $request)
    {
        // 1. Validasi Input Login
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email',
            'password' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Email dan password wajib diisi!',
            ], 422);
        }

        try {
            // 2. Cari user berdasarkan email
            $user = DB::table('users')->where('email', $request->email)->first();

            // 3. Cek apakah user ada dan password-nya cocok
            if (!$user || !Hash::check($request->password, $user->password)) {
                return response()->json([
                    'success' => false,
                    'message' => 'Email atau Password salah gess!',
                ], 401);
            }

            // 4. Jika sukses, kirim data user ke Flutter
            return response()->json([
                'success' => true,
                'message' => 'Login berhasil!',
                'user' => [
                    'id' => $user->id,
                    'nama' => $user->name,
                    'email' => $user->email,
                    'tanggal_lahir' => $user->tanggal_lahir,
                    'gender' => $user->gender,
                    'umur' => Carbon::parse($user->password ? $user->tanggal_lahir : Carbon::now())->age,
                ]
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan server: ' . $e->getMessage()
            ], 500);
        }
    }
}