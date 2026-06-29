<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Resep;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class ResepController extends Controller
{
    /**
     * Ambil semua resep
     */
    public function index()
    {
        try {

            $resep = Resep::orderBy('kategori')
                ->orderBy('nama')
                ->get();

            return response()->json([
                'success' => true,
                'message' => 'Berhasil mengambil data resep',
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

    /**
     * Detail resep
     */
    public function show($id)
    {
        $resep = Resep::find($id);

        if (!$resep) {
            return response()->json([
                'success' => false,
                'message' => 'Resep tidak ditemukan'
            ],404);
        }

        return response()->json([
            'success' => true,
            'data' => $resep
        ]);
    }

    /**
     * Tambah resep
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(),[
            'nama'=>'required',
            'kategori'=>'required|in:sarapan,siang,malam',
            'gambar'=>'required',
            'komposisi'=>'required',
            'cara'=>'required',
            'gula'=>'required|numeric',
            'kalori'=>'required|numeric',
            'protein'=>'required|numeric',
            'lemak'=>'required|numeric',
            'karbo'=>'required|numeric',
            'alergi'=>'nullable|string'
        ]);

        if($validator->fails()){
            return response()->json([
                'success'=>false,
                'errors'=>$validator->errors()
            ],422);
        }

        $resep = Resep::create($request->all());

        return response()->json([
            'success'=>true,
            'message'=>'Resep berhasil ditambahkan',
            'data'=>$resep
        ],201);
    }

    /**
     * Update resep
     */
    public function update(Request $request,$id)
    {
        $resep = Resep::find($id);

        if(!$resep){
            return response()->json([
                'success'=>false,
                'message'=>'Resep tidak ditemukan'
            ],404);
        }

        $validator = Validator::make($request->all(),[
            'nama'=>'required',
            'kategori'=>'required|in:sarapan,siang,malam',
            'gambar'=>'required',
            'komposisi'=>'required',
            'cara'=>'required',
            'gula'=>'required|numeric',
            'kalori'=>'required|numeric',
            'protein'=>'required|numeric',
            'lemak'=>'required|numeric',
            'karbo'=>'required|numeric',
            'alergi'=>'nullable|string'
        ]);

        if($validator->fails()){
            return response()->json([
                'success'=>false,
                'errors'=>$validator->errors()
            ],422);
        }

        $resep->update($request->all());

        return response()->json([
            'success'=>true,
            'message'=>'Resep berhasil diupdate',
            'data'=>$resep
        ]);
    }

    /**
     * Hapus resep
     */
    public function destroy($id)
    {
        $resep = Resep::find($id);

        if(!$resep){
            return response()->json([
                'success'=>false,
                'message'=>'Resep tidak ditemukan'
            ],404);
        }

        $resep->delete();

        return response()->json([
            'success'=>true,
            'message'=>'Resep berhasil dihapus'
        ]);
    }
}