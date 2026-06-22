<?php

namespace App\Http\Controllers\Api; // ✔ Mengikuti folder Api

use App\Http\Controllers\Controller; // ✔ Wajib di-import karena posisi class sekarang di dalam subfolder Api
use App\Models\Resep;
use Illuminate\Http\Request;

class ResepController extends Controller
{
    /**
     * Mengambil semua katalog resep sehat
     */
    public function index()
    {
        try {
            $resep = Resep::all();
            
            return response()->json([
                'success' => true,
                'message' => 'Berhasil mengambil data katalog resep',
                'data' => $resep
            ], 200);
            
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}