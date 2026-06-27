<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;

class PreferenceController extends Controller
{
    // API UNTUK SIMPAN PREFERENSI
    public function savePreference(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal gess',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            $userId = $request->input('user_id');
            
            $sukaRaw = $request->input('suka');
            $sukaData = is_array($sukaRaw) ? $sukaRaw : json_decode($sukaRaw ?? '[]', true);

            $alergiRaw = $request->input('alergi');
            $alergiData = is_array($alergiRaw) ? $alergiRaw : json_decode($alergiRaw ?? '[]', true);

            // FIX: Sekarang menggunakan 'makanan_suka' & 'alergi_makanan' sesuai migration kamu!
            DB::table('user_preferences')->updateOrInsert(
                ['user_id' => $userId], 
                [
                    'makanan_suka' => json_encode($sukaData ?? []), // Kolom fix
                    'alergi_makanan' => json_encode($alergiData ?? []), // Kolom fix
                    'created_at' => Carbon::now(),
                    'updated_at' => Carbon::now(),
                ]
            );

            return response()->json([
                'success' => true,
                'message' => 'Preferensi berhasil disimpan gess!'
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal disimpan: ' . $e->getMessage()
            ], 500);
        }
    }

    // API UNTUK AMBIL DATA PREFERENSI
    public function getPreference(int $user_id) 
    {
        try {
            $preference = DB::table('user_preferences')->where('user_id', $user_id)->first();

            if (!$preference) {
                return response()->json([
                    'success' => false,
                    'message' => 'Preferensi belum diatur gess'
                ], 404);
            }

            return response()->json([
                'success' => true,
                'data' => [
                    'id' => $preference->id,
                    'user_id' => $preference->user_id,
                    'suka' => json_decode($preference->makanan_suka ?? '[]'), // Kolom fix
                    'alergi' => json_decode($preference->alergi_makanan ?? '[]'), // Kolom fix
                ]
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan: ' . $e->getMessage()
            ], 500);
        }
    }
}