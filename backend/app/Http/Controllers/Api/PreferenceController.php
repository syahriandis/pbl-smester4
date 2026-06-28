<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;

class PreferenceController extends Controller
{
    /**
     * Menyimpan atau memperbarui preferensi pengguna.
     */
    public function savePreference(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Format preferensi tidak valid',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $userId = $request->input('user_id');
            $namaTabel = 'user_preferences';
            
            // Ambil data input mentah
            $sukaRaw = $request->input('suka', $request->input('makanan_suka', []));
            $alergiRaw = $request->input('alergi', $request->input('alergi_makanan', []));

            // --- PERBAIKAN LOGIKA PROSES DATA SUKA ---
            $sukaData = [];
            if (is_string($sukaRaw)) {
                // Cek jika string berupa JSON array valid
                if (str_starts_with($sukaRaw, '[') && str_ends_with($sukaRaw, ']')) {
                    $sukaData = json_decode($sukaRaw, true) ?? [];
                } elseif (!empty($sukaRaw)) {
                    // Jika teks biasa, pecah berdasarkan koma (,) atau slash (/)
                    $sukaData = array_map('trim', preg_split('/[,\/]/', $sukaRaw));
                }
            } else {
                $sukaData = $sukaRaw;
            }

            // --- PERBAIKAN LOGIKA PROSES DATA ALERGI ---
            $alergiData = [];
            if (is_string($alergiRaw)) {
                // Cek jika string berupa JSON array valid
                if (str_starts_with($alergiRaw, '[') && str_ends_with($alergiRaw, ']')) {
                    $alergiData = json_decode($alergiRaw, true) ?? [];
                } elseif (!empty($alergiRaw)) {
                    // Jika teks biasa (contoh: "Seafood / Udang"), pecah jadi array
                    $alergiData = array_map('trim', preg_split('/[,\/]/', $alergiRaw));
                }
            } else {
                $alergiData = $alergiRaw;
            }

            // Amankan ke format JSON string untuk disimpan ke database
            $sukaJson = json_encode($sukaData ?? []);
            $alergiJson = json_encode($alergiData ?? []);

            // Menggunakan updateOrInsert agar kode lebih ringkas & cepat gess
            DB::table($namaTabel)->updateOrInsert(
                ['user_id' => $userId],
                [
                    'makanan_suka' => $sukaJson,
                    'alergi_makanan' => $alergiJson,
                    'created_at' => Carbon::now(),
                    'updated_at' => Carbon::now(),
                ]
            );

            // Update status flag di tabel users sekalian
            DB::table('users')
                ->where('id', $userId)
                ->update([
                    'is_personalized' => 1,
                    'is_profile_completed' => 1,
                    'updated_at' => Carbon::now(),
                ]);

            return response()->json([
                'success' => true,
                'message' => 'Preferensi berhasil disimpan gess!',
                'data' => [
                    'user_id' => $userId,
                    'makanan_suka' => $sukaData,
                    'alergi_makanan' => $alergiData
                ]
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menyimpan preferensi: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Mendapatkan preferensi pengguna.
     */
    public function getPreference(int $userId)
    {
        try {
            $namaTabel = 'user_preferences';

            $preference = DB::table($namaTabel)
                ->where('user_id', $userId)
                ->first();

            if (!$preference) {
                return response()->json([
                    'success' => false,
                    'message' => 'Preferensi user belum diatur',
                    'makanan_suka' => [],
                    'alergi_makanan' => []
                ], 200);
            }

            // Kembalikan dalam bentuk Array asli (sudah didecode dari JSON database)
            return response()->json([
                'success' => true,
                'makanan_suka' => json_decode($preference->makanan_suka ?? '[]', true),
                'alergi_makanan' => json_decode($preference->alergi_makanan ?? '[]', true)
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan server: ' . $e->getMessage()
            ], 500);
        }
    }
}