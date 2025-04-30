<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use MongoDB\Client as Mongo;

class PredictController extends Controller
{
    public function index()
    {
        return view('admin.prediksi.index');
    }
    public function predict(Request $request)
    {
        // Ambil data input dari form
        $input = $request->only(['pregnancies', 'glucose', 'blood_pressure', 'bmi', 'age']);
    
        // Kirim data ke API Flask
        $response = Http::post('http://127.0.0.1:5000/predict', $input);
    
        // Cek apakah respons sukses
        if ($response->successful()) {
            $result = $response->json();
    
            // Tampilkan di halaman yang sama (admin.prediksi.index)
            return view('admin.prediksi.index', [
                'result' => $result['result'],
                'input' => $input
            ]);
        }
    
        // Jika error dari API
        return redirect()->route('predict.index')->with('error', 'Gagal menghubungi API prediksi.');
    }
    

    public function savePrediction(Request $request)
    {
        // Koneksi ke MongoDB
        $mongo = new Mongo(env('MONGO_URI', 'mongodb://localhost:27017'));
        $collection = $mongo->prediksi_diabetes->prediksi_pasien;

        // Siapkan data untuk disimpan
        $data = [
            'pregnancies' => (int) $request->pregnancies,
            'glucose' => (int) $request->glucose,
            'blood_pressure' => (int) $request->blood_pressure,
            'bmi' => (float) $request->bmi,
            'age' => (int) $request->age,
            'result' => (int) $request->result,
            'timestamp' => now()
        ];

        // Simpan ke MongoDB
        $collection->insertOne($data);

        // Redirect kembali ke form dengan pesan sukses
        return redirect('/predict')->with('success', 'Data berhasil disimpan ke MongoDB.');
    }

    public function clearResult()
    {
        // Cukup redirect ke halaman awal tanpa menyimpan data
        return redirect('/predict');
    }
    public function submit(Request $request)
    {
        // logic prediksi kamu di sini
        return response()->json([
            'message' => 'Prediction processed!'
        ]);
    }
}
