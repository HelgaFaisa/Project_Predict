<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\GejalaController;
use App\Http\Controllers\Admin\PredictController; 
use App\Http\Controllers\Admin\PatientController;
use App\Http\Controllers\Admin\ProfileController;
use App\Http\Controllers\PublicPredictController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\Admin\EducationArticleController;
use App\Http\Controllers\Admin\PatientAccountController;

Route::get('/login', [AuthController::class, 'showLoginForm'])->name('login');
Route::post('/login', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout'])->name('logout');

Route::get('/', function () {
    return view('welcome');
})->name('landing');

Route::prefix('predict')->name('predict.')->group(function () {
    Route::get('/', [PublicPredictController::class, 'showForm'])->name('form');
    Route::post('/', [PublicPredictController::class, 'predict'])->name('submit');
    Route::post('/save', [PublicPredictController::class, 'savePrediction'])->name('save');
    Route::get('/clear', [PublicPredictController::class, 'clearResult'])->name('clear');
});

Route::prefix('admin')
    ->name('admin.')
    ->middleware(['auth'])
    ->group(function () {

        Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');

        Route::resource('pasien', PatientController::class);

        Route::prefix('prediksi')->name('prediksi.')->group(function () {
            Route::get('/', [PredictController::class, 'index'])->name('index');
            // PENYESUAIAN DI SINI: 'submitPrediction' diubah menjadi 'predict'
            Route::post('/submit', [PredictController::class, 'predict'])->name('submit'); // <-- BARIS INI YANG DISESUAIKAN
            Route::post('/save', [PredictController::class, 'savePrediction'])->name('save');
        });

        Route::prefix('gejala')->name('gejala.')->group(function () {
            Route::get('/', [GejalaController::class, 'index'])->name('index');
            Route::post('/', [GejalaController::class, 'store'])->name('store');
            Route::get('/{gejala}/edit', [GejalaController::class, 'edit'])->name('edit');
            Route::put('/{gejala}', [GejalaController::class, 'update'])->name('update');
            Route::delete('/{gejala}', [GejalaController::class, 'destroy'])->name('destroy');
            Route::put('/{gejala}/toggle-status', [GejalaController::class, 'toggleStatus'])->name('toggleStatus');
        });

        Route::resource('education', EducationArticleController::class)->parameters([
            'education' => 'educationArticle' // Memberitahu Laravel nama parameter untuk route model binding
        ]);

        Route::resource('patient-accounts', PatientAccountController::class)->parameters([
            'patient-accounts' => 'patientAccount' // Untuk route model binding
        ]);

        Route::resource('profile', ProfileController::class);

});

// require __DIR__.'/auth.php'; // Jika Anda menggunakan file auth.php terpisah