<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage; // Tambahkan ini untuk manajemen file
use Illuminate\Support\Str;             // Tambahkan ini untuk helper string
use Illuminate\Validation\Rule;
use Illuminate\Validation\Rules\Password;

class ProfileController extends Controller
{
    /**
     * Menampilkan halaman profil pengguna yang sedang login.
     */
    public function index()
    {
        $user = Auth::user();
        return view('admin.profile.index', compact('user'));
    }

    /**
     * Menampilkan form untuk mengedit informasi profil pengguna yang sedang login.
     *
     * @return \Illuminate\View\View
     */
    public function edit()
    {
        $user = Auth::user();
        return view('admin.profile.edit', compact('user'));
    }

    /**
     * Memperbarui informasi profil pengguna yang sedang login (selain password).
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\RedirectResponse
     */
    public function update(Request $request)
    {
        $user = Auth::user();

        $validatedDataRules = [
            'name' => ['required', 'string', 'max:255'],
            'email' => [
                'required',
                'string',
                'email',
                'max:255',
                Rule::unique('users')->ignore($user->id),
            ],
            'phone_number' => ['nullable', 'string', 'max:20', 'regex:/^[0-9\-\+\s\(\)]*$/'],
            // Fokus pada upload file untuk avatar
            'avatar_file' => ['nullable', 'image', 'mimes:jpg,jpeg,png,webp', 'max:2048'], // Validasi untuk file upload
            'specialization' => ['nullable', 'string', 'max:255'],
            'str_number' => ['nullable', 'string', 'max:255'],
            // 'remove_avatar' => ['nullable', 'boolean'], // Jika Anda ingin menambahkan fitur hapus avatar
        ];

        $validatedData = $request->validate($validatedDataRules);

        // Siapkan payload untuk update, tanpa field file mentah
        $updatePayload = $validatedData;
        unset($updatePayload['avatar_file']); // Hapus avatar_file dari payload utama update
        // unset($updatePayload['remove_avatar']); // Jika ada fitur hapus

        // Logika untuk menghapus avatar jika dicentang "remove_avatar" (jika Anda implementasikan)
        // if ($request->boolean('remove_avatar') && $user->avatar_url) {
        //     if (Str::startsWith($user->avatar_url, asset('storage/'))) {
        //         $oldAvatarPath = Str::after($user->avatar_url, 'storage/');
        //         if (Storage::disk('public')->exists($oldAvatarPath)) {
        //             Storage::disk('public')->delete($oldAvatarPath);
        //         }
        //     }
        //     $updatePayload['avatar_url'] = null;
        // }

        // Logika untuk menangani upload file avatar baru
        if ($request->hasFile('avatar_file')) {
            Log::info('Mendeteksi file avatar untuk diupload.');

            // 1. Hapus avatar lama jika ada dan itu adalah file dari storage kita
            if ($user->avatar_url && Str::startsWith($user->avatar_url, asset('storage/'))) {
                $oldAvatarPath = Str::after($user->avatar_url, 'storage/'); // Ekstrak path relatif: 'avatars/namafile.jpg'
                Log::info('Path avatar lama: ' . $oldAvatarPath);
                if (Storage::disk('public')->exists($oldAvatarPath)) {
                    Storage::disk('public')->delete($oldAvatarPath);
                    Log::info('Avatar lama berhasil dihapus: ' . $oldAvatarPath);
                } else {
                    Log::info('Avatar lama tidak ditemukan di storage: ' . $oldAvatarPath);
                }
            }

            // 2. Simpan avatar baru ke storage
            $file = $request->file('avatar_file');
            // Membuat nama file unik
            $fileName = $user->id . '_' . time() . '.' . $file->getClientOriginalExtension();
            // Simpan file ke direktori 'avatars' di dalam disk 'public'
            // $path akan berisi 'avatars/namafile.jpg'
            $path = $file->storeAs('avatars', $fileName, 'public');
            Log::info('Avatar baru disimpan di path: ' . $path);

            // 3. Update payload dengan URL publik ke avatar baru
            $updatePayload['avatar_url'] = asset('storage/' . $path);
            Log::info('URL Avatar yang akan disimpan ke database: ' . $updatePayload['avatar_url']);
        } elseif (empty($request->file('avatar_file')) && $request->has('avatar_file_existing_url') && empty($request->avatar_file_existing_url)) {
             // Logika ini bisa digunakan jika Anda memiliki input hidden untuk URL yang ada
             // dan ingin menghapus avatar jika URL dikosongkan dan tidak ada file baru.
             // Untuk saat ini, kita asumsikan jika tidak ada file baru, avatar lama tidak diubah kecuali ada fitur "remove_avatar".
        }


        try {
            $user->update($updatePayload);
            Log::info('Profil pengguna ID ' . $user->id . ' berhasil diperbarui.');
            return redirect()->route('admin.profile.index')->with('success', 'Informasi profil berhasil diperbarui.');
        } catch (\Exception $e) {
            Log::error('Gagal memperbarui profil pengguna ID ' . $user->id . ': ' . $e->getMessage(), [
                'trace' => $e->getTraceAsString()
            ]);
            $errorMessage = 'Gagal memperbarui profil. Silakan coba lagi nanti atau hubungi administrator.';
            if (config('app.debug')) {
                $errorMessage .= ' Detail: ' . $e->getMessage();
            }
            return back()->withInput()->with('error', $errorMessage);
        }
    }

    /**
     * Memperbarui password pengguna yang sedang login.
     */
    public function updatePassword(Request $request)
    {
        $user = Auth::user();

        $request->validate([
            'current_password' => ['required', 'string', function ($attribute, $value, $fail) use ($user) {
                if (!Hash::check($value, $user->password)) {
                    $fail('Password saat ini yang Anda masukkan tidak benar.');
                }
            }],
            'password' => [
                'required',
                'string',
                Password::min(8)
                    ->mixedCase()
                    ->numbers()
                    ->symbols(),
                'confirmed'
            ],
        ]);

        try {
            $user->update([
                'password' => $request->password, // Model User akan otomatis hash karena $casts
            ]);
            Log::info('Password untuk pengguna ID ' . $user->id . ' berhasil diperbarui.');
            return redirect()->route('admin.profile.index')->with('success', 'Password berhasil diperbarui.');
        } catch (\Exception $e) {
            Log::error('Gagal memperbarui password untuk pengguna ID ' . $user->id . ': ' . $e->getMessage(), [
                'trace' => $e->getTraceAsString()
            ]);
            $errorMessage = 'Gagal memperbarui password. Silakan coba lagi nanti.';
            if (config('app.debug')) {
                $errorMessage .= ' Detail: ' . $e->getMessage();
            }
            return back()->with('error', $errorMessage);
        }
    }
}