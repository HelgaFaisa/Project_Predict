    <?php

    use Illuminate\Http\Request;
    use Illuminate\Support\Facades\Route;
    use App\Http\Controllers\GejalaController;
    use App\Http\Controllers\Api\PemeriksaanController;
    use App\Http\Controllers\Api\EdukasiApiController;
    // use App\Http\Controllers\Api\PatientAuthController;
    // use App\Http\Controllers\Api\PatientProfileController;
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

    /* ------------------------------------------------------------------
 | PUBLIC  ROUTES  (tidak butuh token)
 * -----------------------------------------------------------------*/
// Route::get ('/gejala',          [GejalaController::class, 'index']);
// Route::post('/gejala',          [GejalaController::class, 'store']);
// Route::put ('/gejala/{id}',     [GejalaController::class, 'update']);
// Route::delete('/gejala/{id}',   [GejalaController::class, 'destroy']);
// Route::get ('/gejala/aktif',    [GejalaController::class, 'aktif']);

Route::post('/hasil_diagnosis', [PemeriksaanController::class, 'store']);
Route::get ('/edukasi',         [EdukasiApiController::class, 'index']);
Route::get ('/prediction-history/{accountId}',
            [PredictionHistoryApiController::class,'getByAccountId']);

/* ------------------------------------------------------------------
 | LOGIN pasien → JWT TOKEN
 * -----------------------------------------------------------------*/
Route::post('/login', [AuthController::class, 'login']);

/* ------------------------------------------------------------------
 | PROTECTED ROUTES  (harus kirim  Header:  Authorization: Bearer <token>)
 * -----------------------------------------------------------------*/
Route::middleware('auth:api')->get('/riwayat/{id}', [PredictionHistoryApiController::class, 'index']);
Route::middleware('auth:api')->group(function () {

    // Profil akun yang sedang login
    Route::get ('/me',    [AuthController::class, 'me']);
    Route::post('/logout',[AuthController::class, 'logout']);

    // Data & riwayat pasien
    Route::get('/riwayat/{id}', [PatientController::class, 'riwayat']);
});