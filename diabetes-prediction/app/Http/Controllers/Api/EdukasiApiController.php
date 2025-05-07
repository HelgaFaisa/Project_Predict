<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;

class EdukasiApiController extends Controller
{
    public function index()
    {
        $data = DB::collection('education_articles')->get(); // sesuaikan nama koleksi jika beda
        return response()->json($data);
    }
}
