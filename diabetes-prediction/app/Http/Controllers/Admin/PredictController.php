<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Patient;
use App\Models\PredictionHistory; // Asumsi Anda punya model ini untuk menyimpan riwayat
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http; // Jika memanggil API eksternal
use Carbon\Carbon; // Untuk kalkulasi umur jika diperlukan di backend juga

class PredictController extends Controller
{
    // Method untuk menampilkan form prediksi
    public function index() // Atau nama method Anda, misal create()
    {
        $patients = Patient::select('_id', 'id', 'name', 'date_of_birth') // Pastikan date_of_birth diambil
                           ->orderBy('name', 'asc')
                           ->get();
        $input = session('prediction_input'); // Ambil input dari session jika ada (setelah redirect dari predict)
        $result = session('prediction_result');
        $selected_patient_name = session('selected_patient_name');

        return view('admin.prediksi.index', compact('patients', 'input', 'result', 'selected_patient_name'));
    }

    // Method untuk submit prediksi (yang dipanggil oleh form action)
    public function submitPrediction(Request $request) // Ganti nama method jika berbeda
    {
        $validatedData = $request->validate([
            'patient_id'     => 'required|string|exists:patients,_id',
            'pregnancies'    => 'required|integer|min:0',
            'glucose'        => 'required|numeric|min:0',
            'blood_pressure' => 'required|numeric|min:0',
            'height'         => 'required|numeric|min:1', // Validasi Tinggi Badan
            'weight'         => 'required|numeric|min:1', // Validasi Berat Badan
            // 'bmi' tidak perlu divalidasi dari input karena dihitung
            // 'age' tidak perlu divalidasi dari input karena dihitung
        ]);

        // Ambil data pasien untuk menghitung umur di backend (sebagai fallback atau verifikasi)
        $patient = Patient::find($validatedData['patient_id']);
        if (!$patient || !$patient->date_of_birth) {
            return back()->with('error', 'Data tanggal lahir pasien tidak ditemukan.')->withInput();
        }

        // Hitung Umur di backend
        $birthDate = Carbon::parse($patient->date_of_birth);
        $age = $birthDate->age;

        // Hitung BMI di backend
        $heightInMeters = $validatedData['height'] / 100;
        $bmi = ($heightInMeters > 0) ? $validatedData['weight'] / ($heightInMeters * $heightInMeters) : 0;
        $bmi = round($bmi, 2);


        // Siapkan data untuk dikirim ke API prediksi (jika ada)
        // API mungkin membutuhkan BMI dan Umur, bukan TB & BB & Tgl Lahir
        $dataForApi = [
            'pregnancies'    => (int)$validatedData['pregnancies'],
            'glucose'        => (float)$validatedData['glucose'],
            'blood_pressure' => (float)$validatedData['blood_pressure'],
            'bmi'            => (float)$bmi, // Kirim BMI yang sudah dihitung
            'age'            => (int)$age,   // Kirim Umur yang sudah dihitung
            // 'skin_thickness' => (float)$request->input('skin_thickness', 0), // Contoh field lain jika ada
            // 'insulin'        => (float)$request->input('insulin', 0),        // Contoh field lain jika ada
            // 'diabetes_pedigree_function' => (float)$request->input('diabetes_pedigree_function', 0), // Contoh
        ];

        // Panggil API prediksi Anda
        $predictionResult = null;
        try {
            // $apiResponse = Http::post(config('services.prediction_api.url'), $dataForApi);
            // if ($apiResponse->successful()) {
            //     $predictionResult = $apiResponse->json()['result'] ?? 0; // Sesuaikan dengan response API Anda
            // } else {
            //     return back()->with('error', 'Gagal mendapatkan prediksi dari API. Status: ' . $apiResponse->status())->withInput();
            // }
            // Untuk testing tanpa API:
            $predictionResult = rand(0,1); // Hasil dummy

        } catch (\Exception $e) {
            // Log::error("API Prediction Error: " . $e->getMessage());
            return back()->with('error', 'Terjadi kesalahan saat menghubungi layanan prediksi.')->withInput();
        }


        // Simpan semua input yang relevan (termasuk yang dihitung) untuk ditampilkan kembali
        $inputToDisplay = array_merge($validatedData, [
            'bmi' => $bmi,
            'age' => $age,
        ]);


        // Redirect kembali ke halaman form dengan hasil dan input
        // Menggunakan session flash untuk data ini lebih baik daripada query string
        return redirect()->route('admin.prediksi.index') // Kembali ke halaman form prediksi
                         ->with('prediction_result', $predictionResult)
                         ->with('prediction_input', $inputToDisplay)
                         ->with('selected_patient_name', $patient->name);
    }

    // Method untuk menyimpan hasil prediksi
    public function savePrediction(Request $request)
    {
        // Validasi data yang diterima dari form hasil (yang berisi hidden input)
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

        // Tambahkan timestamp
        $dataToSave = $validatedData;
        $dataToSave['prediction_timestamp'] = now();

        // Simpan ke collection prediction_histories (atau nama collection Anda)
        // Jika menggunakan Eloquent untuk PredictionHistory:
        try {
            PredictionHistory::create($dataToSave);
            return redirect()->route('admin.prediksi.index')->with('success', 'Hasil prediksi berhasil disimpan.');
        } catch (\Exception $e) {
            // Log::error("Save Prediction Error: " . $e->getMessage());
            return redirect()->route('admin.prediksi.index')->with('error', 'Gagal menyimpan hasil prediksi.')->withInput();
        }

        // Jika menggunakan MongoDB Driver langsung (seperti di kode Anda sebelumnya):
        /*
        try {
            $mongoUri = env('DB_URI', 'mongodb://localhost:27017');
            $mongo = new \MongoDB\Client($mongoUri);
            $dbName = env('DB_DATABASE', 'nama_database_anda');
            $collectionName = 'prediction_histories'; // Sesuaikan
            $collection = $mongo->$dbName->$collectionName;

            $dataToSaveMongo = [
                'patient_id'     => $validatedData['patient_id'],
                'pregnancies'    => (int) $validatedData['pregnancies'],
                'glucose'        => (float) $validatedData['glucose'],
                'blood_pressure' => (float) $validatedData['blood_pressure'],
                'height'         => (float) $validatedData['height'],
                'weight'         => (float) $validatedData['weight'],
                'bmi'            => (float) $validatedData['bmi'],
                'age'            => (int) $validatedData['age'],
                'result'         => (int) $validatedData['result'],
                'prediction_timestamp' => new \MongoDB\BSON\UTCDateTime()
            ];
            $collection->insertOne($dataToSaveMongo);
            return redirect()->route('admin.prediksi.index')->with('success', 'Hasil prediksi berhasil disimpan.');

        } catch (\Exception $e) {
            // Log::error("Save Prediction Error (MongoDB Driver): " . $e->getMessage());
            return redirect()->route('admin.prediksi.index')->with('error', 'Gagal menyimpan hasil prediksi.')->withInput();
        }
        */
    }
}
