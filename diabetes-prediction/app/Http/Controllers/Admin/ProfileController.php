<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User; // Atau model Dokter Anda, misal App\Models\Doctor
// use App\Models\Specialization; // Jika perlu load data spesialisasi
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash; // Jika perlu reset password
use Illuminate\Validation\Rule; // Untuk validasi unik

class ProfileController extends Controller
{
    /**
     * Menampilkan daftar semua profil (dokter).
     *
     * @return \Illuminate\View\View
     */
    public function index()
    {
        // Ambil semua user yang berperan sebagai dokter (sesuaikan query jika perlu)
        // Contoh: Jika ada field 'role' atau relasi spesifik
        $profiles = User::where('role', 'doctor')->latest()->paginate(15); // Contoh: Ambil dokter, paginasi 15 per halaman

        // Atau jika semua user adalah dokter / tidak ada pembedaan role signifikan di tabel User
        // $profiles = User::latest()->paginate(15);

        return view('admin.profile.index', compact('profiles'));
    }

    /**
     * Menampilkan form untuk membuat profil baru.
     * (Jika admin bisa menambah dokter baru)
     *
     * @return \Illuminate\View\View
     */
    public function create()
    {
         // $specializations = Specialization::all(); // Jika perlu data spesialisasi
        // return view('admin.profile.create', compact('specializations'));
        return view('admin.profile.create');
    }

    /**
     * Menyimpan profil baru ke database.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\RedirectResponse
     */
    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users,email',
            'password' => 'required|string|min:8|confirmed', // Butuh field password_confirmation
            'role' => 'required|string|in:doctor,admin,patient', // Sesuaikan role yang ada
            'specialization_id' => 'nullable|exists:specializations,id', // Contoh
            'str_number' => 'nullable|string|max:100|unique:users,str_number', // Contoh unik
            'phone_number' => 'nullable|string|max:20',
            // Tambahkan validasi field lain
        ]);

        $validatedData['password'] = Hash::make($validatedData['password']); // Hash password

        User::create($validatedData);

        return redirect()->route('admin.profile.index')->with('success', 'Profil baru berhasil ditambahkan.');
    }


    /**
     * Menampilkan detail profil (opsional, seringkali langsung ke edit).
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
        // Biasanya tidak digunakan, langsung ke edit
        return redirect()->route('admin.profile.edit', $id);
    }

    /**
     * Menampilkan form untuk mengedit profil yang ada.
     *
     * @param  int  $id
     * @return \Illuminate\View\View|\Illuminate\Http\RedirectResponse
     */
    public function edit($id)
    {
        $profile = User::find($id); // Cari user berdasarkan ID

        if (!$profile) {
            return redirect()->route('admin.profile.index')->with('error', 'Profil tidak ditemukan.');
        }

        // $specializations = Specialization::all(); // Jika perlu data spesialisasi

        return view('admin.profile.edit', compact('profile' /*, 'specializations'*/));
    }

    /**
     * Memperbarui profil yang ada di database.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\RedirectResponse
     */
    public function update(Request $request, $id)
    {
        $profile = User::find($id);
        if (!$profile) {
            return redirect()->route('admin.profile.index')->with('error', 'Profil tidak ditemukan.');
        }

        $validatedData = $request->validate([
            'name' => 'required|string|max:255',
             // Pastikan email unik, kecuali untuk user ini sendiri
            'email' => ['required', 'string', 'email', 'max:255', Rule::unique('users')->ignore($id)],
            'role' => 'required|string|in:doctor,admin,patient', // Sesuaikan role
             // Jika ada update password (opsional)
            'password' => 'nullable|string|min:8|confirmed',
            'specialization_id' => 'nullable|exists:specializations,id', // Contoh
             // Pastikan STR unik, kecuali untuk user ini sendiri
            'str_number' => ['nullable', 'string', 'max:100', Rule::unique('users')->ignore($id)],
            'phone_number' => 'nullable|string|max:20',
            // Tambahkan validasi field lain
        ]);

        // Update data dasar
        $profile->name = $validatedData['name'];
        $profile->email = $validatedData['email'];
        $profile->role = $validatedData['role']; // Update role jika diizinkan

        // Update data spesifik dokter/profil (sesuaikan field Anda)
        // $profile->specialization_id = $validatedData['specialization_id'] ?? null;
        $profile->str_number = $validatedData['str_number'] ?? null;
        $profile->phone_number = $validatedData['phone_number'] ?? null;
        // $profile->practice_place = $request->input('practice_place'); // Contoh jika tidak divalidasi strict
        // $profile->bio = $request->input('bio');
        // $profile->schedule = $request->input('schedule');


        // Update password HANYA jika diisi
        if (!empty($validatedData['password'])) {
            $profile->password = Hash::make($validatedData['password']);
        }

        // Handle avatar jika ada (mirip controller sebelumnya)

        $profile->save();

        return redirect()->route('admin.profile.index')->with('success', 'Profil berhasil diperbarui.');
        // Atau kembali ke halaman edit:
        // return redirect()->route('admin.profile.edit', $id)->with('success', 'Profil berhasil diperbarui.');
    }

    /**
     * Menghapus profil dari database.
     *
     * @param  int  $id
     * @return \Illuminate\Http\RedirectResponse
     */
    public function destroy($id)
    {
        $profile = User::find($id);

        if (!$profile) {
            return redirect()->route('admin.profile.index')->with('error', 'Profil tidak ditemukan.');
        }

        // Tambahkan logika pengecekan jika diperlukan (misal, jangan hapus admin utama)
        if ($profile->role === 'admin' && $profile->id === Auth::id()) {
             return redirect()->route('admin.profile.index')->with('error', 'Anda tidak dapat menghapus akun Anda sendiri.');
        }

        // Hapus avatar dari storage jika ada
        // if ($profile->avatar) { Storage::disk('public')->delete($profile->avatar); }

        $profile->delete();

        return redirect()->route('admin.profile.index')->with('success', 'Profil berhasil dihapus.');
    }
}