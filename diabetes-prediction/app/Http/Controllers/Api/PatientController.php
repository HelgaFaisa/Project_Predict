<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Patient;
use Illuminate\Support\Facades\Auth;
use App\Models\PredictionHistory;

class PatientController extends Controller
{
    public function myData(Request $request)
    {
        // Ambil user dari token JWT
        $account = Auth::guard('api')->user(); // tabel patient_accounts
        $patient = $account->patient;          // relasi ke tabel patients

        if (!$patient) {
            return response()->json(['message' => 'Data pasien tidak ditemukan'], 404);
        }

        // Kembalikan data diri + riwayat prediksi dari MongoDB
        return response()->json([
            'name' => $patient->name,
            'nik' => $patient->nik,
            'date_of_birth' => $patient->date_of_birth,
            'gender' => $patient->gender,
            'address' => $patient->address,
            'age' => $patient->age,
            'predictions' => $patient->predictionHistories()->latest()->get()
        ]);
    }

    public function riwayat($id)
    {
        $patient = Patient::find($id);

        if (!$patient) {
            return response()->json([
                'status' => false,
                'message' => 'Pasien tidak ditemukan',
            ], 404);
        }

        $riwayat = PredictionHistory::where('patient_id', $id)
            ->orderBy('prediction_timestamp', 'desc')
            ->get();

        return response()->json([
            'status' => true,
            'patient' => [
                'name' => $patient->name,
                'nik' => $patient->nik,
                'date_of_birth' => $patient->date_of_birth,
                'gender' => $patient->gender,
                'address' => $patient->address,
                'age' => $patient->age,
            ],
            'riwayat_prediksi' => $riwayat
        ]);
    }
}


