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

            // Ambil data input
            $sukaRaw = $request->input('suka', $request->input('makanan_suka', []));
            $alergiRaw = $request->input('alergi', $request->input('alergi_makanan', []));

            // =======================
            // PROSES MAKANAN SUKA
            // =======================
            $sukaData = [];

            if (is_string($sukaRaw)) {
                if (str_starts_with($sukaRaw, '[') && str_ends_with($sukaRaw, ']')) {
                    $sukaData = json_decode($sukaRaw, true) ?? [];
                } elseif (!empty($sukaRaw)) {
                    $sukaData = array_map('trim', preg_split('/[,\/]/', $sukaRaw));
                }
            } else {
                $sukaData = $sukaRaw;
            }

            // =======================
            // PROSES ALERGI
            // =======================
            $alergiData = [];

            if (is_string($alergiRaw)) {
                if (str_starts_with($alergiRaw, '[') && str_ends_with($alergiRaw, ']')) {
                    $alergiData = json_decode($alergiRaw, true) ?? [];
                } elseif (!empty($alergiRaw)) {
                    $alergiData = array_map('trim', preg_split('/[,\/]/', $alergiRaw));
                }
            } else {
                $alergiData = $alergiRaw;
            }

            $sukaJson = json_encode($sukaData);
            $alergiJson = json_encode($alergiData);

            // =======================
            // SIMPAN PREFERENSI
            // =======================
            DB::table($namaTabel)->updateOrInsert(
                ['user_id' => $userId],
                [
                    'makanan_suka' => $sukaJson,

                    // sementara tetap disimpan agar tidak merusak fitur lama
                    'alergi_makanan' => $alergiJson,

                    'created_at' => Carbon::now(),
                    'updated_at' => Carbon::now(),
                ]
            );

            // =======================
            // UPDATE USERS
            // =======================
            DB::table('users')
                ->where('id', $userId)
                ->update([
                    'alergi' => empty($alergiData)
                        ? null
                        : implode(', ', $alergiData),

                    'is_personalized' => 1,
                    'is_profile_completed' => 1,
                    'updated_at' => Carbon::now(),
                ]);

            return response()->json([
                'success' => true,
                'message' => 'Preferensi berhasil disimpan!',
                'data' => [
                    'user_id' => $userId,
                    'makanan_suka' => $sukaData,
                    'alergi' => empty($alergiData)
                        ? null
                        : implode(', ', $alergiData),
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
            $preference = DB::table('user_preferences')
                ->where('user_id', $userId)
                ->first();

            $user = DB::table('users')
                ->where('id', $userId)
                ->first();

            if (!$preference) {
                return response()->json([
                    'success' => false,
                    'message' => 'Preferensi user belum diatur',
                    'makanan_suka' => [],
                    'alergi' => $user->alergi ?? null,
                ], 200);
            }

            return response()->json([
                'success' => true,
                'makanan_suka' => json_decode($preference->makanan_suka ?? '[]', true),

                // mulai ambil alergi dari tabel users
                'alergi' => $user->alergi ?? null,
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan server: ' . $e->getMessage()
            ], 500);
        }
    }
}