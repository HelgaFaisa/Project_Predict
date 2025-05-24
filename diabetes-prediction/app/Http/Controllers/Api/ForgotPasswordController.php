<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\PatientAccount;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;
use Illuminate\Validation\ValidationException;

class ForgotPasswordController extends Controller
{
    /**
     * Kirim kode reset password ke email pasien
     */
    public function sendResetCode(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:patient_accounts,email'
        ]);

        $email = $request->email;
        
        // Cari akun pasien berdasarkan email
        $patientAccount = PatientAccount::where('email', $email)->first();
        
        if (!$patientAccount) {
            return response()->json([
                'message' => 'Email tidak ditemukan dalam sistem'
            ], 404);
        }

        // Generate 6 digit random code
        $resetCode = str_pad(rand(100000, 999999), 6, '0', STR_PAD_LEFT);
        
        try {
            // Hapus record lama jika ada (MongoDB)
            DB::connection('mongodb')->table('password_reset_tokens')->where('email', $email)->delete();
            
            // Simpan kode reset ke database (MongoDB)
            DB::connection('mongodb')->table('password_reset_tokens')->insert([
                'email' => $email,
                'token' => Hash::make($resetCode), // Hash kode untuk keamanan
                'created_at' => new \MongoDB\BSON\UTCDateTime(Carbon::now()->timestamp * 1000),
                'expires_at' => new \MongoDB\BSON\UTCDateTime(Carbon::now()->addMinutes(15)->timestamp * 1000), // Berlaku 15 menit
            ]);

            // Kirim email dengan kode reset
            Mail::send('emails.password_reset_code', [
                'name' => $patientAccount->name,
                'resetCode' => $resetCode
            ], function ($message) use ($email) {
                $message->to($email);
                $message->subject('Kode Reset Password - DiabetaCare');
                $message->from(config('mail.from.address'), config('mail.from.name'));
            });

            return response()->json([
                'message' => 'Kode reset password telah dikirim ke email Anda',
                'email' => $email
            ], 200);

        } catch (\Exception $e) {
            // Log error untuk debugging
            \Log::error('Email sending failed: ' . $e->getMessage());
            
            return response()->json([
                'message' => 'Gagal mengirim email. Silakan coba lagi.',
                'error' => config('app.debug') ? $e->getMessage() : 'Internal server error'
            ], 500);
        }
    }

    /**
     * Verifikasi kode reset password
     */
    public function verifyResetCode(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'code' => 'required|string|size:6'
        ]);

        $email = $request->email;
        $code = $request->code;

        // Cari kode reset di database (MongoDB)
        $resetRecord = DB::connection('mongodb')->table('password_reset_tokens')
            ->where('email', $email)
            ->first();

        if (!$resetRecord) {
            return response()->json([
                'message' => 'Kode reset tidak ditemukan'
            ], 404);
        }

        // PERBAIKAN: Gunakan -> untuk mengakses property object
        // Cek apakah kode sudah expired
        $expiresAt = Carbon::createFromTimestamp($resetRecord->expires_at->toDateTime()->getTimestamp());
        if ($expiresAt->isPast()) {
            // Hapus kode yang expired
            DB::connection('mongodb')->table('password_reset_tokens')->where('email', $email)->delete();
            
            return response()->json([
                'message' => 'Kode reset telah kedaluwarsa. Silakan minta kode baru.'
            ], 400);
        }

        // PERBAIKAN: Gunakan -> untuk mengakses property object
        // Verifikasi kode
        if (!Hash::check($code, $resetRecord->token)) {
            return response()->json([
                'message' => 'Kode reset tidak valid'
            ], 400);
        }

        // Generate temporary token untuk reset password
        $tempToken = Str::random(60);
        
        // Update record dengan temporary token
        DB::connection('mongodb')->table('password_reset_tokens')
            ->where('email', $email)
            ->update([
                'temp_token' => $tempToken,
                'code_verified' => true,
                'verified_at' => new \MongoDB\BSON\UTCDateTime(Carbon::now()->timestamp * 1000)
            ]);

        return response()->json([
            'message' => 'Kode verifikasi berhasil',
            'temp_token' => $tempToken
        ], 200);
    }

    /**
     * Reset password dengan temporary token
     */
    public function resetPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'temp_token' => 'required|string',
            'password' => 'required|string|min:8|confirmed'
        ]);

        $email = $request->email;
        $tempToken = $request->temp_token;

        // Cari record reset password
        $resetRecord = DB::connection('mongodb')->table('password_reset_tokens')
            ->where('email', $email)
            ->where('temp_token', $tempToken)
            ->where('code_verified', true)
            ->first();

        if (!$resetRecord) {
            return response()->json([
                'message' => 'Token reset tidak valid'
            ], 400);
        }

        // PERBAIKAN: Gunakan -> untuk mengakses property object
        // Cek apakah token sudah expired (30 menit setelah verifikasi)
        $verifiedAt = Carbon::createFromTimestamp($resetRecord->verified_at->toDateTime()->getTimestamp());
        if ($verifiedAt->addMinutes(30)->isPast()) {
            DB::connection('mongodb')->table('password_reset_tokens')->where('email', $email)->delete();
            
            return response()->json([
                'message' => 'Token reset telah kedaluwarsa'
            ], 400);
        }

        // Update password pasien
        $patientAccount = PatientAccount::where('email', $email)->first();
        $patientAccount->update([
            'password' => Hash::make($request->password) // Eksplisit hash password
        ]);

        // Hapus record password reset
        DB::connection('mongodb')->table('password_reset_tokens')->where('email', $email)->delete();

        return response()->json([
            'message' => 'Password berhasil direset'
        ], 200);
    }

    /**
     * Resend kode reset (jika user belum menerima)
     */
    public function resendCode(Request $request)
    {
        $request->validate([
            'email' => 'required|email'
        ]);

        // Cek apakah ada request yang masih aktif
        $existingReset = DB::connection('mongodb')->table('password_reset_tokens')
            ->where('email', $request->email)
            ->first();

        if ($existingReset) {
            // PERBAIKAN: Gunakan -> untuk mengakses property object
            $lastSent = Carbon::createFromTimestamp($existingReset->created_at->toDateTime()->getTimestamp());
            
            // Batasi pengiriman ulang setiap 2 menit
            if ($lastSent->addMinutes(2)->isFuture()) {
                return response()->json([
                    'message' => 'Harap tunggu sebelum meminta kode baru',
                    'wait_seconds' => $lastSent->addMinutes(2)->diffInSeconds(Carbon::now())
                ], 429);
            }
        }

        // Kirim ulang kode dengan memanggil fungsi sendResetCode
        return $this->sendResetCode($request);
    }

    /**
     * Test koneksi email (untuk debugging)
     */
    public function testEmail(Request $request)
    {
        try {
            $testEmail = $request->input('email', 'test@example.com');
            
            Mail::raw('Test email dari DiabetaCare', function ($message) use ($testEmail) {
                $message->to($testEmail);
                $message->subject('Test Email - DiabetaCare');
                $message->from(config('mail.from.address'), config('mail.from.name'));
            });

            return response()->json([
                'message' => 'Test email berhasil dikirim',
                'email' => $testEmail
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Test email gagal dikirim',
                'error' => $e->getMessage(),
                'mail_config' => [
                    'driver' => config('mail.mailer'),
                    'host' => config('mail.host'),
                    'port' => config('mail.port'),
                    'username' => config('mail.username'),
                    'from_address' => config('mail.from.address')
                ]
            ], 500);
        }
    }
}