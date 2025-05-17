<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Gejala;

class GejalaApiController extends Controller
{
    public function index()
    {
        return Gejala::where('aktif', true)
                     ->select('kode','nama','mb','md')
                     ->orderBy('kode')
                     ->get();
    }
}
