<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User; // Pastikan path model User benar
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\Rules;
use Illuminate\Auth\Events\Registered; // Untuk event jika perlu

class RegisterController extends Controller
{
    /**
     * Menampilkan form registrasi.
     */
    public function showRegistrationForm()
    {
        // Hanya izinkan akses ke registrasi jika belum login
        if (Auth::check()) {
             return redirect()->route('admin.dashboard'); // Atau route tujuan setelah login
        }
        return view('auth.register');
    }

    /**
     * Menangani request registrasi.
     */
    public function register(Request $request)
    {
         // Hanya izinkan akses ke registrasi jika belum login
        if (Auth::check()) {
             return redirect()->route('admin.dashboard');
        }

        $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'string', 'email', 'max:255', 'unique:users,email'], // Pastikan unik di collection users
            'password' => ['required', 'confirmed', Rules\Password::defaults()],
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => $request->password, // Otomatis di-hash oleh $casts di model
        ]);

        // Opsional: Kirim event jika perlu (misal untuk verifikasi email)
        // event(new Registered($user));

        // Langsung login setelah registrasi
        Auth::login($user);

        // Redirect ke dashboard admin setelah registrasi berhasil
        return redirect()->route('admin.dashboard')->with('success', 'Registrasi berhasil! Selamat datang.');
    }
}
