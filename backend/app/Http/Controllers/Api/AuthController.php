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
    // REGISTER
    public function register(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email',
            'password' => 'required|min:6',
            'tanggal_lahir' => 'required|date_format:Y-m-d', 
            'gender' => 'required|string', 
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => $validator->errors()->first(),
            ], 422);
        }

        try {
            DB::table('users')->insert([
                'name' => $request->name,
                'email' => $request->email,
                'password' => Hash::make($request->password), 
                'tanggal_lahir' => $request->tanggal_lahir,
                'gender' => $request->gender,
                'tinggi_badan' => null,
                'berat_badan' => null,
                'created_at' => now(),
                'updated_at' => now(),
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Registrasi berhasil',
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menyimpan ke database: ' . $e->getMessage(),
            ], 500);
        }
    }

    // LOGIN
    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => $validator->errors()->first(),
            ], 422);
        }

        $user = DB::table('users')->where('email', $request->email)->first();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Email tidak ditemukan',
            ], 404);
        }

        if (!Hash::check($request->password, $user->password)) {
            return response()->json([
                'success' => false,
                'message' => 'Password salah',
            ], 401);
        }

        // Kalkulasi umur otomatis berdasarkan tanggal lahir
        $umurOtomatis = Carbon::parse($user->tanggal_lahir)->age;

        return response()->json([
            'success' => true,
            'message' => 'Login berhasil',
            'user' => [
                'id' => $user->id,
                'nama' => $user->name,
                'email' => $user->email,
                'tanggal_lahir' => $user->tanggal_lahir,
                'umur' => $umurOtomatis, 
                'gender' => $user->gender,
                'tinggi_badan' => $user->tinggi_badan,
                'berat_badan' => $user->berat_badan,
            ],
        ]);
    }

    // LOAD PROFILE TERBARU
    public function loadProfile($id)
    {
        $user = DB::table('users')->where('id', $id)->first();
        if (!$user) {
            return response()->json(['success' => false, 'message' => 'User tidak ditemukan'], 404);
        }

        return response()->json([
            'success' => true,
            'user' => [
                'id' => $user->id,
                'nama' => $user->name,
                'email' => $user->email,
                'tanggal_lahir' => $user->tanggal_lahir,
                'umur' => Carbon::parse($user->tanggal_lahir)->age,
                'gender' => $user->gender,
                'tinggi_badan' => $user->tinggi_badan,
                'berat_badan' => $user->berat_badan,
            ]
        ]);
    }

    // UPDATE PROFILE (TINGGI & BERAT)
    public function updateProfile(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'tinggi_badan' => 'required|integer',
            'berat_badan' => 'required|integer',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => $validator->errors()->first(),
            ], 422);
        }

        DB::table('users')->where('id', $id)->update([
            'tinggi_badan' => $request->tinggi_badan,
            'berat_badan' => $request->berat_badan,
            'updated_at' => now(),
        ]);

        $user = DB::table('users')->where('id', $id)->first();

        return response()->json([
            'success' => true,
            'message' => 'Profil berhasil diperbarui',
            'user' => [
                'id' => $user->id,
                'nama' => $user->name,
                'email' => $user->email,
                'tanggal_lahir' => $user->tanggal_lahir,
                'umur' => Carbon::parse($user->tanggal_lahir)->age,
                'gender' => $user->gender,
                'tinggi_badan' => $user->tinggi_badan,
                'berat_badan' => $user->berat_badan,
            ]
        ]);
    }
}