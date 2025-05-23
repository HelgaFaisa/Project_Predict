<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Patient;
use App\Models\PredictionHistory;
use App\Models\EducationArticle;
use Carbon\Carbon;
use Carbon\CarbonPeriod; // Ditambahkan untuk iterasi tanggal
use Illuminate\Http\Request; // Ditambahkan
use Illuminate\Support\Facades\Auth;
// use Illuminate\Support\Facades\DB; // Tidak digunakan secara langsung di sini
use Illuminate\Support\Facades\Log;

class DashboardController extends Controller
{
    public function index(Request $request) // Ditambahkan Request $request
    {
        // Data Sambutan
        $userName = Auth::check() ? Auth::user()->name : 'Dokter';

        // --- PENGOLAHAN FILTER TANGGAL (HANYA UNTUK GRAFIK TREN PASIEN BARU) ---
        $inputStartDate = $request->input('start_date');
        $inputEndDate = $request->input('end_date');

        $filterStartDateForTrend = null;
        $filterEndDateForTrend = null;

        // Default ke 7 hari terakhir jika tidak ada input tanggal untuk grafik tren
        if ($inputStartDate && $inputEndDate) {
            try {
                $filterStartDateForTrend = Carbon::parse($inputStartDate)->startOfDay();
                $filterEndDateForTrend = Carbon::parse($inputEndDate)->endOfDay();
                // Pastikan end_date tidak sebelum start_date
                if ($filterEndDateForTrend->lt($filterStartDateForTrend)) {
                    $filterEndDateForTrend = $filterStartDateForTrend->copy()->endOfDay();
                }
            } catch (\Exception $e) {
                Log::error('Invalid date format for dashboard patient trend filter: ' . $e->getMessage());
                // Fallback ke default jika parsing gagal
                $filterEndDateForTrend = Carbon::now()->endOfDay();
                $filterStartDateForTrend = $filterEndDateForTrend->copy()->subDays(6)->startOfDay();
            }
        } else {
            // Default jika tidak ada filter tanggal dari request
            $filterEndDateForTrend = Carbon::now()->endOfDay();
            $filterStartDateForTrend = $filterEndDateForTrend->copy()->subDays(6)->startOfDay(); // Default 7 hari terakhir
        }
        
        // Variabel untuk mengisi ulang nilai filter di view
        $requestedStartDate = $inputStartDate ?? $filterStartDateForTrend->toDateString();
        $requestedEndDate = $inputEndDate ?? $filterEndDateForTrend->toDateString();


        // --- STATISTIK KARTU (SESUAI KODE ASLI ANDA, TIDAK DIFILTER TANGGAL) ---
        $totalActivePatients = Patient::count();
        $newPatientsThisWeek = Patient::where('created_at', '>=', Carbon::now()->startOfWeek())->count();
        $newPredictionsToday = PredictionHistory::where('prediction_timestamp', '>=', Carbon::now()->startOfDay())->count();
        $highRiskPredictionsCount = PredictionHistory::where('result', '1')->count(); // Ini adalah total, bukan per periode
        $educationArticleCount = EducationArticle::where('status', 'published')->count();


        // --- DATA GRAFIK TREN PASIEN BARU (JUMLAH PASIEN BARU PER HARI, DIFILTER) ---
        $patientTrendLabels = [];
        $patientTrendData = [];
        $dailyPatientCounts = [];

        $periodForTrend = CarbonPeriod::create($filterStartDateForTrend, $filterEndDateForTrend);
        foreach ($periodForTrend as $date) {
            $formattedDateLabel = $date->isoFormat('D MMM'); // Label: "17 Mei"
            $dateKey = $date->toDateString(); // Kunci: "YYYY-MM-DD"
            $patientTrendLabels[] = $formattedDateLabel;
            $dailyPatientCounts[$dateKey] = 0;
        }
        
        $patientsInFilteredPeriod = Patient::whereBetween('created_at', [$filterStartDateForTrend, $filterEndDateForTrend])
            ->orderBy('created_at', 'asc')
            ->get(['created_at'])
            ->groupBy(function ($patient) {
                $createdAtDate = $patient->created_at instanceof Carbon ? $patient->created_at : Carbon::parse($patient->created_at);
                return $createdAtDate->toDateString();
            });

        foreach ($patientsInFilteredPeriod as $dateKey => $patientsOnDay) {
            if (array_key_exists($dateKey, $dailyPatientCounts)) {
                $dailyPatientCounts[$dateKey] = count($patientsOnDay);
            }
        }
        $patientTrendData = array_values($dailyPatientCounts);
        // Pastikan $patientTrendLabels sudah sesuai dengan urutan $dailyPatientCounts jika ada hari tanpa data
        // Dengan pre-inisialisasi $dailyPatientCounts berdasarkan $periodForTrend, urutan seharusnya sudah benar.


        // --- DATA GRAFIK LAINNYA (SESUAI KODE ASLI ANDA, TIDAK DIFILTER TANGGAL) ---

        // Data Grafik Distribusi Hasil Prediksi Diabetes
        $allPredictionsCount = PredictionHistory::count();
        $positivePredictions = $highRiskPredictionsCount; // Menggunakan total dari kartu statistik
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
                if ($age < 0) continue;
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

        return view('admin.dashboard', compact(
            'userName',
            'totalActivePatients',
            'newPatientsThisWeek',       // Tetap menggunakan data asli
            'newPredictionsToday',      // Tetap menggunakan data asli
            'highRiskPredictionsCount', // Tetap menggunakan data asli (total)
            'educationArticleCount',
            'patientTrendLabels',       // Data sudah difilter
            'patientTrendData',         // Data sudah difilter
            'predictionDistributionLabels',
            'predictionDistributionData',
            'pregnanciesGroupLabels',
            'pregnanciesGroupData',
            'ageGroupLabels',
            'ageGroupData',
            'glucoseGroupLabels',
            'glucoseGroupData',
            'requestedStartDate',       // Untuk mengisi ulang filter di view
            'requestedEndDate'          // Untuk mengisi ulang filter di view
        ));
    }
}