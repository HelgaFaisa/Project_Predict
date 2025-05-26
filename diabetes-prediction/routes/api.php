<?php

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
use App\Http\Controllers\Api\TargetController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

// Gejala routes
Route::get('/gejala', [GejalaApiController::class, 'index']);
Route::post('/gejala', [GejalaApiController::class, 'store']);
Route::put('/gejala/{id}', [GejalaApiController::class, 'update']);
Route::delete('/gejala/{id}', [GejalaApiController::class, 'destroy']);
Route::get('/gejala/aktif', [GejalaApiController::class, 'aktif']);

// Other routes
Route::post('/hasil_diagnosis', 'App\Http\Controllers\DiagnosisController@store');
Route::get('/edukasi', [EdukasiApiController::class, 'index']);
Route::get('/edukasi/{id}', [EdukasiApiController::class, 'show']);
Route::get('/prediction-history/{accountId}', [PredictionHistoryApiController::class, 'getByAccountId']);

// Auth routes
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:api')->group(function () {
    Route::get('/me', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/my-data', [PatientController::class, 'myData']);
    Route::get('/riwayat/{id}', [PatientController::class, 'riwayat']);
    Route::get('/patient/prediction-history', [PredictionHistoryApiController::class, 'getCurrentUserHistory']);
    Route::get('/patient_health_data', [PatientController::class, 'myData']);
});

Route::post('/login-patient', [AuthController::class, 'login']);
Route::get('/patient-profile', [PatientAuthController::class, 'profile'])->middleware('auth:sanctum');

// Forgot Password Routes (Outside of any group)
Route::prefix('password')->group(function () {
    Route::post('/forgot', [ForgotPasswordController::class, 'sendResetCode']);
    Route::post('/verify-code', [ForgotPasswordController::class, 'verifyResetCode']);
    Route::post('/reset', [ForgotPasswordController::class, 'resetPassword']);
    Route::post('/resend-code', [ForgotPasswordController::class, 'resendCode']);
});

// Patient routes
Route::prefix('patient')->group(function () {
    Route::post('login', [AuthController::class, 'login']);
    Route::middleware('auth:sanctum')->group(function () {
        Route::get('profile', [PatientProfileController::class, 'profile']);
        Route::post('logout', [PatientAuthController::class, 'logout']);
    });
});

// Target/Habit Management Routes - MAIN ROUTES
Route::prefix('targets')->group(function () {
    // Habits CRUD
    Route::get('/habits', [TargetController::class, 'getAllHabits']);
    Route::get('/habits/{id}', [TargetController::class, 'getHabitById']);
    Route::post('/habits', [TargetController::class, 'createHabit']);
    Route::put('/habits/{id}', [TargetController::class, 'updateHabit']);
    Route::delete('/habits/{id}', [TargetController::class, 'deleteHabit']);
    
    // Activities Management
    Route::get('/activities/{date}', [TargetController::class, 'getActivitiesByDate']);
    Route::post('/activities', [TargetController::class, 'createOrUpdateActivity']);
    Route::delete('/activities/{id}', [TargetController::class, 'deleteActivity']);
    
    // Statistics
    Route::get('/habits/{id}/stats', [TargetController::class, 'getHabitStats']);
});

// Alternative direct routes (jika diperlukan)
Route::get('habits', [TargetController::class, 'getAllHabits']);
Route::get('habits/{id}', [TargetController::class, 'getHabitById']);
Route::post('habits', [TargetController::class, 'createHabit']);
Route::put('habits/{id}', [TargetController::class, 'updateHabit']);
Route::delete('habits/{id}', [TargetController::class, 'deleteHabit']);

Route::get('activities/{date}', [TargetController::class, 'getActivitiesByDate']);
Route::post('activities', [TargetController::class, 'createOrUpdateActivity']);
Route::delete('activities/{id}', [TargetController::class, 'deleteActivity']);

Route::get('habits/{id}/stats', [TargetController::class, 'getHabitStats']);