<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;

class ProfileController extends Controller
{
    /**
     * LOAD PROFILE
     * Fungsi ini otomatis membaca data yang diisi dari Onboarding
     */
    public function loadProfile(int $id)
    {
        $user = DB::table('users')
            ->leftJoin('user_preferences', 'users.id', '=', 'user_preferences.user_id')
            ->where('users.id', $id)
            ->select(
                'users.*',
                'user_preferences.alergi_makanan',
                'user_preferences.makanan_suka'
            )
            ->first();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'User tidak ditemukan'
            ], 404);
        }

        // --- VALIDASI & DECODE ALERGI DARI ONBOARDING ---
        $alergiRaw = $user->alergi_makanan;
        $alergiTampil = "";

        if (!empty($alergiRaw)) {
            // Jika data dari onboarding tersimpan dalam format JSON string (misal: ["telur", "udang"])
            if (str_starts_with($alergiRaw, '[') && str_ends_with($alergiRaw, ']')) {
                $alergiArray = json_decode($alergiRaw, true) ?? [];
                $alergiTampil = implode(", ", $alergiArray);
            } else {
                // Jika dari onboarding tersimpan sebagai string biasa/mentah (Blok teks atau dipisah koma)
                $alergiTampil = $alergiRaw;
            }
        }

        $makanan = json_decode($user->makanan_suka ?? '[]', true) ?? [];

        return response()->json([
            'success' => true,
            'user' => [
                'id' => $user->id,
                'nama' => $user->name,
                'email' => $user->email,
                'tanggal_lahir' => $user->tanggal_lahir,
                'umur' => $user->tanggal_lahir
                    ? Carbon::parse($user->tanggal_lahir)->age
                    : null,
                'gender' => $user->gender,

                'tinggi_badan' => $user->tinggi_badan,
                'berat_badan' => $user->berat_badan,
                'gula_darah' => $user->gula_darah,

                'alergi' => $alergiTampil, // Menampilkan data alergi onboarding secara otomatis
                'makanan_suka' => $makanan,

                'is_profile_completed' => $user->is_profile_completed,
            ]
        ]);
    }

    /**
     * UPDATE PROFILE
     * Digunakan untuk update data dari halaman Profile maupun Onboarding
     */
    public function updateProfile(Request $request, int $id)
    {
        $validator = Validator::make($request->all(), [
            'nama' => 'required|string|max:255',
            'tinggi_badan' => 'required|integer|min:50|max:300',
            'berat_badan' => 'required|integer|min:10|max:300',
            'gula_darah' => 'nullable|integer|min:1',
            'alergi' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => $validator->errors()->first()
            ], 422);
        }

        DB::beginTransaction();

        try {
            $updateUser = [
                'name' => $request->nama,
                'tinggi_badan' => $request->tinggi_badan,
                'berat_badan' => $request->berat_badan,
                'updated_at' => now(),
            ];

            if ($request->filled('gula_darah')) {
                $updateUser['gula_darah'] = $request->gula_darah;
            }

            if ($request->tinggi_badan != null && $request->berat_badan != null) {
                $updateUser['is_profile_completed'] = 1;
            }

            DB::table('users')
                ->where('id', $id)
                ->update($updateUser);

            /*
            |--------------------------------------------------------------------------
            | SIMPAN RIWAYAT GULA DARAH 
            |--------------------------------------------------------------------------
            | Jika user menginput/mengubah gula darah (di onboarding / profil), 
            | data otomatis masuk ke tabel riwayat agar grafik langsung terupdate.
            */
            if ($request->filled('gula_darah')) {
                $last = DB::table('gula_darah')
                    ->where('id_user', $id)
                    ->latest('id')
                    ->first();

                // Cek jika data riwayat terakhir kosong atau nilainya berbeda
                if (!$last || $last->nilai_gula != $request->gula_darah) {
                    $jam = now()->format('H:i');

                    // Menentukan slot waktu dinamis berdasarkan jam saat ini
                    if ($jam < '11:00') {
                        $waktu = 'Pagi';
                    } elseif ($jam < '17:00') {
                        $waktu = 'Siang';
                    } else {
                        $waktu = 'Malam';
                    }

                    DB::table('gula_darah')->insert([
                        'id_user' => $id,
                        'tanggal' => now()->toDateString(),
                        'waktu' => $waktu,
                        'nilai_gula' => $request->gula_darah,
                        'created_at' => now(),
                        'updated_at' => now(),
                    ]);
                }
            }

            /*
            |--------------------------------------------------------------------------
            | UPDATE ALERGI MAKANAN
            |--------------------------------------------------------------------------
            */
            $alergiString = $request->alergi ?? "";
            $alergiArray = [];

            if (!empty($alergiString)) {
                // Mengubah string pisahan koma (misal: "telur, kacang") menjadi array terpisah
                $alergiArray = array_map('trim', explode(",", $alergiString));
            }

            DB::table('user_preferences')->updateOrInsert(
                ['user_id' => $id],
                [
                    'alergi_makanan' => json_encode($alergiArray),
                    'updated_at' => now(),
                    'created_at' => now()
                ]
            );

            DB::commit();

            // Kembalikan profil terbaru setelah berhasil disimpan
            return $this->loadProfile($id);

        } catch (\Exception $e) {
            DB::rollBack();

            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan server: ' . $e->getMessage()
            ], 500);
        }
    }
}