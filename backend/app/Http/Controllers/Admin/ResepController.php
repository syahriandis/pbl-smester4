<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Resep;
use Illuminate\Http\Request;

class ResepController extends Controller
{
    public function index()
    {
        $reseps = Resep::latest()->paginate(10);
        return view('admin.reseps', compact('reseps'));
    }

    public function create()
    {
        return view('admin.reseps_create');
    }

    public function store(Request $request)
    {
        $gambar = null;

        if ($request->hasFile('gambar')) {
            $gambar = $request->file('gambar')->store('reseps', 'public');
        }

        Resep::create([
            'nama' => $request->nama,
            'gambar' => $gambar,
            'komposisi' => $request->komposisi,
            'cara' => $request->cara,
        ]);

        return redirect('/admin/reseps')->with('success', 'Resep berhasil ditambahkan');
    }

    public function destroy($id)
    {
        Resep::findOrFail($id)->delete();
        return back()->with('success', 'Resep berhasil dihapus');
    }
}