<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Patient;
use App\Models\PredictionHistory;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http; // Diperlukan untuk HTTP Client
use Illuminate\Support\Facades\Log;   // Untuk logging
use Carbon\Carbon;
use Illuminate\Http\Client\ConnectionException; // Untuk menangani error koneksi HTTP

class PredictController extends Controller
{
    /**
     * Menampilkan form prediksi.
     * Mengambil data pasien untuk dropdown dan data hasil prediksi sebelumnya dari session.
     */
    public function index()
    {
        $patients = Patient::select('_id', 'id', 'name', 'date_of_birth')
                           ->orderBy('name', 'asc')
                           ->get();
        // Ambil data dari session flash jika ada (setelah redirect dari method predict)
        $input = session('prediction_input');
        $result = session('prediction_result');
        $selected_patient_name = session('selected_patient_name');

        return view('admin.prediksi.index', compact('patients', 'input', 'result', 'selected_patient_name'));
    }

    /**
     * Memproses data dari form, memanggil API prediksi, dan menampilkan hasilnya.
     */
    public function predict(Request $request)
    {
        $validatedData = $request->validate([
            'patient_id'     => 'required|string|exists:patients,_id',
            'pregnancies'    => 'required|integer|min:0',
            'glucose'        => 'required|numeric|min:0',
            'blood_pressure' => 'required|numeric|min:0',
            'height'         => 'required|numeric|min:1',
            'weight'         => 'required|numeric|min:1',
            // BMI dan Age akan dihitung di backend
        ]);

        $patient = Patient::find($validatedData['patient_id']);
        if (!$patient || !$patient->date_of_birth) {
            Log::warning('Predict attempt for patient without birth date or patient not found.', [
                'patient_id_attempted' => $validatedData['patient_id']
            ]);
            return back()->with('error', 'Data tanggal lahir pasien tidak ditemukan atau pasien tidak valid. Harap perbarui data pasien.')->withInput();
        }

        // Hitung Umur di backend
        $age = 0; // Default age
        try {
            $birthDate = Carbon::parse($patient->date_of_birth);
            $age = $birthDate->age;
            if ($age < 0) {
                Log::warning('Predict attempt with invalid birth date (future).', ['patient_id' => $patient->_id, 'birth_date' => $patient->date_of_birth]);
                return back()->with('error', 'Tanggal lahir pasien tidak valid (masa depan).')->withInput();
            }
        } catch (\Exception $e) {
            Log::error('Error parsing birth date for age calculation.', ['patient_id' => $patient->_id, 'date_of_birth' => $patient->date_of_birth, 'error' => $e->getMessage()]);
            return back()->with('error', 'Gagal memproses tanggal lahir pasien. Pastikan formatnya benar.')->withInput();
        }

        // Hitung BMI di backend
        $heightInMeters = $validatedData['height'] / 100;
        $bmi = ($heightInMeters > 0) ? ($validatedData['weight'] / ($heightInMeters * $heightInMeters)) : 0;
        $bmi = round($bmi, 2);

        // Siapkan data untuk dikirim ke API prediksi
        // Pastikan field ini sesuai dengan yang diharapkan oleh API Flask Anda
        $dataForApi = [
            'pregnancies'    => (int)$validatedData['pregnancies'],
            'glucose'        => (float)$validatedData['glucose'],
            'blood_pressure' => (float)$validatedData['blood_pressure'],
            // Jika API Anda membutuhkan SkinThickness, Insulin, DiabetesPedigreeFunction,
            // Anda perlu menambahkannya ke form atau mengirim nilai default jika API bisa menanganinya.
            // Contoh (jika API membutuhkan SkinThickness dan Insulin):
            // 'skin_thickness' => (float)$request->input('skin_thickness', 0), // Ambil dari request jika ada, atau default
            // 'insulin'        => (float)$request->input('insulin', 0),        // Ambil dari request jika ada, atau default
            'bmi'            => (float)$bmi,
            // 'diabetes_pedigree_function' => (float)$request->input('diabetes_pedigree_function', 0.5), // Contoh default
            'age'            => (int)$age,
        ];

        $predictionResult = null;
        try {
            $apiUrl = config('services.prediction_api.url', 'http://127.0.0.1:5000/predict'); // Ambil URL API dari config
            Log::info('Sending data to prediction API.', ['url' => $apiUrl, 'data' => $dataForApi]);

            $response = Http::timeout(10)->post($apiUrl, $dataForApi); // Tambahkan timeout untuk API call

            if ($response->successful()) {
                $apiResult = $response->json();
                Log::info('API Prediction Successful.', ['response' => $apiResult]);
                // Sesuaikan key 'result' atau 'prediction' berdasarkan respons aktual dari API Flask Anda
                if (isset($apiResult['prediction'])) { // Jika API Flask mengembalikan 'prediction'
                    $predictionResult = $apiResult['prediction'];
                } elseif (isset($apiResult['result'])) { // Jika API Flask mengembalikan 'result'
                    $predictionResult = $apiResult['result'];
                } else {
                    Log::error('API Prediction response does not contain expected key (prediction or result).', ['response_body' => $apiResult]);
                    return back()->with('error', 'Format respons dari API prediksi tidak dikenali.')->withInput();
                }
                // Pastikan hasilnya adalah 0 atau 1
                $predictionResult = in_array($predictionResult, [0, 1, '0', '1'], true) ? (int)$predictionResult : null;
                if (is_null($predictionResult)) {
                     Log::error('API Prediction result is not a valid 0 or 1 value.', ['raw_result' => $apiResult['prediction'] ?? $apiResult['result'] ?? 'N/A']);
                     return back()->with('error', 'Hasil prediksi dari API tidak valid.')->withInput();
                }

            } else {
                Log::error('API Prediction Failed.', ['status' => $response->status(), 'body' => $response->body()]);
                return back()->with('error', 'Gagal mendapatkan prediksi dari API. Status: ' . $response->status())->withInput();
            }

        } catch (ConnectionException $e) {
            Log::error("API Prediction Connection Error: " . $e->getMessage());
            return back()->with('error', 'Tidak dapat terhubung ke server prediksi. Mohon coba beberapa saat lagi.')->withInput();
        } catch (\Exception $e) {
            Log::error("General API Prediction Error: " . $e->getMessage());
            return back()->with('error', 'Terjadi kesalahan umum saat memproses prediksi.')->withInput();
        }

        // Simpan semua input yang relevan untuk ditampilkan kembali di form
        $inputToDisplay = array_merge($validatedData, [
            'bmi' => $bmi,
            'age' => $age,
            // Sertakan field lain yang mungkin Anda tambahkan untuk API jika perlu ditampilkan lagi
            // 'skin_thickness' => $dataForApi['skin_thickness'] ?? null,
            // 'insulin' => $dataForApi['insulin'] ?? null,
            // 'diabetes_pedigree_function' => $dataForApi['diabetes_pedigree_function'] ?? null,
        ]);

        // Redirect kembali ke halaman form dengan hasil dan input menggunakan session flash
        return redirect()->route('admin.prediksi.index')
                         ->with('prediction_result', $predictionResult)
                         ->with('prediction_input', $inputToDisplay)
                         ->with('selected_patient_name', $patient->name);
    }

    /**
     * Menyimpan hasil prediksi ke database.
     */
    public function savePrediction(Request $request)
    {
        $validatedData = $request->validate([
            'patient_id'     => 'required|string|exists:patients,_id',
            'pregnancies'    => 'required|integer|min:0',
            'glucose'        => 'required|numeric|min:0',
            'blood_pressure' => 'required|numeric|min:0',
            'height'         => 'required|numeric|min:1',
            'weight'         => 'required|numeric|min:1',
            'bmi'            => 'required|numeric|min:0',
            'age'            => 'required|integer|min:1',
            'result'         => 'required|numeric|in:0,1',
            // Validasi field tambahan jika Anda menyimpannya juga
            // 'skin_thickness' => 'nullable|numeric|min:0',
            // 'insulin'        => 'nullable|numeric|min:0',
            // 'diabetes_pedigree_function' => 'nullable|numeric|min:0',
        ]);

        $dataToSave = $validatedData;
        $dataToSave['prediction_timestamp'] = now();

        try {
            PredictionHistory::create($dataToSave);
            return redirect()->route('admin.prediksi.index')->with('success', 'Hasil prediksi berhasil disimpan.');
        } catch (\Exception $e) {
            Log::error("Save Prediction Error: " . $e->getMessage(), ['data' => $dataToSave]);
            return redirect()->route('admin.prediksi.index')->with('error', 'Gagal menyimpan hasil prediksi. Terjadi kesalahan internal.')->withInput();
        }
    }
}
