<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\PatientAccount;
use App\Models\Patient; // Untuk dropdown pilih pasien
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules;
use Illuminate\Validation\Rule;

class PatientAccountController extends Controller
{
    public function index(Request $request)
    {
        $search = $request->input('search');
        $query = PatientAccount::with('patient')->latest(); // Eager load relasi patient

        if ($search) {
            $query->where('name', 'like', '%' . $search . '%')
                  ->orWhere('email', 'like', '%' . $search . '%')
                  ->orWhereHas('patient', function ($q) use ($search) {
                      $q->where('name', 'like', '%' . $search . '%');
                  });
        }
        $accounts = $query->paginate(10);
        return view('admin.patient_accounts.index', compact('accounts'));
    }

    public function create()
    {
        // Ambil pasien yang belum punya akun
        $patients = Patient::whereDoesntHave('patientAccount') // Asumsi ada relasi 'patientAccount' di model Patient
                           ->orderBy('name')->get(['_id', 'name']);
        return view('admin.patient_accounts.create', compact('patients'));
    }

    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'patient_id' => 'required|string|exists:patients,_id|unique:patient_accounts,patient_id',
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:patient_accounts,email',
            'password' => ['required', 'confirmed', Rules\Password::defaults()],
            'phone_number' => 'nullable|string|max:20',
            'status' => 'required|string|in:active,inactive',
        ]);

        $patient = Patient::find($validatedData['patient_id']);
        if(!$patient){
            return back()->with('error', 'Pasien tidak ditemukan.')->withInput();
        }

        PatientAccount::create([
            'patient_id' => $validatedData['patient_id'],
            'name' => $patient->name, // Ambil nama dari data pasien
            'email' => $validatedData['email'],
            'password' => $validatedData['password'], // Sudah otomatis di-hash oleh $casts di model
            'phone_number' => $validatedData['phone_number'],
            'status' => $validatedData['status'],
        ]);

        return redirect()->route('admin.patient_accounts.index')->with('success', 'Akun pasien berhasil dibuat.');
    }

    public function edit(PatientAccount $patientAccount)
    {
         // Ambil pasien yang belum punya akun, plus pasien saat ini
        $currentPatientId = $patientAccount->patient_id;
        $patients = Patient::where(function ($query) use ($currentPatientId) {
                                $query->whereDoesntHave('patientAccount')
                                      ->orWhere('_id', $currentPatientId);
                            })
                           ->orderBy('name')->get(['_id', 'name']);
        return view('admin.patient_accounts.edit', compact('patientAccount', 'patients'));
    }

    public function update(Request $request, PatientAccount $patientAccount)
    {
        $validatedData = $request->validate([
            'patient_id' => ['required','string','exists:patients,_id', Rule::unique('patient_accounts','patient_id')->ignore($patientAccount->id)],
            'name' => 'required|string|max:255',
            'email' => ['required','string','email','max:255', Rule::unique('patient_accounts','email')->ignore($patientAccount->id)],
            'password' => ['nullable', 'confirmed', Rules\Password::defaults()],
            'phone_number' => 'nullable|string|max:20',
            'status' => 'required|string|in:active,inactive',
        ]);
        
        $patient = Patient::find($validatedData['patient_id']);
        if(!$patient){
            return back()->with('error', 'Pasien tidak ditemukan.')->withInput();
        }

        $dataToUpdate = [
            'patient_id' => $validatedData['patient_id'],
            'name' => $patient->name, // Update nama jika pasien terkait berubah
            'email' => $validatedData['email'],
            'phone_number' => $validatedData['phone_number'],
            'status' => $validatedData['status'],
        ];

        if (!empty($validatedData['password'])) {
            $dataToUpdate['password'] = $validatedData['password']; // Sudah otomatis di-hash
        }

        $patientAccount->update($dataToUpdate);

        return redirect()->route('admin.patient_accounts.index')->with('success', 'Akun pasien berhasil diperbarui.');
    }

    public function destroy(PatientAccount $patientAccount)
    {
        // Pertimbangkan apa yang terjadi jika akun dihapus, apakah data pasien juga?
        // Untuk saat ini, hanya akun yang dihapus.
        $patientAccount->delete();
        return redirect()->route('admin.patient_accounts.index')->with('success', 'Akun pasien berhasil dihapus.');
    }
}
