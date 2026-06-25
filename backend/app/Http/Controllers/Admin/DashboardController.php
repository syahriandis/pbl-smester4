<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\GulaDarah;
use App\Models\FoodItem;
use App\Models\Resep;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    public function index()
    {
        $totalPengguna = User::count();
        $totalGulaDarah = GulaDarah::count();
        $totalFood = FoodItem::count();
        $totalResep = Resep::count();

        $foodSnack = FoodItem::where('kategori', 'snack')->count();
        $foodMinuman = FoodItem::where('kategori', 'minuman')->count();

        $gulaRendah = GulaDarah::where('nilai_gula', '<', 70)->count();
        $gulaNormal = GulaDarah::whereBetween('nilai_gula', [70, 140])->count();
        $gulaTinggi = GulaDarah::where('nilai_gula', '>', 140)->count();

        $userBulanan = User::select(
            DB::raw('MONTH(created_at) as bulan'),
            DB::raw('COUNT(*) as total')
        )
            ->groupBy('bulan')
            ->pluck('total', 'bulan')
            ->toArray();

        $gulaBulanan = GulaDarah::select(
            DB::raw('MONTH(tanggal) as bulan'),
            DB::raw('COUNT(*) as total')
        )
            ->groupBy('bulan')
            ->pluck('total', 'bulan')
            ->toArray();

        $aktivitasTerbaru = collect();

        $usersTerbaru = User::latest()->take(3)->get();
        foreach ($usersTerbaru as $user) {
            $aktivitasTerbaru->push([
                'aktivitas' => 'Pengguna baru mendaftar: ' . $user->name,
                'tanggal' => $user->created_at,
                'tipe' => 'user'
            ]);
        }

        $gulaTerbaru = GulaDarah::with('user')->latest()->take(3)->get();
        foreach ($gulaTerbaru as $gula) {
            $aktivitasTerbaru->push([
                'aktivitas' => 'Input gula darah oleh ' . ($gula->user->name ?? 'Pengguna') . ' sebesar ' . $gula->nilai_gula . ' mg/dL',
                'tanggal' => $gula->created_at ?? $gula->tanggal,
                'tipe' => 'gula'
            ]);
        }

        $foodTerbaru = FoodItem::latest()->take(3)->get();
        foreach ($foodTerbaru as $food) {
            $aktivitasTerbaru->push([
                'aktivitas' => 'Food item ditambahkan: ' . $food->nama,
                'tanggal' => $food->created_at,
                'tipe' => 'food'
            ]);
        }

        $resepTerbaru = Resep::latest()->take(3)->get();
        foreach ($resepTerbaru as $resep) {
            $aktivitasTerbaru->push([
                'aktivitas' => 'Resep ditambahkan: ' . $resep->nama,
                'tanggal' => $resep->created_at,
                'tipe' => 'resep'
            ]);
        }

        $aktivitasTerbaru = $aktivitasTerbaru
            ->sortBy('tanggal')
            ->values()
            ->take(8);

        return view('admin.dashboard', compact(
            'totalPengguna',
            'totalGulaDarah',
            'totalFood',
            'totalResep',
            'foodSnack',
            'foodMinuman',
            'gulaRendah',
            'gulaNormal',
            'gulaTinggi',
            'userBulanan',
            'gulaBulanan',
            'aktivitasTerbaru'
        ));
    }
}