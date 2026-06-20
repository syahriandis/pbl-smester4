<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\GulaDarah;
use Illuminate\Http\Request;

class GulaDarahController extends Controller
{
    public function index($id_user)
    {
        $data = GulaDarah::where('id_user', $id_user)
            ->orderBy('tanggal', 'asc')
            ->get();

        return response()->json([
            'success' => true,
            'data' => $data
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'id_user' => 'required',
            'tanggal' => 'required|date',
            'waktu' => 'required',
            'nilai_gula' => 'required|integer',
        ]);

        $data = GulaDarah::create([
            'id_user' => $request->id_user,
            'tanggal' => $request->tanggal,
            'waktu' => $request->waktu,
            'nilai_gula' => $request->nilai_gula,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Data gula darah berhasil disimpan',
            'data' => $data
        ]);
    }

    public function destroy($id)
    {
        $data = GulaDarah::find($id);

        if (!$data) {
            return response()->json([
                'success' => false,
                'message' => 'Data tidak ditemukan'
            ], 404);
        }

        $data->delete();

        return response()->json([
            'success' => true,
            'message' => 'Data berhasil dihapus'
        ]);
    }
}