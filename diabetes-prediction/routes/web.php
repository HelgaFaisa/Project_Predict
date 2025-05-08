<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\Auth\RegisterController; // Import RegisterController
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\ProfileController; // Import ProfileController
// ... use statements lain ...
use App\Http\Controllers\Admin\PatientController;
use App\Http\Controllers\Admin\PredictController;
use App\Http\Controllers\Admin\EducationArticleController;
use App\Http\Controllers\Admin\PatientAccountController;
use App\Http\Controllers\Admin\PredictionHistoryController;
use App\Http\Controllers\Admin\GejalaController;


// Landing Page
Route::get('/', function () {
    return view('welcome');
})->name('landing');

// Public Prediction Routes (jika masih ada)
Route::prefix('predict')->name('predict.')->group(function () {
    // ... route public predict ...
});

// Authentication Routes
Route::get('/login', [AuthController::class, 'showLoginForm'])->name('login');
Route::post('/login', [AuthController::class, 'login']);
Route::post('/logout', [AuthController::class, 'logout'])->name('logout')->middleware('auth'); // Logout butuh login

// Registration Routes
Route::get('/register', [RegisterController::class, 'showRegistrationForm'])->name('register');
Route::post('/register', [RegisterController::class, 'register']);


// Admin Routes
Route::prefix('admin')
    ->name('admin.')
    ->middleware(['auth']) // Pastikan middleware auth Anda sudah benar
    ->group(function () {

        Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');

        // Profile Routes
        Route::get('/profile', [ProfileController::class, 'index'])->name('profile.index');
        Route::put('/profile/password', [ProfileController::class, 'updatePassword'])->name('profile.password.update');
        // Hapus Route::resource('profile', ProfileController::class); jika hanya butuh index & updatePassword

        // Pasien Routes
        Route::resource('pasien', PatientController::class); // Tetap gunakan resource jika CRUD lengkap

        // Prediksi Routes
        Route::prefix('prediksi')->name('prediksi.')->group(function () {
            Route::get('/', [PredictController::class, 'index'])->name('index');
            Route::post('/submit', [PredictController::class, 'predict'])->name('submit');
            Route::post('/save', [PredictController::class, 'savePrediction'])->name('save');
        });

        // Edukasi Routes
        Route::resource('education', EducationArticleController::class)->parameters([
            'education' => 'educationArticle'
        ]);

        // Akun Pasien Routes
        Route::resource('patient-accounts', PatientAccountController::class)->parameters([
            'patient-accounts' => 'patientAccount'
        ]);

        // Riwayat Prediksi Routes
        Route::get('/prediction-history', [PredictionHistoryController::class, 'index'])->name('prediction_history.index');
        Route::delete('/prediction-history/{predictionHistory}', [PredictionHistoryController::class, 'destroy'])->name('prediction_history.destroy');

        // Gejala Routes
        Route::prefix('gejala')->name('gejala.')->group(function () {
            Route::get('/', [GejalaController::class, 'index'])->name('index');
            Route::post('/', [GejalaController::class, 'store'])->name('store');
            Route::get('/{gejala}/edit', [GejalaController::class, 'edit'])->name('edit');
            Route::put('/{gejala}', [GejalaController::class, 'update'])->name('update');
            Route::delete('/{gejala}', [GejalaController::class, 'destroy'])->name('destroy');
            Route::put('/{gejala}/toggle-status', [GejalaController::class, 'toggleStatus'])->name('toggleStatus');
        });
// Authentication Routes
Route::middleware('guest')->group(function () {
    Route::get('/login', [AuthController::class, 'showLoginForm'])->name('login');
    Route::post('/login', [AuthController::class, 'login']); // Method login di AuthController

    Route::get('/register', [RegisterController::class, 'showRegistrationForm'])->name('register');
    Route::post('/register', [RegisterController::class, 'register']);
});

// Logout Route
Route::post('/logout', [AuthController::class, 'logout'])->name('logout')->middleware('auth');
});

