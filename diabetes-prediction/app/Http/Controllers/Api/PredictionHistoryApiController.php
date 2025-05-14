<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\PredictionHistory;
use App\Models\PatientAccount;

class PredictionHistoryApiController extends Controller
{
    public function getByAccountId($accountId)
    {
        $account = PatientAccount::where('_id', $accountId)->first();

        if (!$account || !$account->patient_id) {
            return response()->json(['message' => 'Akun tidak ditemukan atau belum terhubung dengan data pasien'], 404);
        }

        $histories = PredictionHistory::where('patient_id', $account->patient_id)
            ->orderBy('prediction_timestamp', 'desc')
            ->get();

        return response()->json($histories);
    }
}
