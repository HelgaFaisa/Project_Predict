<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\Auth\RegisterController;
use App\Http\Controllers\PublicPageController; // Ditambahkan untuk halaman publik
// Admin Controllers
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\PatientController;
use App\Http\Controllers\Admin\PredictController;
use App\Http\Controllers\Admin\EducationArticleController;
use App\Http\Controllers\Admin\PatientAccountController;
use App\Http\Controllers\Admin\PredictionHistoryController;
use App\Http\Controllers\Admin\ProfileController;
use App\Http\Controllers\Admin\GejalaController;
// Public Predict Controller (jika digunakan)
use App\Http\Controllers\PublicPredictController as PublicDiabetesPredictController; // Alias untuk menghindari konflik jika ada

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
*/

// Public Facing Routes (Menggunakan PublicPageController)
Route::get('/', [PublicPageController::class, 'home'])->name('public.home'); // Beranda
Route::get('/artikel', [PublicPageController::class, 'articlesIndex'])->name('public.articles.index'); // Daftar Artikel
Route::get('/artikel/{slug}', [PublicPageController::class, 'articlesShow'])->name('public.articles.show'); // Detail Artikel
Route::get('/tentang-kami', [PublicPageController::class, 'about'])->name('public.about'); // Tentang Kami

// Public Prediction Routes (Diaktifkan sesuai referensi, sesuaikan jika tidak diperlukan)
Route::prefix('prediksi-diabetes')->name('public.predict.')->group(function () { // Mengubah prefix agar tidak bentrok dengan admin
    Route::get('/', [PublicDiabetesPredictController::class, 'showForm'])->name('form');
    Route::post('/', [PublicDiabetesPredictController::class, 'predict'])->name('submit');
    Route::post('/save', [PublicDiabetesPredictController::class, 'savePrediction'])->name('save'); // Pertimbangkan apakah ini perlu untuk publik
    Route::get('/clear', [PublicDiabetesPredictController::class, 'clearResult'])->name('clear');
});

// Authentication Routes
Route::middleware('guest')->group(function () { // Hanya untuk pengguna yang belum login
    Route::get('/login', [AuthController::class, 'showLoginForm'])->name('login');
    Route::post('/login', [AuthController::class, 'login']);
    Route::get('/register', [RegisterController::class, 'showRegistrationForm'])->name('register');
    Route::post('/register', [RegisterController::class, 'register']);
});

// Logout Route (Hanya untuk pengguna yang sudah login)
Route::post('/logout', [AuthController::class, 'logout'])->name('logout')->middleware('auth');


// Admin Routes
Route::prefix('admin')
    ->name('admin.')
    ->middleware(['auth']) // Pastikan middleware auth Anda sudah benar
    ->group(function () {

        Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');

        // Profile Routes
        Route::get('/profile', [ProfileController::class, 'index'])->name('profile.index');
        Route::put('/profile/password', [ProfileController::class, 'updatePassword'])->name('profile.password.update');

        // Pasien Routes
        Route::resource('pasien', PatientController::class);

        // Prediksi Admin Routes
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

        // Gejala Routes (Sesuai struktur yang Anda berikan sebelumnya)
        Route::get('/gejala', [GejalaController::class, 'index'])->name('gejala.index');
        Route::get('/gejala/create', [GejalaController::class, 'create'])->name('gejala.create');
        Route::post('/gejala', [GejalaController::class, 'store'])->name('gejala.store');
        Route::get('/gejala/{gejala}/edit', [GejalaController::class, 'edit'])->name('gejala.edit');
        Route::put('/gejala/{gejala}', [GejalaController::class, 'update'])->name('gejala.update');
        Route::delete('/gejala/{gejala}', [GejalaController::class, 'destroy'])->name('gejala.destroy');
        Route::patch('/gejala/{gejala}/toggle-status', [GejalaController::class, 'toggleStatus'])->name('gejala.toggleStatus');
        // Jika Anda ingin Gejala di dalam prefix group seperti di artifact:
        // Route::prefix('gejala')->name('gejala.')->group(function () {
        //     Route::get('/', [GejalaController::class, 'index'])->name('index');
        //     Route::post('/', [GejalaController::class, 'store'])->name('store');
        //     Route::get('/{gejala}/edit', [GejalaController::class, 'edit'])->name('edit');
        //     Route::put('/{gejala}', [GejalaController::class, 'update'])->name('update');
        //     Route::delete('/{gejala}', [GejalaController::class, 'destroy'])->name('destroy');
        //     Route::put('/{gejala}/toggle-status', [GejalaController::class, 'toggleStatus'])->name('toggleStatus');
        // });
});

// require __DIR__.'/auth.php'; // Jika Anda menggunakan file auth.php terpisah dari Breeze/Jetstream
