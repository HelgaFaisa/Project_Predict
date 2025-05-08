<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;
use Illuminate\Validation\ValidationException;

class ProfileController extends Controller
{
    /**
     * Menampilkan halaman profil pengguna yang sedang login.
     * Menggunakan method index karena route resource.
     */
    public function index()
    {
        $user = Auth::user(); // Mengambil data pengguna yang sedang login
        return view('admin.profile.show', compact('user'));
    }

    /**
     * Memperbarui password pengguna yang sedang login.
     * Kita buat method kustom karena route resource tidak secara default punya update password.
     * Anda perlu menambahkan route PUT/PATCH manual untuk ini.
     */
    public function updatePassword(Request $request)
    {
        $user = Auth::user();

        $request->validate([
            'current_password' => ['required', 'string', function ($attribute, $value, $fail) use ($user) {
                if (!Hash::check($value, $user->password)) {
                    $fail('Password saat ini tidak cocok.');
                }
            }],
            'password' => ['required', 'string', Password::defaults(), 'confirmed'],
        ]);

        try {
            $user->update([
                'password' => $request->password, // Otomatis di-hash oleh $casts
            ]);

            // Opsional: Logout dari sesi lain jika password diubah
            // Auth::logoutOtherDevices($request->password);

            return back()->with('success', 'Password berhasil diperbarui.');

        } catch (\Exception $e) {
            \Illuminate\Support\Facades\Log::error('Error updating password: ' . $e->getMessage());
            return back()->with('error', 'Gagal memperbarui password. Terjadi kesalahan.');
        }
    }

    // Method create, store, show, edit, update, destroy dari resource controller
    // bisa Anda hapus jika tidak digunakan untuk manajemen profil pengguna lain.
    // Jika Anda hanya butuh halaman show profile dan update password,
    // lebih baik tidak menggunakan Route::resource().
}

