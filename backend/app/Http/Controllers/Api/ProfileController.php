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
     */
    public function loadProfile(int $id)
    {
        $user = DB::table('users')
            ->leftJoin('user_preferences', 'users.id', '=', 'user_preferences.user_id')
            ->where('users.id', $id)
            ->select(
                'users.*',
                'user_preferences.makanan_suka'
            )
            ->first();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'User tidak ditemukan'
            ], 404);
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

                // Ambil alergi langsung dari tabel users
                'alergi' => $user->alergi,

                'makanan_suka' => $makanan,

                'is_profile_completed' => $user->is_profile_completed,
            ]
        ]);
    }

    /**
     * UPDATE PROFILE
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
                'alergi' => $request->alergi,
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

            // Simpan riwayat gula darah
            if ($request->filled('gula_darah')) {

                $last = DB::table('gula_darah')
                    ->where('id_user', $id)
                    ->latest('id')
                    ->first();

                if (!$last || $last->nilai_gula != $request->gula_darah) {

                    $jam = now()->format('H:i');

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

            DB::commit();

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