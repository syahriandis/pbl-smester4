<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Support\Facades\DB;

class RekomendasiController extends Controller
{
    public function getRekomendasi($id_user)
    {
        try {

            $user = User::find($id_user);

            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'User tidak ditemukan'
                ],404);
            }

            $gulaDarah = $user->gula_darah ?? 0;
            $alergi = strtolower(trim($user->alergi ?? ""));

            // =========================
            // SARAPAN
            // =========================

            $sarapan = DB::table('reseps')
                ->where('kategori','sarapan')
                ->where('gula','<=',$gulaDarah)
                ->when($alergi != "",function($q) use($alergi){
                    $q->where(function($query) use($alergi){
                        $query->whereNull('alergi')
                              ->orWhere('alergi','')
                              ->orWhere('alergi','NOT LIKE','%'.$alergi.'%');
                    });
                })
                ->inRandomOrder()
                ->limit(3)
                ->get();

            // =========================
            // MAKAN SIANG
            // =========================

            $siang = DB::table('reseps')
                ->where('kategori','siang')
                ->where('gula','<=',$gulaDarah)
                ->when($alergi != "",function($q) use($alergi){
                    $q->where(function($query) use($alergi){
                        $query->whereNull('alergi')
                              ->orWhere('alergi','')
                              ->orWhere('alergi','NOT LIKE','%'.$alergi.'%');
                    });
                })
                ->inRandomOrder()
                ->limit(3)
                ->get();

            // =========================
            // MAKAN MALAM
            // =========================

            $malam = DB::table('reseps')
                ->where('kategori','malam')
                ->where('gula','<=',$gulaDarah)
                ->when($alergi != "",function($q) use($alergi){
                    $q->where(function($query) use($alergi){
                        $query->whereNull('alergi')
                              ->orWhere('alergi','')
                              ->orWhere('alergi','NOT LIKE','%'.$alergi.'%');
                    });
                })
                ->inRandomOrder()
                ->limit(3)
                ->get();

            // =========================
            // SNACK
            // =========================

            $snack = DB::table('food_items')
                ->where('kategori','snack')
                ->where('gula','<=',$gulaDarah)
                ->inRandomOrder()
                ->limit(5)
                ->get();

            // =========================
            // MINUMAN
            // =========================

            $minuman = DB::table('food_items')
                ->where('kategori','minuman')
                ->where('gula','<=',$gulaDarah)
                ->inRandomOrder()
                ->limit(5)
                ->get();

            return response()->json([
                'success'=>true,
                'data'=>[
                    'sarapan'=>$sarapan,
                    'siang'=>$siang,
                    'malam'=>$malam,
                    'snack'=>$snack,
                    'minuman'=>$minuman
                ]
            ]);

        } catch (\Exception $e){

            return response()->json([
                'success'=>false,
                'message'=>$e->getMessage()
            ],500);

        }
    }
}