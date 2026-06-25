<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\FoodItem;
use Illuminate\Http\Request;

class FoodItemController extends Controller
{
    public function index()
    {
        $foods = FoodItem::latest()->paginate(10);
        return view('admin.food_items', compact('foods'));
    }

    public function create()
    {
        return view('admin.food_items_create');
    }

    public function store(Request $request)
    {
        $gambar = null;

        if ($request->hasFile('gambar')) {
            $gambar = $request->file('gambar')->store('food_items', 'public');
        }

        FoodItem::create([
            'nama' => $request->nama,
            'gambar' => $gambar,
            'takaran' => $request->takaran,
            'kategori' => $request->kategori,
            'kalori' => $request->kalori ?? 0,
            'protein' => $request->protein ?? 0,
            'lemak' => $request->lemak ?? 0,
            'karbo' => $request->karbo ?? 0,
            'gula' => $request->gula ?? 0,
        ]);

        return redirect('/admin/food-items')->with('success', 'Food item berhasil ditambahkan');
    }

    public function destroy($id)
    {
        FoodItem::findOrFail($id)->delete();
        return back()->with('success', 'Food item berhasil dihapus');
    }
}