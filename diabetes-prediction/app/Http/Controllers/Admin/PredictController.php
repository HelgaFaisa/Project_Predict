<?php

namespace App\Http\Controllers\Admin; // Pastikan namespace benar

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Validation\Rule; // Dibutuhkan jika validasi kompleks
use App\Models\Patient; // <-- TAMBAHKAN: Import model Patient
use MongoDB\Client as Mongo;
use MongoDB\BSON\UTCDateTime; // <-- TAMBAHKAN: Untuk timestamp BSON
use Exception; // <-- TAMBAHKAN: Untuk Exception umum
use Illuminate\Http\Client\ConnectionException; // <-- TAMBAHKAN: Untuk error koneksi HTTP

class PredictController extends Controller
{
    /**
     * Menampilkan form prediksi awal
     */
    public function index()
    {
        // 1. Ambil data pasien untuk dropdown
        $patients = Patient::select('_id', 'name')->orderBy('name', 'asc')->get();

        // 2. Kirim data pasien (dan variabel lain yg mungkin dibutuhkan view) ke view
        return view('admin.prediksi.index', [
            'patients' => $patients,
            'input' => null, // Form awal belum ada input
            'result' => null, // Form awal belum ada result
            'selected_patient_name' => null, // Form awal belum ada pasien terpilih
        ]);
    }

    /**
     * Memproses prediksi berdasarkan input form
     */
    public function predict(Request $request)
    {
        // 1. Validasi Input (Termasuk patient_id)
        $validatedData = $request->validate([
            'patient_id'     => 'required|string|exists:patients,_id', // Validasi ID Pasien
            'pregnancies'    => 'required|integer|min:0',
            'glucose'        => 'required|numeric|min:0',
            'blood_pressure' => 'required|numeric|min:0',
            'bmi'            => 'required|numeric|min:0',
            'age'            => 'required|integer|min:1',
        ]);
        // Simpan data yang divalidasi untuk dikirim ke API dan ditampilkan lagi
        $input = $validatedData;

        try {
            // Ambil URL API dari config
            $apiUrl = config('services.prediction_api.url', 'http://127.0.0.1:5000/predict');

            // Kirim data (tanpa patient_id jika API tidak membutuhkannya) ke API Flask
            $dataForApi = collect($input)->except('patient_id')->toArray(); // Hapus patient_id jika tidak perlu untuk API
            $response = Http::post($apiUrl, $dataForApi);

            // Cek respons sukses
            if ($response->successful()) {
                $apiResult = $response->json();
                $predictionResult = $apiResult['result'] ?? null; // Ambil hasil dari response API

                // --- Persiapan untuk menampilkan view dengan hasil ---
                // 2. Ambil lagi data pasien untuk dropdown
                $patients = Patient::select('_id', 'name')->orderBy('name', 'asc')->get();

                // 3. Ambil nama pasien yang dipilih
                $selectedPatient = Patient::find($input['patient_id']);
                $selected_patient_name = $selectedPatient ? $selectedPatient->name : 'ID Pasien Tidak Ditemukan';
                // --- Akhir Persiapan ---

                // Menampilkan view lagi dengan hasil, input sebelumnya, daftar pasien, dan nama pasien terpilih
                return view('admin.prediksi.index', [
                    'patients' => $patients,
                    'result' => $predictionResult,
                    'input' => $input, // Mengirim kembali SEMUA input (termasuk patient_id)
                    'selected_patient_name' => $selected_patient_name
                ]);
            }

            // Gagal menghubungi API (respons error)
            return redirect()->route('admin.prediksi.index') // Ganti nama route jika perlu
                             ->with('error', 'Gagal menghubungi API prediksi. Status: ' . $response->status())
                             ->withInput(); // Kirim input kembali

        } catch (ConnectionException $e) {
            // Tangani error koneksi
             return redirect()->route('admin.prediksi.index') // Ganti nama route jika perlu
                              ->with('error', 'Tidak dapat terhubung ke server prediksi.')
                              ->withInput();
        } catch (Exception $e) {
            // Tangani error umum lainnya
            // Log::error($e); // Sebaiknya log errornya
             return redirect()->route('admin.prediksi.index') // Ganti nama route jika perlu
                              ->with('error', 'Terjadi kesalahan: ' . $e->getMessage())
                              ->withInput();
        }
    }

    /**
     * Menyimpan hasil prediksi ke database
     */
    public function savePrediction(Request $request)
    {
        // 1. Validasi data yang akan disimpan (termasuk patient_id dan result)
        $validatedData = $request->validate([
            'patient_id'     => 'required|string|exists:patients,_id', // Validasi ID Pasien
            'pregnancies'    => 'required|integer|min:0',
            'glucose'        => 'required|numeric|min:0',
            'blood_pressure' => 'required|numeric|min:0',
            'bmi'            => 'required|numeric|min:0',
            'age'            => 'required|integer|min:1',
            'result'         => 'required|numeric', // Validasi hasil prediksi (sesuaikan tipe jika perlu)
        ]);

        try {
            // Setup koneksi MongoDB (dari env)
            $mongoUri = env('DB_URI', 'mongodb://localhost:27017'); // Gunakan DB_URI jika sudah diset, jika tidak pakai default
            $mongo = new Mongo($mongoUri);
            $dbName = env('DB_DATABASE', 'prediksi_diabetes'); // Gunakan DB_DATABASE jika sudah diset
            $collectionName = 'prediction_histories'; // Ganti nama collection jika perlu (misal: prediction_histories)
            $collection = $mongo->$dbName->$collectionName;

            // Siapkan data untuk disimpan (termasuk patient_id)
            $data = [
                'patient_id'     => $validatedData['patient_id'], // <-- TAMBAHKAN patient_id
                'pregnancies'    => (int) $validatedData['pregnancies'],
                'glucose'        => (float) $validatedData['glucose'], // Gunakan float untuk presisi
                'blood_pressure' => (float) $validatedData['blood_pressure'], // Gunakan float
                'bmi'            => (float) $validatedData['bmi'],
                'age'            => (int) $validatedData['age'],
                'result'         => ($validatedData['result'] == 1) ? 1 : 0, // Pastikan 0 atau 1 (atau tipe lain sesuai kebutuhan)
                'prediction_timestamp' => new UTCDateTime() // Timestamp saat prediksi disimpan
            ];

            // Simpan data ke MongoDB
            $collection->insertOne($data);

            // Redirect ke halaman index prediksi dengan pesan sukses
            return redirect()->route('admin.prediksi.index') // Ganti nama route jika perlu
                             ->with('success', 'Data prediksi berhasil disimpan.');

        } catch (Exception $e) {
            // Log::error($e); // Log errornya
            return redirect()->route('admin.prediksi.index') // Ganti nama route jika perlu
                             ->with('error', 'Gagal menyimpan data prediksi: ' . $e->getMessage())
                             ->withInput($request->except('result')); // Kirim input kembali
        }
    }

    /**
     * Membersihkan hasil (kembali ke form awal)
     */
    public function clearResult() // Mungkin tidak perlu lagi jika form selalu menampilkan daftar pasien
    {
        return redirect()->route('admin.prediksi.index'); // Ganti nama route jika perlu
    }

    // Method submit() sepertinya tidak digunakan untuk alur web ini, bisa dihapus jika tidak perlu.
    /*
    public function submit(Request $request)
    {
        return response()->json(['message' => 'Prediction processed!']);
    }
    */
}