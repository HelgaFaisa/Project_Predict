<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Patient;
use App\Models\PredictionHistory;
use App\Models\EducationArticle; // Pastikan ini sudah di-import
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class DashboardController extends Controller
{
    public function index()
    {
        // Data Sambutan
        $userName = Auth::check() ? Auth::user()->name : 'Dokter';

        // Statistik Kartu
        $totalActivePatients = Patient::count();
        $newPatientsThisWeek = Patient::where('created_at', '>=', Carbon::now()->startOfWeek())->count();
        $newPredictionsToday = PredictionHistory::where('prediction_timestamp', '>=', Carbon::now()->startOfDay())->count();
        $highRiskPredictionsCount = PredictionHistory::where('result', 1)->count();
        $educationArticleCount = EducationArticle::where('status', 'published')->count();

        // Daftar Pasien Terbaru (Ringkasan)
        $recentPatientsData = [];
        $recentPatients = Patient::latest()->take(5)->get();
        foreach ($recentPatients as $patient) {
            $latestPrediction = PredictionHistory::where('patient_id', $patient->_id)
                                                ->latest('prediction_timestamp')
                                                ->first();
            $recentPatientsData[] = [
                'patient' => $patient,
                'latest_prediction_status' => $latestPrediction ? ($latestPrediction->result == 1 ? 'Positif' : 'Negatif') : 'Belum Ada',
                'latest_prediction_date' => $latestPrediction ? $latestPrediction->prediction_timestamp : null,
                'registration_date' => $patient->created_at,
            ];
        }

        // Data untuk Grafik Tren Pasien Baru
        $patientTrendLabels = [];
        $patientTrendData = [];
        $numberOfWeeksForTrend = 12;
        $startDateForTrend = Carbon::now()->subWeeks($numberOfWeeksForTrend - 1)->startOfWeek();
        $endDateForTrend = Carbon::now()->endOfWeek();
        $allPatientsInTrendPeriod = Patient::whereBetween('created_at', [$startDateForTrend, $endDateForTrend])
                                        ->orderBy('created_at', 'asc')
                                        ->get(['created_at']);
        $patientsGroupedByWeek = $allPatientsInTrendPeriod->groupBy(function($patientForGroup) {
            $createdDate = $patientForGroup->created_at instanceof Carbon ? $patientForGroup->created_at : Carbon::parse($patientForGroup->created_at);
            return $createdDate->format("W-Y");
        });
        for ($i = $numberOfWeeksForTrend - 1; $i >= 0; $i--) {
            $loopDate = Carbon::now()->subWeeks($i);
            $weekKey = $loopDate->format("W-Y");
            $patientTrendLabels[] = $loopDate->startOfWeek()->isoFormat('D MMM') . ' - ' . $loopDate->endOfWeek()->isoFormat('D MMM');
            $patientTrendData[] = isset($patientsGroupedByWeek[$weekKey]) ? count($patientsGroupedByWeek[$weekKey]) : 0;
        }

        // Data untuk Grafik Distribusi Hasil Prediksi Diabetes
        $allPredictionsCount = PredictionHistory::count();
        $positivePredictions = $highRiskPredictionsCount;
        $negativePredictions = max(0, $allPredictionsCount - $positivePredictions);
        $predictionDistributionLabels = ['Positif (Risiko Tinggi)', 'Negatif (Risiko Rendah)'];
        $predictionDistributionData = [$positivePredictions, $negativePredictions];

        // Ambil 3 Artikel Edukasi Terbaru yang Sudah Dipublikasikan
        $recentEducationArticles = EducationArticle::published() // Menggunakan scope published() dari model
                                      ->latest('published_at')    // Urutkan berdasarkan tanggal publikasi terbaru
                                      ->take(3)                   // Ambil 3 artikel
                                      ->get();

        return view('admin.dashboard', compact(
            'userName',
            'totalActivePatients',
            'newPatientsThisWeek',
            'newPredictionsToday',
            'highRiskPredictionsCount',
            'educationArticleCount',
            'recentPatientsData',
            'patientTrendLabels',
            'patientTrendData',
            'predictionDistributionLabels',
            'predictionDistributionData',
            'recentEducationArticles' // Kirim data artikel terbaru ke view
        ));
    }
}
