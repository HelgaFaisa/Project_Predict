<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Patient; // Pastikan path model benar
use Illuminate\Http\Request;
use Illuminate\Validation\Rule; // Untuk validasi unique
use Carbon\Carbon; // Jika perlu manipulasi tanggal
use Exception; // Untuk menangani error

class PatientController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $search = $request->input('search');
        $query = Patient::query(); // Mulai query

        // Implementasi Pencarian Sederhana (Opsional)
        if ($search) {
            // Cari berdasarkan nama (case-insensitive) atau ID
            // Operator 'like' mungkin tidak seefisien di MongoDB seperti di SQL
            // Pertimbangkan index teks jika pencarian kompleks sering dilakukan
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', '%' . $search . '%')
                  ->orWhere('_id', $search); // Cari berdasarkan _id jika input mungkin ID
                  // ->orWhere('id', $search); // Atau jika Anda menggunakan field 'id' kustom
            });
        }

        // Ambil data dengan pagination, urutkan berdasarkan data dibuat (opsional)
        $patients = $query->orderBy('created_at', 'desc')->paginate(15); // Ganti 15 dengan jumlah item per halaman yg diinginkan

        return view('admin.pasien.index', compact('patients'));
    }

    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return view('admin.pasien.create');
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        // Validasi Input
        $validatedData = $request->validate([
            'name' => 'required|string|max:255',
            'date_of_birth' => 'nullable|date|before_or_equal:today',
            'gender' => 'nullable|string|in:Laki-laki,Perempuan',
            'contact_number' => 'nullable|string|max:20', // Sesuaikan max length
            // Validasi unique untuk email jika perlu (pastikan ada index di MongoDB)
            'email' => 'nullable|email|max:255|unique:patients,email',
            'address' => 'nullable|string|max:1000',
            // Tambahkan validasi untuk field lain jika ada
        ]);

        try {
            // Buat dan simpan pasien baru
            Patient::create($validatedData); // Mass assignment

            return redirect()->route('admin.pasien.index')
                             ->with('success', 'Pasien baru berhasil ditambahkan.');

        } catch (Exception $e) {
            // Tangani jika ada error saat menyimpan
            // Log errornya jika perlu: Log::error($e->getMessage());
            return redirect()->back()
                             ->with('error', 'Gagal menambahkan pasien. Silakan coba lagi.')
                             ->withInput(); // Kembalikan input sebelumnya
        }
    }

    /**
     * Display the specified resource.
     *
     * @param  string  $id // Terima ID sebagai string dari route
     * @return \Illuminate\Http\Response
     */
    public function show(string $id)
    {
        try {
             // Cari pasien berdasarkan ID (_id atau id kustom Anda)
            $patient = Patient::findOrFail($id);

            // Di sini Anda bisa menambahkan logic untuk mengambil riwayat pemeriksaan pasien
            // $riwayatPemeriksaan = Pemeriksaan::where('patient_id', $id)->orderBy('created_at', 'desc')->get();
            // return view('admin.pasien.show', compact('patient', 'riwayatPemeriksaan'));

            return view('admin.pasien.show', compact('patient'));

        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return redirect()->route('admin.pasien.index')
                             ->with('error', 'Pasien tidak ditemukan.');
        } catch (Exception $e) {
             return redirect()->route('admin.pasien.index')
                             ->with('error', 'Terjadi kesalahan saat menampilkan data pasien.');
        }
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  string  $id
     * @return \Illuminate\Http\Response
     */
    public function edit(string $id)
    {
         try {
            $patient = Patient::findOrFail($id);
            return view('admin.pasien.edit', compact('patient'));

        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return redirect()->route('admin.pasien.index')
                             ->with('error', 'Pasien tidak ditemukan.');
        } catch (Exception $e) {
             return redirect()->route('admin.pasien.index')
                             ->with('error', 'Terjadi kesalahan saat mengambil data pasien untuk diedit.');
        }
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  string  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, string $id)
    {
        // Validasi Input (mirip store, tapi sesuaikan unique rule)
        $validatedData = $request->validate([
            'name' => 'required|string|max:255',
            'date_of_birth' => 'nullable|date|before_or_equal:today',
            'gender' => 'nullable|string|in:Laki-laki,Perempuan',
            'contact_number' => 'nullable|string|max:20',
             // Validasi unique email, abaikan ID pasien saat ini
            'email' => [
                'nullable',
                'email',
                'max:255',
                Rule::unique('patients', 'email')->ignore($id, '_id') // Gunakan '_id' atau 'id' sesuai field primary key Anda
            ],
            'address' => 'nullable|string|max:1000',
        ]);

        try {
            $patient = Patient::findOrFail($id);
            $patient->update($validatedData); // Update data pasien

            return redirect()->route('admin.pasien.show', ['pasien' => $id]) // Kembali ke halaman detail
                             ->with('success', 'Data pasien berhasil diperbarui.');

        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return redirect()->route('admin.pasien.index')
                             ->with('error', 'Pasien tidak ditemukan.');
        } catch (Exception $e) {
            // Log::error($e->getMessage());
            return redirect()->back()
                             ->with('error', 'Gagal memperbarui data pasien. Silakan coba lagi.')
                             ->withInput();
        }
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  string  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy(string $id)
    {
        try {
            $patient = Patient::findOrFail($id);

            // Pertimbangkan: Apa yang terjadi dengan data pemeriksaan terkait?
            // Jika perlu menghapus data terkait juga, lakukan di sini sebelum menghapus pasien.
            // Contoh: Pemeriksaan::where('patient_id', $id)->delete();

            $patient->delete(); // Hapus pasien

            return redirect()->route('admin.pasien.index')
                             ->with('success', 'Pasien berhasil dihapus.');

        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return redirect()->route('admin.pasien.index')
                             ->with('error', 'Pasien tidak ditemukan.');
        } catch (Exception $e) {
            // Log::error($e->getMessage());
             // Error bisa terjadi karena constraint atau masalah koneksi
            return redirect()->route('admin.pasien.index')
                             ->with('error', 'Gagal menghapus pasien. Mungkin masih ada data terkait.');
        }
    }
}