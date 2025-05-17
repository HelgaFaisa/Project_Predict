<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\GejalaController;
use App\Http\Controllers\Api\PemeriksaanController;
use App\Http\Controllers\Api\EdukasiApiController;
use App\Http\Controllers\Api\PatientAuthController;
use App\Http\Controllers\Api\PatientProfileController;
use App\Http\Controllers\Api\PredictionHistoryApiController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\PatientController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::get('/gejala', [GejalaController::class, 'index']);
Route::post('/gejala', [GejalaController::class, 'store']);
Route::put('/gejala/{id}', [GejalaController::class, 'update']);
Route::delete('/gejala/{id}', [GejalaController::class, 'destroy']);
Route::get('/gejala/aktif', [GejalaController::class, 'aktif']);
Route::post('/hasil_diagnosis', 'App\Http\Controllers\DiagnosisController@store');
// Route::get('/riwayat/{id_pasien}', [PemeriksaanController::class, 'riwayat']);
Route::get('/edukasi', [EdukasiApiController::class, 'index']);
//Route::get('/prediction-history/{accountId}', [PredictionHistoryController::class, 'getByAccountId']);
Route::get('/prediction-history/{accountId}', [PredictionHistoryApiController::class, 'getByAccountId']);
// login
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:api')->group(function () {
    Route::get('/me', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/my-data', [PatientController::class, 'myData']);
    Route::get('/riwayat/{id}', [PatientController::class, 'riwayat']);
    // Rute untuk mendapatkan riwayat pengguna yang sedang login
    Route::get('/patient/prediction-history', [PredictionHistoryApiController::class, 'getCurrentUserHistory']);
});

Route::post('/login-patient', [\App\Http\Controllers\Api\PatientAuthController::class, 'login']);
Route::get('/patient-profile', [\App\Http\Controllers\Api\PatientAuthController::class, 'profile'])->middleware('auth:sanctum');
Route::prefix('patient')->group(function () {
    Route::post('login', [PatientAuthController::class, 'login']);
    Route::middleware('auth:sanctum')->group(function () {
        Route::get('profile', [PatientProfileController::class, 'profile']);
        Route::post('logout', [PatientAuthController::class, 'logout']);
    });
});