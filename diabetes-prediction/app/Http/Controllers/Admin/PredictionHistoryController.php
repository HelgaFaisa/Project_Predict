<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\PredictionHistory;
use App\Models\Patient; // Untuk mengambil nama pasien jika difilter
use Illuminate\Http\Request;

class PredictionHistoryController extends Controller
{
    /**
     * Menampilkan daftar semua riwayat prediksi, bisa difilter berdasarkan pasien.
     */
    public function index(Request $request)
    {
        $query = PredictionHistory::with('patient') // Eager load data pasien terkait
                                  ->latest('prediction_timestamp'); // Urutkan terbaru dulu

        $patientFilter = null; // Untuk menyimpan data pasien jika difilter

        // Filter berdasarkan patient_id jika ada di request
        if ($request->has('patient_id')) {
            $patientId = $request->input('patient_id');
            $query->where('patient_id', $patientId);
            $patientFilter = Patient::find($patientId); // Ambil data pasien untuk judul halaman
        }

        // Tambahkan filter lain jika perlu (misal berdasarkan tanggal, hasil)
        // if ($request->has('result')) {
        //     $query->where('result', $request->input('result'));
        // }
        // if ($request->has('date_from')) {
        //     $query->where('prediction_timestamp', '>=', $request->input('date_from'));
        // }
        // if ($request->has('date_to')) {
        //     $query->where('prediction_timestamp', '<=', $request->input('date_to'));
        // }

        $histories = $query->paginate(15)->appends($request->query()); // Paginasi dan sertakan query string

        return view('admin.prediction_history.index', compact('histories', 'patientFilter'));
    }

    /**
     * Menghapus entri riwayat prediksi (Opsional).
     * Anda mungkin ingin menambahkan fitur ini.
     */
    public function destroy(PredictionHistory $predictionHistory) // Menggunakan Route Model Binding
    {
        try {
            $predictionHistory->delete();
            return redirect()->back()->with('success', 'Riwayat prediksi berhasil dihapus.');
        } catch (\Exception $e) {
            \Illuminate\Support\Facades\Log::error('Error deleting prediction history: ' . $e->getMessage());
            return redirect()->back()->with('error', 'Gagal menghapus riwayat prediksi.');
        }
    }
}

