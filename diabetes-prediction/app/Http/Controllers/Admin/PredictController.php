<?php

namespace App\Http\Controllers\Admin; // <-- TAMBAHKAN \Admin
use App\Http\Controllers\Controller; // <-- TAMBAHKAN BARIS INI
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use MongoDB\Client as Mongo; // <-- Penggunaan driver MongoDB langsung

class PredictController extends Controller
{
    public function index()
    {
        // Menampilkan view form awal
        return view('admin.prediksi.index');
    }

    public function predict(Request $request)
    {
        // Ambil data input dari form
        // PERBAIKAN 1: Tambahkan Validasi Input
        $input = $request->only(['pregnancies', 'glucose', 'blood_pressure', 'bmi', 'age']);

        try {
            // PERBAIKAN 2: Pindahkan URL API ke Konfigurasi
            $apiUrl = config('services.prediction_api.url', 'http://127.0.0.1:5000/predict'); // Contoh
            // Kirim data ke API Flask
            $response = Http::post($apiUrl, $input);

            // Cek apakah respons sukses
            if ($response->successful()) {
                $result = $response->json();

                // Menampilkan view lagi dengan hasil
                // PERTIMBANGAN: Gunakan Pola Post/Redirect/Get (PRG)?
                return view('admin.prediksi.index', [
                    'result' => $result['result'] ?? null, // Pastikan key 'result' sesuai dari API Flask
                    'input' => $input // Mengirim kembali input agar form bisa diisi ulang
                ]);
            }

            // Gagal menghubungi API (bukan exception, tapi response error)
            // PERBAIKAN 3: Gunakan nama route yang konsisten
            return redirect()->route('predict.index') // Pastikan 'predict.index' adalah nama route untuk method index()
                             ->with('error', 'Gagal menghubungi API prediksi. Status: ' . $response->status())
                             ->withInput(); // Kirim input kembali jika gagal

        } catch (\Illuminate\Http\Client\ConnectionException $e) {
            // Tangani error koneksi spesifik
             return redirect()->route('predict.index') // Gunakan nama route yang konsisten
                             ->with('error', 'Tidak dapat terhubung ke server prediksi.')
                             ->withInput();
        } catch (\Exception $e) {
            // Tangani error umum lainnya
             return redirect()->route('predict.index') // Gunakan nama route yang konsisten
                             ->with('error', 'Terjadi kesalahan: ' . $e->getMessage())
                             ->withInput();
        }
    }

    public function savePrediction(Request $request)
    {
        // PERBAIKAN 1 (Lagi): Tambahkan Validasi Input (termasuk 'result')
        // Asumsi 'result' dikirim kembali dari form setelah ditampilkan

        try {
            // PERBAIKAN 4: Gunakan Abstraksi Database Laravel (jenssegers/mongodb)
            // Contoh jika menggunakan jenssegers/mongodb dan model Prediction:
            /*
            $dataToSave = $request->validate([
                'pregnancies' => 'required|integer|min:0',
                'glucose' => 'required|numeric|min:0',
                'blood_pressure' => 'required|numeric|min:0',
                'bmi' => 'required|numeric|min:0',
                'age' => 'required|integer|min:0',
                'result' => 'required|integer', // Sesuaikan tipe data jika perlu
            ]);
            App\Models\Prediction::create($dataToSave); // Eloquent akan menangani timestamp jika di-setting di model
            */

            // Cara Anda saat ini (driver langsung):
            $mongoUri = env('MONGO_URI', 'mongodb://localhost:27017'); // PERBAIKAN 2: URI dari env
            $mongo = new Mongo($mongoUri);
            // PERBAIKAN 2: Nama DB & Collection dari env/config (opsional)
            $dbName = env('MONGO_DB_DATABASE', 'prediksi_diabetes');
            $collectionName = 'prediksi_pasien'; // Bisa juga dari config jika perlu
            $collection = $mongo->$dbName->$collectionName;

            // Siapkan data (Type casting bagus!)
            $data = [
                'pregnancies' => (int) $request->pregnancies,
                'glucose' => (int) $request->glucose, // Atau float jika perlu desimal
                'blood_pressure' => (int) $request->blood_pressure, // Atau float
                'bmi' => (float) $request->bmi,
                'age' => (int) $request->age,
                'result' => isset($request->result) ? (int) $request->result : null, // Pastikan result ada & handle null
                'timestamp' => new \MongoDB\BSON\UTCDateTime() // Gunakan tipe data BSON untuk MongoDB
                // 'timestamp' => now() // Jika menggunakan Eloquent (jenssegers/mongodb)
            ];

            $collection->insertOne($data);

            // PERBAIKAN 3: Konsistensi nama route
            // Mungkin route 'predict.index' lebih tepat daripada 'predict.form'?
            return redirect()->route('predict.index')->with('success', 'Data prediksi berhasil disimpan.');

        } catch (\Exception $e) {
            // Log error akan sangat membantu di sini: Log::error($e);
            // PERBAIKAN 3: Konsistensi nama route
            return redirect()->route('predict.index')
                             ->with('error', 'Gagal menyimpan data: ' . $e->getMessage())
                             ->withInput($request->except('result')); // Kirim input kembali, kecuali result yg mungkin salah
        }
    }

    // Fungsi ini tampaknya hanya me-refresh halaman form
    public function clearResult()
    {
        // PERBAIKAN 3: Konsistensi nama route
        return redirect()->route('predict.index');
    }

    // PERBAIKAN 5: Apa tujuan method submit() ini?
    // Jika tidak digunakan, hapus. Jika untuk API, pastikan routing & logic-nya sesuai.
    public function submit(Request $request)
    {
        // Logic method ini tidak jelas dalam konteks form web standar.
        return response()->json([
            'message' => 'Prediction processed!'
        ]);
    }
}