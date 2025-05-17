<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\PredictionHistory;
use App\Models\PatientAccount;

class PredictionHistoryApiController extends Controller
{
    /**
     * Mendapatkan riwayat prediksi berdasarkan accountId
     */
    public function getByAccountId($accountId)
    {
        $account = PatientAccount::where('_id', $accountId)->first();
        
        if (!$account || !$account->patient_id) {
            return response()->json([
                'success' => false,
                'message' => 'Akun tidak ditemukan atau belum terhubung dengan data pasien'
            ], 404);
        }
        
        $histories = PredictionHistory::where('patient_id', $account->patient_id)
            ->orderBy('prediction_timestamp', 'desc')
            ->get();
        
        // Format data sesuai dengan yang diharapkan oleh Flutter
        $formattedHistories = $this->formatHistoriesData($histories);
        
        // Mengembalikan response sukses walaupun data kosong
        return response()->json([
            'success' => true,
            'data' => $formattedHistories
        ]);
    }
    
    /**
     * Mendapatkan riwayat prediksi untuk user yang sedang login
     */
    public function getCurrentUserHistory(Request $request)
    {
        // Ambil user yang sedang login
        $user = $request->user();
        
        // Pastikan user adalah instance dari PatientAccount
        if (!$user) {
            return response()->json([
                'success' => false,
                'message' => 'Anda belum login'
            ], 401);
        }
        
        // Pastikan account memiliki patient_id
        if (!$user->patient_id) {
            return response()->json([
                'success' => false,
                'message' => 'Akun belum terhubung dengan data pasien'
            ], 404);
        }
        
        // Ambil riwayat prediksi berdasarkan patient_id
        $histories = PredictionHistory::where('patient_id', $user->patient_id)
            ->orderBy('prediction_timestamp', 'desc')
            ->get();
        
        // Format data sesuai dengan yang diharapkan oleh Flutter
        $formattedHistories = $this->formatHistoriesData($histories);
        
        // Mengembalikan response sukses walaupun data kosong
        return response()->json([
            'success' => true,
            'data' => $formattedHistories
        ]);
    }
    
    /**
     * Format data histories agar sesuai dengan model di Flutter
     */
    private function formatHistoriesData($histories)
    {
        return $histories->map(function($history) {
            // Menentukan hasil prediksi dengan memprioritaskan prediction_result
            $predictionResult = $this->normalizePredictionResult($history->prediction_result, $history->result);
            
            // Pastikan tipe data sesuai dengan yang diharapkan di Flutter
            return [
                'id' => (string) $history->_id, // Pastikan id dikirim sebagai string
                'patient_id' => (string) $history->patient_id, // Pastikan patient_id dikirim sebagai string
                'symptoms' => $history->symptoms,
                'prediction_result' => $predictionResult, // Hasil prediksi yang sudah dinormalisasi
                'pregnancies' => (int) $history->pregnancies,
                'glucose' => (int) $history->glucose,
                'blood_pressure' => (int) $history->blood_pressure,
                'height' => (int) $history->height,
                'weight' => (int) $history->weight,
                'bmi' => (float) $history->bmi,
                'age' => (int) $history->age,
                'result' => $predictionResult, // Menyamakan result dengan prediction_result
                'created_at' => $history->created_at->toIso8601String(),
                'updated_at' => $history->updated_at->toIso8601String(),
                'prediction_timestamp' => $history->prediction_timestamp->toIso8601String(),
            ];
        });
    }
    
    /**
     * Normalisasi hasil prediksi untuk format yang konsisten
     */
    private function normalizePredictionResult($predictionResult, $result)
    {
        // Coba gunakan prediction_result terlebih dahulu jika ada
        if (!empty($predictionResult)) {
            $value = strtolower($predictionResult);
            
            // Normalisasi format nilai
            if ($value == '1' || $value == 'true' || $value == 't' || $value == 'yes' || $value == 'y' || $value == 'positif' || $value == 'positive') {
                return 'Positif';
            } elseif ($value == '0' || $value == 'false' || $value == 'f' || $value == 'no' || $value == 'n' || $value == 'negatif' || $value == 'negative') {
                return 'Negatif';
            }
            
            // Jika tidak cocok dengan format yang dikenal, kembalikan nilai aslinya
            return $predictionResult;
        }
        
        // Jika prediction_result kosong, coba gunakan result
        if (!empty($result)) {
            $value = strtolower($result);
            
            // Normalisasi format nilai
            if ($value == '1' || $value == 'true' || $value == 't' || $value == 'yes' || $value == 'y' || $value == 'positif' || $value == 'positive') {
                return 'Positif';
            } elseif ($value == '0' || $value == 'false' || $value == 'f' || $value == 'no' || $value == 'n' || $value == 'negatif' || $value == 'negative') {
                return 'Negatif';
            }
            
            // Jika tidak cocok dengan format yang dikenal, kembalikan nilai aslinya
            return $result;
        }
        
        // Jika keduanya kosong, kembalikan '-'
        return '-';
    }
}