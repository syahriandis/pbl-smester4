<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;

class ProfileController extends Controller
{
    // LOAD PROFILE (GABUNGAN DATA USER & ALERGI)
    public function loadProfile(int $id)
    {
        $user = DB::table('users')
            ->leftJoin('user_preferences', 'users.id', '=', 'user_preferences.user_id')
            ->where('users.id', $id)
            ->select('users.*', 'user_preferences.alergi_makanan') // Mengambil kolom alergi_makanan
            ->first();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'User tidak ditemukan'
            ], 404);
        }

        // Mengubah format array JSON database menjadi String siap pakai di Flutter (cth: "Udang, Susu")
        $alergiArray = json_decode($user->alergi_makanan ?? '[]', true) ?? [];
        $alergiString = implode(', ', $alergiArray);

        return response()->json([
            'success' => true,
            'user' => [
                'id' => $user->id,
                'nama' => $user->name, 
                'email' => $user->email,
                'tanggal_lahir' => $user->tanggal_lahir,
                'umur' => $user->tanggal_lahir ? Carbon::parse($user->tanggal_lahir)->age : null,
                'gender' => $user->gender,
                'tinggi_badan' => $user->tinggi_badan,
                'berat_badan' => $user->berat_badan,
                'gula_darah' => $user->gula_darah, 
                'alergi' => $alergiString, // Dikirim berupa string teks biasa
            ]
        ]);
    }

    // UPDATE PROFILE
    public function updateProfile(Request $request, int $id) 
    {
        $validator = Validator::make($request->all(), [
            'nama' => 'required|string|max:255',       
            'tinggi_badan' => 'required|integer',
            'berat_badan' => 'required|integer',
            'gula_darah' => 'required|integer',        
            'alergi' => 'nullable|string', // Menerima teks string dari halaman edit profil Flutter
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => $validator->errors()->first(),
            ], 422);
        }

        try {
            // 1. Update data dasar ke tabel users
            DB::table('users')->where('id', $id)->update([
                'name' => $request->nama,                  
                'tinggi_badan' => $request->tinggi_badan,
                'berat_badan' => $request->berat_badan,
                'gula_darah' => $request->gula_darah,      
                'updated_at' => now(),
            ]);

            // 2. Mengubah teks string kembali menjadi format array JSON database
            $alergiString = $request->alergi ?? '';
            $alergiArray = $alergiString != '' ? array_map('trim', explode(',', $alergiString)) : [];

            DB::table('user_preferences')->updateOrInsert(
                ['user_id' => $id],
                [
                    'alergi_makanan' => json_encode($alergiArray), // Disimpan sebagai JSON array gess
                    'updated_at' => now()
                ]
            );

            // Ambil data gabungan terbaru untuk respon balik ke Flutter
            $userUpdated = DB::table('users')
                ->leftJoin('user_preferences', 'users.id', '=', 'user_preferences.user_id')
                ->where('users.id', $id)
                ->select('users.*', 'user_preferences.alergi_makanan')
                ->first();

            $alergiTerbaru = implode(', ', json_decode($userUpdated->alergi_makanan ?? '[]', true) ?? []);

            return response()->json([
                'success' => true,
                'message' => 'Profil berhasil diperbarui',
                'user' => [
                    'id' => $userUpdated->id,
                    'nama' => $userUpdated->name,
                    'email' => $userUpdated->email,
                    'tanggal_lahir' => $userUpdated->tanggal_lahir,
                    'umur' => $userUpdated->tanggal_lahir ? Carbon::parse($userUpdated->tanggal_lahir)->age : null,
                    'gender' => $userUpdated->gender,
                    'tinggi_badan' => $userUpdated->tinggi_badan,
                    'berat_badan' => $userUpdated->berat_badan,
                    'gula_darah' => $userUpdated->gula_darah, 
                    'alergi' => $alergiTerbaru,          
                ]
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }
}