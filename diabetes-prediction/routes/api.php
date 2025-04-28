<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\GejalaController;

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