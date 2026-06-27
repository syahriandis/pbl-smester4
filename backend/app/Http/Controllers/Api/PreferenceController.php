<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class PreferenceController extends Controller
{
    public function savePreference(Request $request)
    {
<<<<<<< Updated upstream
        $validator = Validator::make($request->all(), [
            'user_id' => 'required',
            'makanan_suka' => 'nullable|array',
            'alergi_makanan' => 'nullable|array',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Format preferensi tidak valid',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $sukaJson = $request->has('makanan_suka')
                ? json_encode($request->makanan_suka)
                : json_encode([]);

            $alergiJson = $request->has('alergi_makanan')
                ? json_encode($request->alergi_makanan)
                : json_encode([]);

            $namaTabel = 'user_preferences';

            $cekData = DB::table($namaTabel)
                ->where('user_id', $request->user_id)
                ->first();

            if ($cekData) {
                DB::table($namaTabel)
                    ->where('user_id', $request->user_id)
                    ->update([
                        'makanan_suka' => $sukaJson,
                        'alergi_makanan' => $alergiJson,
                        'updated_at' => Carbon::now(),
                    ]);

                $pesan = 'Preferensi berhasil diperbarui';
            } else {
                DB::table($namaTabel)->insert([
                    'user_id' => $request->user_id,
                    'makanan_suka' => $sukaJson,
                    'alergi_makanan' => $alergiJson,
                    'created_at' => Carbon::now(),
                    'updated_at' => Carbon::now(),
                ]);

                $pesan = 'Preferensi baru berhasil disimpan';
            }

            DB::table('users')
                ->where('id', $request->user_id)
                ->update([
                    'is_personalized' => 1,
                    'updated_at' => Carbon::now(),
                ]);

            return response()->json([
                'success' => true,
                'message' => $pesan,
                'data' => [
                    'user_id' => $request->user_id,
                    'makanan_suka' => $sukaJson,
                    'alergi_makanan' => $alergiJson,
                    'is_personalized' => 1,
                ]
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menyimpan preferensi: ' . $e->getMessage()
            ], 500);
        }
    }

    public function getPreference($userId)
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
=======
        $userId = $request->input('user_id');
        
        // Ambil data dengan nama kunci 'suka' dan 'alergi'
        $sukaData = $request->input('suka', []);
        $alergiData = $request->input('alergi', []);

        $exists = DB::table('user_preferences')->where('user_id', $userId)->exists();

        if ($exists) {
            DB::table('user_preferences')->where('user_id', $userId)->update([
                'makanan_suka' => json_encode($sukaData),
                'alergi_makanan' => json_encode($alergiData),
                'updated_at' => Carbon::now(),
            ]);
        } else {
            DB::table('user_preferences')->insert([
                'user_id' => $userId,
                'makanan_suka' => json_encode($sukaData),
                'alergi_makanan' => json_encode($alergiData),
                'created_at' => Carbon::now(),
                'updated_at' => Carbon::now(),
            ]);
        }

        // Tandai user profil sudah lengkap
        DB::table('users')->where('id', $userId)->update(['is_profile_completed' => 1]);

        return response()->json(['success' => true, 'message' => 'Data tersimpan!']);
>>>>>>> Stashed changes
    }
}