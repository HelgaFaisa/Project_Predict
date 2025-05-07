<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Patient;
use App\Models\PredictionHistory; // Asumsi Anda punya model ini untuk menyimpan riwayat
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http; // Jika memanggil API eksternal
use Illuminate\Support\Facades\Log; // Untuk logging error
use Carbon\Carbon;

class PredictController extends Controller
{
    // Method untuk menampilkan form prediksi
    public function index()
    {
        $patients = Patient::select('_id', 'id', 'name', 'date_of_birth') // Pastikan date_of_birth diambil
                           ->orderBy('name', 'asc')
                           ->get();
        // Ambil data dari session flash jika ada (setelah redirect dari method predict)
        $input = session('prediction_input');
        $result = session('prediction_result');
        $selected_patient_name = session('selected_patient_name');

        return view('admin.prediksi.index', compact('patients', 'input', 'result', 'selected_patient_name'));
    }

    // Method untuk submit prediksi (yang dipanggil oleh form action)
    // NAMA METHOD DIUBAH KE 'predict'
    public function predict(Request $request)
    {
        $validatedData = $request->validate([
            'patient_id'     => 'required|string|exists:patients,_id',
            'pregnancies'    => 'required|integer|min:0',
            'glucose'        => 'required|numeric|min:0',
            'blood_pressure' => 'required|numeric|min:0',
            'height'         => 'required|numeric|min:1', // Validasi Tinggi Badan
            'weight'         => 'required|numeric|min:1', // Validasi Berat Badan
            // 'bmi' dan 'age' akan dihitung, jadi tidak perlu validasi dari input langsung form ini
        ]);

        $patient = Patient::find($validatedData['patient_id']);
        if (!$patient || !$patient->date_of_birth) {
            Log::warning('Predict attempt for patient without birth date.', ['patient_id' => $validatedData['patient_id']]);
            return back()->with('error', 'Data tanggal lahir pasien tidak ditemukan atau tidak valid. Harap perbarui data pasien.')->withInput();
        }

        // Hitung Umur di backend
        try {
            $birthDate = Carbon::parse($patient->date_of_birth);
            $age = $birthDate->age;
            if ($age < 0) { // Handle kasus tanggal lahir di masa depan
                Log::warning('Predict attempt with invalid birth date (future).', ['patient_id' => $patient->_id, 'birth_date' => $patient->date_of_birth]);
                return back()->with('error', 'Tanggal lahir pasien tidak valid.')->withInput();
            }
        } catch (\Exception $e) {
            Log::error('Error parsing birth date for age calculation.', ['patient_id' => $patient->_id, 'error' => $e->getMessage()]);
            return back()->with('error', 'Gagal memproses tanggal lahir pasien.')->withInput();
        }


        // Hitung BMI di backend
        $heightInMeters = $validatedData['height'] / 100;
        $bmi = ($heightInMeters > 0) ? $validatedData['weight'] / ($heightInMeters * $heightInMeters) : 0;
        $bmi = round($bmi, 2);

        // Siapkan data untuk dikirim ke API prediksi
        $dataForApi = [
            'pregnancies'    => (int)$validatedData['pregnancies'],
            'glucose'        => (float)$validatedData['glucose'],
            'blood_pressure' => (float)$validatedData['blood_pressure'],
            'bmi'            => (float)$bmi,
            'age'            => (int)$age,
            // Tambahkan field lain yang mungkin dibutuhkan API Anda, contoh:
            // 'skin_thickness' => (float)$request->input('skin_thickness_api', 0), // Ambil dari input tersembunyi jika perlu
            // 'insulin'        => (float)$request->input('insulin_api', 0),
            // 'diabetes_pedigree_function' => (float)$request->input('dpf_api', 0),
        ];

        $predictionResult = null;
        try {
            // $apiResponse = Http::post(config('services.prediction_api.url'), $dataForApi);
            // if ($apiResponse->successful()) {
            //     $predictionResult = $apiResponse->json()['result'] ?? 0;
            // } else {
            //     Log::error('API Prediction Failed.', ['status' => $apiResponse->status(), 'body' => $apiResponse->body()]);
            //     return back()->with('error', 'Gagal mendapatkan prediksi dari API. Status: ' . $apiResponse->status())->withInput();
            // }

            // Untuk testing tanpa API:
            Log::info('Dummy prediction executed.', ['data_for_api' => $dataForApi]);
            $predictionResult = rand(0,1);

        } catch (\Illuminate\Http\Client\ConnectionException $e) {
            Log::error("API Prediction Connection Error: " . $e->getMessage());
            return back()->with('error', 'Tidak dapat terhubung ke server prediksi. Mohon coba beberapa saat lagi.')->withInput();
        } catch (\Exception $e) {
            Log::error("General API Prediction Error: " . $e->getMessage());
            return back()->with('error', 'Terjadi kesalahan saat menghubungi layanan prediksi.')->withInput();
        }

        // Simpan semua input yang relevan untuk ditampilkan kembali
        $inputToDisplay = array_merge($validatedData, [
            'bmi' => $bmi,
            'age' => $age,
        ]);

        // Redirect kembali ke halaman form dengan hasil dan input menggunakan session flash
        return redirect()->route('admin.prediksi.index')
                         ->with('prediction_result', $predictionResult)
                         ->with('prediction_input', $inputToDisplay)
                         ->with('selected_patient_name', $patient->name);
    }

    // Method untuk menyimpan hasil prediksi
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
        ]);

        $dataToSave = $validatedData;
        $dataToSave['prediction_timestamp'] = now(); // Eloquent akan menangani format Carbon ke BSON UTCDateTime

        try {
            PredictionHistory::create($dataToSave);
            return redirect()->route('admin.prediksi.index')->with('success', 'Hasil prediksi berhasil disimpan.');
        } catch (\Exception $e) {
            Log::error("Save Prediction Error: " . $e->getMessage(), ['data' => $dataToSave]);
            return redirect()->route('admin.prediksi.index')->with('error', 'Gagal menyimpan hasil prediksi. Terjadi kesalahan internal.')->withInput();
        }
    }
}
