<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;

class ProfileController extends Controller
{
    // LOAD PROFILE
    public function loadProfile($id)
    {
        $user = DB::table('users')->where('id', $id)->first();

        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'User tidak ditemukan'
            ], 404);
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

    // UPDATE PROFILE
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