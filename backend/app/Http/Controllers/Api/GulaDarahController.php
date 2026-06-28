<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\GulaDarah;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class GulaDarahController extends Controller
{
    /**
     * Menampilkan seluruh riwayat gula darah user
     */
    public function index($id_user)
    {
        $data = GulaDarah::where('id_user', $id_user)
            ->orderBy('tanggal', 'asc')
            ->orderByRaw("
                FIELD(waktu,'Pagi','Siang','Malam')
            ")
            ->get();

        return response()->json([
            'success' => true,
            'data' => $data
        ]);
    }

    /**
     * Menyimpan data gula darah
     */
    public function store(Request $request)
    {
        $request->validate([
            'id_user'     => 'required|exists:users,id',
            'tanggal'     => 'required|date',
            'waktu'       => 'required|in:Pagi,Siang,Malam',
            'nilai_gula'  => 'required|integer|min:1',
        ]);

        DB::beginTransaction();

        try {

            // Simpan ke tabel riwayat
            $data = GulaDarah::create([
                'id_user'    => $request->id_user,
                'tanggal'    => $request->tanggal,
                'waktu'      => $request->waktu,
                'nilai_gula' => $request->nilai_gula,
            ]);

            // Update gula darah terakhir user
            DB::table('users')
                ->where('id', $request->id_user)
                ->update([
                    'gula_darah' => $request->nilai_gula,
                    'updated_at' => now(),
                ]);

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Data gula darah berhasil disimpan',
                'data' => $data
            ], 201);

        } catch (\Exception $e) {

            DB::rollBack();

            return response()->json([
                'success' => false,
                'message' => 'Gagal menyimpan data',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Menghapus riwayat gula darah
     */
    public function destroy($id)
    {
        DB::beginTransaction();

        try {

            $data = GulaDarah::find($id);

            if (!$data) {
                return response()->json([
                    'success' => false,
                    'message' => 'Data tidak ditemukan'
                ], 404);
            }

            $idUser = $data->id_user;

            $data->delete();

            // Ambil data terakhir setelah dihapus
            $terakhir = GulaDarah::where('id_user', $idUser)
                ->orderBy('tanggal', 'desc')
                ->orderByRaw("
                    FIELD(waktu,'Malam','Siang','Pagi')
                ")
                ->first();

            DB::table('users')
                ->where('id', $idUser)
                ->update([
                    'gula_darah' => $terakhir ? $terakhir->nilai_gula : null,
                    'updated_at' => now(),
                ]);

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Data berhasil dihapus'
            ]);

        } catch (\Exception $e) {

            DB::rollBack();

            return response()->json([
                'success' => false,
                'message' => 'Terjadi kesalahan',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}