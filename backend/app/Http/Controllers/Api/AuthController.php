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
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users,email',
            'password' => 'required|string|min:6',
            'tanggal_lahir' => 'required|date',
            'gender' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal gess',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            DB::table('users')->insert([
                'name' => $request->name,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'tanggal_lahir' => $request->tanggal_lahir,
                'gender' => $request->gender,
                'is_profile_completed' => false, // Default user baru wajib isi profil dulu gess
                'created_at' => Carbon::now(),
                'updated_at' => Carbon::now(),
                'is_personalized' => 0,
            ]);

            $user = DB::table('users')->where('email', $request->email)->first();

            return response()->json([
                'success' => true,
                'message' => 'Registrasi berhasil gess!',
                'user' => [
                    'id' => $user->id,
                    'nama' => $user->name,
                    'email' => $user->email,
<<<<<<< Updated upstream
                    'tanggal_lahir' => $user->tanggal_lahir,
                    'gender' => $user->gender,
                    'umur' => Carbon::parse($user->tanggal_lahir)->age,
                    'is_personalized' => $user->is_personalized,
=======
                    'is_profile_completed' => (bool)$user->is_profile_completed,
>>>>>>> Stashed changes
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
        $validator = Validator::make($request->all(), [
            'email' => 'required|string|email',
            'password' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['success' => false, 'message' => 'Email dan password wajib diisi!'], 422);
        }

        try {
            $user = DB::table('users')->where('email', $request->email)->first();

            if (!$user || !Hash::check($request->password, $user->password)) {
                return response()->json(['success' => false, 'message' => 'Email atau Password salah gess!'], 401);
            }

            return response()->json([
                'success' => true,
                'message' => 'Login berhasil!',
                'user' => [
                    'id' => $user->id,
                    'nama' => $user->name,
                    'email' => $user->email,
                    'tanggal_lahir' => $user->tanggal_lahir,
                    'gender' => $user->gender,
<<<<<<< Updated upstream
                    'umur' => Carbon::parse($user->password ? $user->tanggal_lahir : Carbon::now())->age,
                    'is_personalized' => $user->is_personalized,
=======
                    'is_profile_completed' => (bool)$user->is_profile_completed, // Dikirim balik berupa true/false asli
>>>>>>> Stashed changes
                ]
            ], 200);

        } catch (\Exception $e) {
            return response()->json(['success' => false, 'message' => 'Terjadi kesalahan server: ' . $e->getMessage()], 500);
        }
    }
}