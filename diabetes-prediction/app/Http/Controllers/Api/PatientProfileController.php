<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Patient;

class PatientProfileController extends Controller
{
    public function profile(Request $request)
    {
        $account = $request->user();

        $patient = Patient::find($account->patient_id);

        if (!$patient) {
            return response()->json([
                'message' => 'Data pasien tidak ditemukan.'
            ], 404);
        }

        return response()->json([
            'account' => [
                'name' => $account->name,
                'email' => $account->email,
                'phone_number' => $account->phone_number,
            ],
            'patient' => $patient
        ]);
    }
}
