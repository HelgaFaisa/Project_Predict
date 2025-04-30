<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\GejalaController;
use App\Http\Controllers\Admin\PasienController;
use App\Http\Controllers\Admin\PengaturanController;
use App\Http\Controllers\PredictController;
use App\Http\Controllers\PublicPredictController;

Route::get('/', function () {
    return view('welcome');
})->name('landing');

Route::prefix('predict')->name('predict.')->group(function () {
    Route::get('/', function () {
        return view('admin.prediksi.index');
    })->name('form');
    Route::post('/', [PublicPredictController::class, 'predict'])->name('submit');
    Route::post('/save', [PublicPredictController::class, 'savePrediction'])->name('save');
    Route::get('/clear', [PublicPredictController::class, 'clearResult'])->name('clear');
});
Route::post('/logout', [AuthenticatedSessionController::class, 'destroy'])
            ->middleware('auth') // Pastikan hanya user terautentikasi
            ->name('logout');
Route::prefix('admin')->name('admin.')->group(function () {
    Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');

    Route::prefix('gejala')->name('gejala.')->group(function () {
        Route::get('/', [GejalaController::class, 'index'])->name('index');
        Route::post('/', [GejalaController::class, 'store'])->name('store');
        Route::get('/{gejala}/edit', [GejalaController::class, 'edit'])->name('edit');
        Route::put('/{gejala}', [GejalaController::class, 'update'])->name('update');
        Route::delete('/{gejala}', [GejalaController::class, 'destroy'])->name('destroy');
        Route::put('/{gejala}/toggle-status', [GejalaController::class, 'toggleStatus'])->name('toggleStatus');
    });

    Route::prefix('pasien')->name('pasien.')->group(function () {
        Route::get('/', [PasienController::class, 'index'])->name('index');
    });

    Route::get('/pengaturan', [PengaturanController::class, 'index'])->name('pengaturan.index');

    Route::prefix('prediksi')->name('prediksi.')->group(function () {
        Route::get('/', [PredictController::class, 'index'])->name('index');
        Route::post('/', [PredictController::class, 'predict'])->name('submit'); // Ubah 'submit' ke 'predict'
        Route::post('/save', [PredictController::class, 'savePrediction'])->name('save'); // Sesuaikan method
    });
    
    
});
