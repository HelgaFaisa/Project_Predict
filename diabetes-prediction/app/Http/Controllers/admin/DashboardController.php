<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Patient;
use App\Models\PredictionHistory;
use App\Models\EducationArticle;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB; // Digunakan untuk DB::raw jika diperlukan, namun kita hindari untuk MongoDB
use Illuminate\Support\Facades\Log;

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
        $highRiskPredictionsCount = PredictionHistory::where('result', '1')->count();
        $educationArticleCount = EducationArticle::where('status', 'published')->count();

        // Daftar Pasien Terbaru (Tidak ditampilkan di dashboard ini, tapi logika ada jika diperlukan)
        // $recentPatientsData = [];
        // $recentPatients = Patient::latest()->take(5)->get();
        // foreach ($recentPatients as $patient) {
        //     $latestPrediction = PredictionHistory::where('patient_id', $patient->_id)
        //                                         ->latest('prediction_timestamp')
        //                                         ->first();
        //     $recentPatientsData[] = [
        //         'patient' => $patient,
        //         'latest_prediction_status' => $latestPrediction ? ($latestPrediction->result == 1 ? 'Positif' : 'Negatif') : 'Belum Ada',
        //         'latest_prediction_date' => $latestPrediction ? $latestPrediction->prediction_timestamp : null,
        //         'registration_date' => $patient->created_at,
        //     ];
        // }

        // Data Grafik Tren Pasien Baru
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
            return $createdDate->format("W-Y"); // Format: "NomorMinggu-Tahun"
        });
        for ($i = $numberOfWeeksForTrend - 1; $i >= 0; $i--) {
            $loopDate = Carbon::now()->subWeeks($i);
            $weekKey = $loopDate->format("W-Y");
            $patientTrendLabels[] = $loopDate->startOfWeek()->isoFormat('D MMM') . ' - ' . $loopDate->endOfWeek()->isoFormat('D MMM');
            $patientTrendData[] = isset($patientsGroupedByWeek[$weekKey]) ? count($patientsGroupedByWeek[$weekKey]) : 0;
        }

        // Data Grafik Distribusi Hasil Prediksi Diabetes
        $allPredictionsCount = PredictionHistory::count();
        $positivePredictions = $highRiskPredictionsCount; // Sudah dihitung untuk kartu statistik
        $negativePredictions = max(0, $allPredictionsCount - $positivePredictions);
        $predictionDistributionLabels = ['Positif (Risiko Tinggi)', 'Negatif (Risiko Rendah)'];
        $predictionDistributionData = [$positivePredictions, $negativePredictions];

        // Data Grafik Jumlah Prediksi per Kelompok Kehamilan
        $allPregnanciesHistories = PredictionHistory::whereNotNull('pregnancies')->get(['pregnancies']);
        $pregnanciesGroupLabels = [];
        $pregnanciesGroupData = [];
        $maxPregnancyGroup = 5;
        $tempPregnancyCounts = [];
        foreach ($allPregnanciesHistories as $history) {
            $pregnancyCount = $history->pregnancies;
            if ($pregnancyCount >= $maxPregnancyGroup) {
                $tempPregnancyCounts[$maxPregnancyGroup . '+'] = ($tempPregnancyCounts[$maxPregnancyGroup . '+'] ?? 0) + 1;
            } else {
                $tempPregnancyCounts[(string)$pregnancyCount] = ($tempPregnancyCounts[(string)$pregnancyCount] ?? 0) + 1;
            }
        }
        $numericKeysPregnancy = [];
        foreach(array_keys($tempPregnancyCounts) as $key){
            if(is_numeric($key)){ $numericKeysPregnancy[] = (int)$key; }
        }
        sort($numericKeysPregnancy);
        foreach($numericKeysPregnancy as $key){
            $pregnanciesGroupLabels[] = (string)$key;
            $pregnanciesGroupData[] = $tempPregnancyCounts[(string)$key];
        }
        if(isset($tempPregnancyCounts[$maxPregnancyGroup . '+'])){
            $pregnanciesGroupLabels[] = $maxPregnancyGroup . '+';
            $pregnanciesGroupData[] = $tempPregnancyCounts[$maxPregnancyGroup . '+'];
        }

        // Data Grafik Jumlah Pasien per Kelompok Umur
        $patientsForAge = Patient::whereNotNull('date_of_birth')->get(['date_of_birth']);
        $ageGroups = ['<20' => 0, '20-29' => 0, '30-39' => 0, '40-49' => 0, '50-59' => 0, '60+' => 0];
        foreach ($patientsForAge as $patient) {
            try {
                $birthDate = Carbon::parse($patient->date_of_birth);
                $age = $birthDate->age;
                if ($age < 0) continue; // Abaikan tanggal lahir tidak valid
                if ($age < 20) $ageGroups['<20']++;
                elseif ($age <= 29) $ageGroups['20-29']++;
                elseif ($age <= 39) $ageGroups['30-39']++;
                elseif ($age <= 49) $ageGroups['40-49']++;
                elseif ($age <= 59) $ageGroups['50-59']++;
                else $ageGroups['60+']++;
            } catch (\Exception $e) {
                Log::warning('Could not parse date_of_birth for age grouping: ' . $patient->date_of_birth . ' Error: ' . $e->getMessage());
                continue;
            }
        }
        $ageGroupLabels = array_keys($ageGroups);
        $ageGroupData = array_values($ageGroups);

        // Data Grafik Jumlah Prediksi per Kelompok Gula Darah
        $glucoseData = PredictionHistory::whereNotNull('glucose')->get(['glucose']);
        $glucoseGroups = ['<70' => 0, '70-99' => 0, '100-125' => 0, '126-180' => 0, '>180' => 0];
        foreach ($glucoseData as $history) {
            $glucose = $history->glucose;
            if ($glucose === null) continue;
            if ($glucose < 70) $glucoseGroups['<70']++;
            elseif ($glucose <= 99) $glucoseGroups['70-99']++;
            elseif ($glucose <= 125) $glucoseGroups['100-125']++;
            elseif ($glucose <= 180) $glucoseGroups['126-180']++;
            else $glucoseGroups['>180']++;
        }
        $glucoseGroupLabels = array_keys($glucoseGroups);
        $glucoseGroupData = array_values($glucoseGroups);

        return view('admin.dashboard', compact( // Pastikan nama view adalah 'admin.dashboard'
            'userName',
            'totalActivePatients',
            'newPatientsThisWeek',
            'newPredictionsToday',
            'highRiskPredictionsCount',
            'educationArticleCount',
            // 'recentPatientsData', // Dikomentari karena tidak ada tabel pasien di dashboard saat ini
            'patientTrendLabels',
            'patientTrendData',
            'predictionDistributionLabels',
            'predictionDistributionData',
            'pregnanciesGroupLabels',
            'pregnanciesGroupData',
            'ageGroupLabels',
            'ageGroupData',
            'glucoseGroupLabels',
            'glucoseGroupData'
        ));
    }
}
