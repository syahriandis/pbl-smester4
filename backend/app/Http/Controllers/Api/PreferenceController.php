<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;

class PreferenceController extends Controller
{
    // --------------------------------------------------------
    // 1. POST: SIMPAN PREFERENSI MAKANAN & ALERGI
    // --------------------------------------------------------
    public function savePreference(Request $request)
    {
        // Validasi input array yang dikirim oleh Flutter
        $validator = Validator::make($request->all(), [
            'user_id' => 'required',
            'makanan_suka' => 'nullable|array',
            'alergi_makanan' => 'nullable|array',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Format preferensi tidak valid gess',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            // Mengubah array dari Flutter menjadi JSON string (Sangat aman untuk tipe longtextutf8mb4_bin)
            $sukaJson = $request->has('makanan_suka') ? json_encode($request->makanan_suka) : json_encode([]);
            $alergiJson = $request->has('alergi_makanan') ? json_encode($request->alergi_makanan) : json_encode([]);

            // NAMA TABEL SUDAH DISESUAIKAN DENGAN DATABASE KAMU GESS!
            $namaTabel = 'user_preferences'; 

            // Cek apakah user_id ini sudah pernah ada datanya
            $cekData = DB::table($namaTabel)->where('user_id', $request->user_id)->first();

            if ($cekData) {
                // Jika sudah ada, lakukan UPDATE
                DB::table($namaTabel)
                    ->where('user_id', $request->user_id)
                    ->update([
                        'makanan_suka' => $sukaJson,
                        'alergi_makanan' => $alergiJson,
                        'updated_at' => Carbon::now(),
                    ]);
                $pesan = 'Preferensi berhasil diperbarui gess!';
            } else {
                // Jika belum ada, lakukan INSERT data baru
                DB::table($namaTabel)->insert([
                    'user_id' => $request->user_id,
                    'makanan_suka' => $sukaJson,
                    'alergi_makanan' => $alergiJson,
                    'created_at' => Carbon::now(),
                    'updated_at' => Carbon::now(),
                ]);
                $pesan = 'Preferensi baru berhasil disimpan gess!';
            }

            return response()->json([
                'success' => true,
                'message' => $pesan,
                'data' => [
                    'user_id' => $request->user_id,
                    'makanan_suka' => $sukaJson,
                    'alergi_makanan' => $alergiJson
                ]
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menyimpan preferensi: ' . $e->getMessage()
            ], 500);
        }
    }

    // --------------------------------------------------------
    // 2. GET: AMBIL DATA PREFERENSI
    // --------------------------------------------------------
    public function getPreference($userId)
    {
        try {
            // NAMA TABEL SUDAH DISESUAIKAN DENGAN DATABASE KAMU GESS!
            $namaTabel = 'user_preferences'; 

            $preference = DB::table($namaTabel)->where('user_id', $userId)->first();

            if (!$preference) {
                return response()->json([
                    'success' => false,
                    'message' => 'Preferensi user belum diatur gess',
                    'makanan_suka' => '[]',
                    'alergi_makanan' => '[]'
                ], 200);
            }

            return response()->json([
                'success' => true,
                'makanan_suka' => $preference->makanan_suka ?? '[]',
                'alergi_makanan' => $preference->alergi_makanan ?? '[]'
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan server: ' . $e->getMessage()
            ], 500);
        }
    }
}