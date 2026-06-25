<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\GulaDarah;

class GulaDarahAdminController extends Controller
{
    public function index()
    {
        $dataGulaDarah = GulaDarah::with('user')
            ->orderBy('tanggal', 'desc')
            ->paginate(10);

        return view('admin.gula_darah', compact('dataGulaDarah'));
    }
}