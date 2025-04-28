<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\HasilDiagnosis;

class DiagnosisController extends Controller
{
    public function store(Request $request)
    {
        $validated = $request->validate([
            'gejala' => 'required|array',
            'skor' => 'required|numeric',
            'hasil' => 'required|string',
            'pasien_id' => 'required|integer',
        ]);

        $diagnosis = HasilDiagnosis::create($validated);

        return response()->json($diagnosis, 201);
    }
}