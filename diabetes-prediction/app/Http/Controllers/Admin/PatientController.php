<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Patient;
use App\Models\PredictionHistory; // Mungkin perlu jika menghapus pasien
use App\Models\PatientAccount; // Mungkin perlu jika menghapus pasien
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Exception;
use Illuminate\Support\Facades\Log;
use Carbon\Carbon;

class PatientController extends Controller
{
    /**
     * Menampilkan daftar pasien.
     */
    public function index(Request $request)
    {
        $search = $request->input('search');
        $query = Patient::query();

        if ($search) {
            $query->where(function ($q) use ($search) {
                $q->where('name', 'like', '%' . $search . '%')
                  ->orWhere('nik', 'like', '%' . $search . '%') // Cari berdasarkan NIK juga
                  ->orWhere('_id', $search);
            });
        }

        $patients = $query->latest()->paginate(15); // Urutkan berdasarkan terbaru
        return view('admin.pasien.index', compact('patients'));
    }

    /**
     * Menampilkan form tambah pasien baru.
     */
    public function create()
    {
        return view('admin.pasien.create');
    }

    /**
     * Menyimpan pasien baru.
     */
    public function store(Request $request)
    {
        // Validasi Input (Email & Kontak dihapus, NIK ditambahkan)
        $validatedData = $request->validate([
            'name'           => 'required|string|max:255',
            'nik'            => 'required|string|digits:16|unique:patients,nik', // NIK wajib, 16 digit, unik
            'date_of_birth'  => 'nullable|date|before_or_equal:today',
            'gender'         => 'nullable|string|in:Laki-laki,Perempuan',
            'address'        => 'nullable|string|max:1000',
        ]);

        // Konversi tanggal lahir jika ada
         if (!empty($validatedData['date_of_birth'])) {
            try {
                $validatedData['date_of_birth'] = Carbon::parse($validatedData['date_of_birth']);
            } catch (\Exception $e) {
                // Handle jika parsing gagal, mungkin kembalikan error
                Log::error('Invalid date format for date_of_birth on store: ' . $validatedData['date_of_birth']);
                return back()->withErrors(['date_of_birth' => 'Format tanggal lahir tidak valid.'])->withInput();
            }
        } else {
            $validatedData['date_of_birth'] = null;
        }


        try {
            // Buat pasien baru (email & contact_number tidak lagi disertakan)
            Patient::create($validatedData);

            return redirect()->route('admin.pasien.index')
                             ->with('success', 'Pasien baru berhasil ditambahkan.');

        } catch (Exception $e) {
            Log::error('Error storing patient: ' . $e->getMessage());
            return redirect()->back()
                             ->with('error', 'Gagal menambahkan pasien. Terjadi kesalahan internal.')
                             ->withInput();
        }
    }

    /**
     * Menampilkan detail pasien.
     */
    public function show(string $id)
    {
        try {
            $patient = Patient::findOrFail($id);
            $latestPrediction = PredictionHistory::where('patient_id', $patient->_id)
                                                ->latest('prediction_timestamp')
                                                ->first();

            return view('admin.pasien.show', compact('patient', 'latestPrediction'));

        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return redirect()->route('admin.pasien.index')
                             ->with('error', 'Pasien tidak ditemukan.');
        } catch (Exception $e) {
             Log::error('Error showing patient detail: ' . $e->getMessage());
             return redirect()->route('admin.pasien.index')
                              ->with('error', 'Terjadi kesalahan saat menampilkan data pasien.');
        }
    }

    /**
     * Menampilkan form edit pasien.
     */
    public function edit(Patient $pasien) // Menggunakan Route Model Binding
    {
         return view('admin.pasien.edit', compact('pasien'));
    }

    /**
     * Memperbarui data pasien.
     */
    public function update(Request $request, Patient $pasien) // Menggunakan Route Model Binding
    {
        // Validasi Input (Email & Kontak dihapus, NIK ditambahkan dan diabaikan ID saat ini)
        $validatedData = $request->validate([
            'name'           => 'required|string|max:255',
            'nik'            => ['required', 'string', 'digits:16', Rule::unique('patients', 'nik')->ignore($pasien->_id, '_id')],
            'date_of_birth'  => 'nullable|date|before_or_equal:today',
            'gender'         => 'nullable|string|in:Laki-laki,Perempuan',
            'address'        => 'nullable|string|max:1000',
        ]);

        // Konversi tanggal lahir jika ada
         if (!empty($validatedData['date_of_birth'])) {
             try {
                $validatedData['date_of_birth'] = Carbon::parse($validatedData['date_of_birth']);
             } catch (\Exception $e) {
                Log::error('Invalid date format for date_of_birth on update: ' . $validatedData['date_of_birth']);
                return back()->withErrors(['date_of_birth' => 'Format tanggal lahir tidak valid.'])->withInput();
             }
        } else {
            $validatedData['date_of_birth'] = null;
        }

        try {
            // Update data pasien (email & contact_number tidak lagi disertakan)
            $pasien->update($validatedData);

            return redirect()->route('admin.pasien.show', $pasien) // Kembali ke halaman detail
                             ->with('success', 'Data pasien berhasil diperbarui.');

        } catch (Exception $e) {
            Log::error('Error updating patient: ' . $e->getMessage());
            return redirect()->back()
                             ->with('error', 'Gagal memperbarui data pasien. Terjadi kesalahan internal.')
                             ->withInput();
        }
    }

    /**
     * Menghapus data pasien.
     */
    public function destroy(Patient $pasien) // Menggunakan Route Model Binding
    {
        try {
            // Pertimbangkan apa yang terjadi dengan data terkait (prediksi, akun pasien)
            // Opsi 1: Hapus juga data terkait (cascade delete - perlu hati-hati)
            // PredictionHistory::where('patient_id', $pasien->_id)->delete();
            // PatientAccount::where('patient_id', $pasien->_id)->delete();

            // Opsi 2: Biarkan data terkait, atau set foreign key jadi null jika memungkinkan
            // (Tergantung kebutuhan aplikasi Anda)

            // Hapus pasien
            $pasien->delete();

            return redirect()->route('admin.pasien.index')
                             ->with('success', 'Pasien berhasil dihapus.');

        } catch (Exception $e) {
            Log::error('Error deleting patient: ' . $e->getMessage());
             return redirect()->route('admin.pasien.index')
                              ->with('error', 'Gagal menghapus pasien. Terjadi kesalahan internal.');
        }
    }
}
