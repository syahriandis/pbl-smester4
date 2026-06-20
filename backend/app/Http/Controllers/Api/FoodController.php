<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class FoodController extends Controller
{
    // 1. GET: Ambil Semua Data Makanan & Minuman
    public function getAllFood()
    {
        try {
            $foods = DB::table('food_items')->get();

            // Pisahkan data berdasarkan kategori gess biar di Flutter tinggal pakai
            $drinks = $foods->where('kategori', 'minuman')->values();
            $snacks = $foods->where('kategori', 'snack')->values();

            return response()->json([
                'success' => true,
                'message' => 'Berhasil mengambil daftar makanan gess!',
                'data' => [
                    'drinks' => $drinks,
                    'snacks' => $snacks
                ]
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data: ' . $e->getMessage()
            ], 500);
        }
    }

    // 2. POST: Tambah Menu Makanan/Minuman Baru dari Flutter
    public function storeFood(Request $request)
    {
        // Validasi input dari Flutter sesuai dengan struktur database baru kita
        $validator = Validator::make($request->all(), [
            'nama' => 'required|string',
            'takaran' => 'required|string',
            'kategori' => 'required|in:minuman,snack',
            'kalori' => 'required|numeric',
            'protein' => 'required|numeric',
            'lemak' => 'required|numeric',
            'karbo' => 'required|numeric',
            'gula' => 'required|numeric',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Data input tidak valid gess',
                'errors' => $validator->errors()
            ], 422);
        }

        try {
            // Masukkan data baru ke tabel food_items
            $foodId = DB::table('food_items')->insertGetId([
                'nama' => $request->nama,
                'gambar' => $request->gambar ?? '', // sementara kosong jika tidak upload gambar
                'takaran' => $request->takaran,
                'kategori' => $request->kategori,
                'kalori' => $request->kalori,
                'protein' => $request->protein,
                'lemak' => $request->lemak,
                'karbo' => $request->karbo,
                'gula' => $request->gula,
                'created_at' => now(),
                'updated_at' => now(),
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Menu baru berhasil disimpan ke database gess!',
                'food_id' => $foodId
            ], 201);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menyimpan menu baru: ' . $e->getMessage()
            ], 500);
        }
    }
}