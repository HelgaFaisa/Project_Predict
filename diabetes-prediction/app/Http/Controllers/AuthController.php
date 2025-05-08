<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\RateLimiter; // Untuk throttling login
use Illuminate\Support\Str; // Untuk throttling login

class AuthController extends Controller
{
    /**
     * Menampilkan form login.
     *
     * @return \Illuminate\View\View
     */
    public function showLoginForm()
    {
        // Jika sudah login, arahkan ke dashboard
        if (Auth::check()) {
            // Sesuaikan dengan route dashboard admin Anda
            return redirect()->route('admin.dashboard');
        }
        // Tampilkan view login
        return view('auth.login');
    }

    /**
     * Menangani percobaan login.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\RedirectResponse
     *
     * @throws \Illuminate\Validation\ValidationException
     */
    public function login(Request $request)
    {
        // 1. Validasi Input
        $credentials = $request->validate([
            'email' => ['required', 'string', 'email'],
            'password' => ['required', 'string'],
        ]);

        // 2. Throttle Login Attempts (Mencegah Brute Force)
        $throttleKey = Str::lower($request->input('email')) . '|' . $request->ip();
        if (RateLimiter::tooManyAttempts($throttleKey, 5)) { // Batasi 5 percobaan per menit
            $seconds = RateLimiter::availableIn($throttleKey);
            throw ValidationException::withMessages([
                'email' => trans('auth.throttle', ['seconds' => $seconds]),
            ]);
        }

        // 3. Mencoba Otentikasi Pengguna
        // Menggunakan guard 'web' (default untuk user biasa/admin)
        // 'remember' diambil dari checkbox "Ingat saya"
        if (Auth::guard('web')->attempt($credentials, $request->boolean('remember'))) {
            // 4. Regenerasi Session ID (Keamanan)
            $request->session()->regenerate();

            // 5. Bersihkan Throttle Limiter setelah sukses login
            RateLimiter::clear($throttleKey);

            // 6. Redirect ke Tujuan (Dashboard Admin)
            // Sesuaikan dengan nama route dashboard admin Anda
            return redirect()->intended(route('admin.dashboard'));
        }

        // 7. Jika Otentikasi Gagal
        // Tambahkan hit ke rate limiter
        RateLimiter::hit($throttleKey);

        // Kembalikan ke form login dengan pesan error
        throw ValidationException::withMessages([
            // Menggunakan pesan standar dari file bahasa Laravel (resources/lang/id/auth.php)
            'email' => [trans('auth.failed')],
        ]);
    }

    /**
     * Menangani proses logout.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\RedirectResponse
     */
    public function logout(Request $request)
    {
        // Logout dari guard 'web'
        Auth::guard('web')->logout();

        // Invalidate session dan regenerate token (Keamanan)
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        // Redirect ke halaman landing atau login
        return redirect('/')->with('status', 'Anda telah berhasil logout.'); // Atau ke route('login')
    }
}
    