<?php
// api.php - Update your API routes

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\GejalaApiController;
use App\Http\Controllers\Api\PemeriksaanController;
use App\Http\Controllers\Api\EdukasiApiController;
use App\Http\Controllers\Api\PatientAuthController;
use App\Http\Controllers\Api\PatientProfileController;
use App\Http\Controllers\Api\PredictionHistoryApiController;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\PatientController;
use App\Http\Controllers\Api\ForgotPasswordController;

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

// Replace the GejalaController with GejalaApiController for API endpoints
Route::get('/gejala', [GejalaApiController::class, 'index']);
    // Route::get('/patient_health_data', [PatientHealthController::class, 'index']);

// Keep the rest of your routes
Route::post('/gejala', [GejalaController::class, 'store']);
Route::put('/gejala/{id}', [GejalaController::class, 'update']);
Route::delete('/gejala/{id}', [GejalaController::class, 'destroy']);
Route::get('/gejala/aktif', [GejalaController::class, 'aktif']);
Route::post('/hasil_diagnosis', 'App\Http\Controllers\DiagnosisController@store');
// Route::get('/riwayat/{id_pasien}', [PemeriksaanController::class, 'riwayat']);
Route::get('/edukasi', [EdukasiApiController::class, 'index']);
Route::get('/edukasi/{id}', [EdukasiApiController::class, 'show']);
//Route::get('/prediction-history/{accountId}', [PredictionHistoryController::class, 'getByAccountId']);
Route::get('/prediction-history/{accountId}', [PredictionHistoryApiController::class, 'getByAccountId']);
// login
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:api')->group(function () {
    Route::get('/me', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/my-data', [PatientController::class, 'myData']);
    Route::get('/riwayat/{id}', [PatientController::class, 'riwayat']);
        Route::get('/patient_health_data', [PatientController::class, 'myData']); // <-- Arahkan ke PatientController@myData

    // Rute untuk mendapatkan riwayat pengguna yang sedang login
    Route::get('/patient/prediction-history', [PredictionHistoryApiController::class, 'getCurrentUserHistory']);
});

Route::post('/login-patient', [\App\Http\Controllers\Api\AuthController::class, 'login']);
Route::get('/patient-profile', [\App\Http\Controllers\Api\PatientAuthController::class, 'profile'])->middleware('auth:sanctum');
Route::prefix('patient')->group(function () {
    Route::post('login', [PatientAuthController::class, 'login']);
    Route::middleware('auth:sanctum')->group(function () {
        Route::get('profile', [PatientProfileController::class, 'profile']);
        Route::post('logout', [PatientAuthController::class, 'logout']);
    });

    // FORGOT PASSWORD ROUTES - PINDAHKAN KELUAR DARI GROUP PATIENT
Route::prefix('password')->group(function () {
    Route::post('/forgot', [ForgotPasswordController::class, 'sendResetCode']);
    Route::post('/verify-code', [ForgotPasswordController::class, 'verifyResetCode']);
    Route::post('/reset', [ForgotPasswordController::class, 'resetPassword']);
    Route::post('/resend-code', [ForgotPasswordController::class, 'resendCode']);
});
});