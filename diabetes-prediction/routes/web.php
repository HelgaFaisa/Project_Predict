<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\PredictController;
/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Route::get('/predict', function () {
    return view('predict');
});

Route::post('/predict', [PredictController::class, 'predict']);
Route::post('/predict/save', [PredictController::class, 'savePrediction']);
Route::get('/predict/clear', [PredictController::class, 'clearResult']);
// routes/web.php
Route::get('/dashboard', [App\Http\Controllers\DashboardController::class, 'index'])->name('dashboard');
// route gejala
Route::get('/kelola-gejala', function () {
    return view('gejala.index');
});

