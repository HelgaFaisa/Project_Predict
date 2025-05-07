@extends('layouts.app')

@section('title', 'Prediksi Diabetes')
@section('page-title', 'Formulir Prediksi Diabetes')

@section('content')
<div class="space-y-8">

    {{-- Notifikasi Sukses/Error --}}
    @include('partials.alerts') {{-- Asumsi Anda punya partials/alerts.blade.php --}}

    {{-- Form Utama untuk Input Prediksi --}}
    <div class="bg-white rounded-xl shadow p-6 md:p-8 border border-gray-200">
        <h2 class="text-xl font-semibold text-gray-800 mb-6">Pilih Pasien & Masukkan Data Pemeriksaan</h2>

        {{-- Menampilkan Error Validasi Umum --}}
        @if ($errors->any() && !isset($result))
            <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-md" role="alert">
                <p class="font-bold">Harap perbaiki input berikut:</p>
                <ul class="mt-2 list-disc list-inside text-sm">
                    @foreach ($errors->all() as $error)
                        <li>{{ $error }}</li>
                    @endforeach
                </ul>
            </div>
        @endif

        {{-- Form Prediksi --}}
        <form action="{{ route('admin.prediksi.submit') }}" method="POST" class="space-y-4">
            @csrf

            {{-- Input Pemilihan Pasien --}}
            <div class="mb-4">
                <label for="patient_id" class="block text-sm font-medium text-gray-700 mb-1">Pilih Pasien <span class="text-red-500">*</span></label>
                <select name="patient_id" id="patient_id" required
                        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('patient_id') border-red-500 @enderror">
                    <option value="" disabled {{ old('patient_id', $input['patient_id'] ?? '') == '' ? 'selected' : '' }}>-- Pilih Pasien --</option>
                    @isset($patients)
                        @foreach ($patients as $patient)
                            <option value="{{ $patient->id }}"
                                    data-tgl-lahir="{{ $patient->date_of_birth ? Carbon\Carbon::parse($patient->date_of_birth)->toDateString() : '' }}"
                                    {{ old('patient_id', $input['patient_id'] ?? '') == $patient->id ? 'selected' : '' }}>
                                {{ $patient->name ?? 'Nama Tidak Tersedia' }} (ID: {{ $patient->id }})
                            </option>
                        @endforeach
                    @else
                        <option value="" disabled>Data pasien tidak tersedia</option>
                    @endisset
                </select>
                @error('patient_id')
                    <p class="text-red-500 text-xs mt-1">{{ $message }}</p>
                @enderror
            </div>

            {{-- Input Data Pemeriksaan (Grid) --}}
            <div class="grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-4 pt-4 border-t border-gray-200">

                <div>
                    <label for="pregnancies" class="block text-sm font-medium text-gray-700 mb-1">Jumlah Kehamilan</label>
                    <input type="number" name="pregnancies" id="pregnancies" min="0" required
                           value="{{ old('pregnancies', $input['pregnancies'] ?? '') }}"
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('pregnancies') border-red-500 @enderror">
                    @error('pregnancies')
                        <p class="text-red-500 text-xs mt-1">{{ $message }}</p>
                    @enderror
                </div>

                <div>
                    <label for="glucose" class="block text-sm font-medium text-gray-700 mb-1">Kadar Glukosa (mg/dL)</label>
                    <input type="number" name="glucose" id="glucose" min="0" required
                           value="{{ old('glucose', $input['glucose'] ?? '') }}"
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('glucose') border-red-500 @enderror">
                    @error('glucose')
                        <p class="text-red-500 text-xs mt-1">{{ $message }}</p>
                    @enderror
                </div>

                <div>
                    <label for="blood_pressure" class="block text-sm font-medium text-gray-700 mb-1">Tekanan Darah (mmHg)</label>
                    <input type="number" name="blood_pressure" id="blood_pressure" min="0" required
                           value="{{ old('blood_pressure', $input['blood_pressure'] ?? '') }}"
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('blood_pressure') border-red-500 @enderror">
                    @error('blood_pressure')
                        <p class="text-red-500 text-xs mt-1">{{ $message }}</p>
                    @enderror
                </div>

                {{-- Input Tinggi Badan (TB) --}}
                <div>
                    <label for="height" class="block text-sm font-medium text-gray-700 mb-1">Tinggi Badan (cm) <span class="text-red-500">*</span></label>
                    <input type="number" step="0.1" name="height" id="height" min="1" required
                           value="{{ old('height', $input['height'] ?? '') }}"
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('height') border-red-500 @enderror">
                    @error('height')
                        <p class="text-red-500 text-xs mt-1">{{ $message }}</p>
                    @enderror
                </div>

                {{-- Input Berat Badan (BB) --}}
                <div>
                    <label for="weight" class="block text-sm font-medium text-gray-700 mb-1">Berat Badan (kg) <span class="text-red-500">*</span></label>
                    <input type="number" step="0.1" name="weight" id="weight" min="1" required
                           value="{{ old('weight', $input['weight'] ?? '') }}"
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('weight') border-red-500 @enderror">
                    @error('weight')
                        <p class="text-red-500 text-xs mt-1">{{ $message }}</p>
                    @enderror
                </div>

                {{-- Input BMI (dihitung otomatis, bisa disembunyikan atau read-only) --}}
                <div>
                    <label for="bmi" class="block text-sm font-medium text-gray-700 mb-1">Indeks Massa Tubuh (BMI)</label>
                    <input type="number" step="0.01" name="bmi" id="bmi" min="0" readonly
                           value="{{ old('bmi', $input['bmi'] ?? '') }}"
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 bg-gray-100 @error('bmi') border-red-500 @enderror">
                    @error('bmi')
                        <p class="text-red-500 text-xs mt-1">{{ $message }}</p>
                    @enderror
                </div>
                {{-- Atau jika ingin disembunyikan: <input type="hidden" name="bmi" id="bmi" value="{{ old('bmi', $input['bmi'] ?? '') }}"> --}}


                <div class="md:col-span-2">
                    <label for="age" class="block text-sm font-medium text-gray-700 mb-1">Umur (Tahun)</label>
                    <input type="number" name="age" id="age" min="1" required readonly
                           value="{{ old('age', $input['age'] ?? '') }}"
                           class="w-full md:w-1/2 px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 bg-gray-100 @error('age') border-red-500 @enderror">
                    @error('age')
                        <p class="text-red-500 text-xs mt-1">{{ $message }}</p>
                    @enderror
                </div>

            </div>

            {{-- Tombol Submit Prediksi & Reset --}}
            <div class="flex items-center space-x-4 pt-4">
                <button type="submit"
                        class="inline-flex items-center px-6 py-2 bg-indigo-600 border border-transparent rounded-md font-semibold text-sm text-white uppercase tracking-widest hover:bg-indigo-700 active:bg-indigo-800 focus:outline-none focus:border-indigo-900 focus:ring focus:ring-indigo-300 disabled:opacity-25 transition">
                    <i class="ri-flask-line mr-2 -ml-1"></i>
                    Prediksi
                </button>
                <button type="reset" id="resetFormButton"
                        class="inline-flex items-center px-4 py-2 bg-white border border-gray-300 rounded-md font-semibold text-xs text-gray-700 uppercase tracking-widest shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-25 transition">
                    Reset Form
                </button>
            </div>
        </form>
    </div>

    {{-- Bagian Menampilkan Hasil Prediksi dan Tombol Simpan --}}
    @if (isset($result) && isset($input) && isset($input['patient_id']))
        <div class="bg-white rounded-xl shadow p-6 md:p-8 border border-gray-200">
            <h2 class="text-xl font-semibold text-gray-800 mb-4">Hasil Prediksi</h2>

            @isset($selected_patient_name)
            <p class="text-md font-medium text-gray-700 mb-4">Untuk Pasien: <span class="font-bold">{{ $selected_patient_name }}</span> (ID: {{ $input['patient_id'] }})</p>
            @else
            <p class="text-md font-medium text-gray-700 mb-4">Untuk Pasien ID: <span class="font-bold">{{ $input['patient_id'] }}</span></p>
            @endisset

            <div class="text-center py-6 px-4 border rounded-lg
                        {{ $result == 1 ? 'bg-red-50 border-red-200' : 'bg-green-50 border-green-200' }}">
                <p class="text-lg font-medium
                            {{ $result == 1 ? 'text-red-800' : 'text-green-800' }}">
                    {{ $result == 1 ? 'Pasien Berisiko Terkena Diabetes' : 'Pasien Berisiko Rendah Terkena Diabetes' }}
                </p>
            </div>

            <div class="mt-6 border-t border-gray-200 pt-4">
                <h3 class="text-base font-semibold text-gray-700 mb-2">Data yang Digunakan:</h3>
                <dl class="grid grid-cols-2 gap-x-4 gap-y-1 text-sm">
                    <dt class="text-gray-500">Jumlah Kehamilan:</dt> <dd class="text-gray-800 font-medium">{{ $input['pregnancies'] ?? 'N/A' }}</dd>
                    <dt class="text-gray-500">Glukosa:</dt> <dd class="text-gray-800 font-medium">{{ $input['glucose'] ?? 'N/A' }} mg/dL</dd>
                    <dt class="text-gray-500">Tekanan Darah:</dt> <dd class="text-gray-800 font-medium">{{ $input['blood_pressure'] ?? 'N/A' }} mmHg</dd>
                    <dt class="text-gray-500">Tinggi Badan:</dt> <dd class="text-gray-800 font-medium">{{ $input['height'] ?? 'N/A' }} cm</dd>
                    <dt class="text-gray-500">Berat Badan:</dt> <dd class="text-gray-800 font-medium">{{ $input['weight'] ?? 'N/A' }} kg</dd>
                    <dt class="text-gray-500">BMI:</dt> <dd class="text-gray-800 font-medium">{{ number_format($input['bmi'] ?? 0, 2) }}</dd>
                    <dt class="text-gray-500">Umur:</dt> <dd class="text-gray-800 font-medium">{{ $input['age'] ?? 'N/A' }} Tahun</dd>
                </dl>
            </div>

            <div class="flex items-center space-x-4 mt-6 border-t border-gray-200 pt-6">
                <form action="{{ route('admin.prediksi.save') }}" method="POST">
                    @csrf
                    <input type="hidden" name="patient_id" value="{{ $input['patient_id'] ?? '' }}">
                    <input type="hidden" name="pregnancies" value="{{ $input['pregnancies'] ?? '' }}">
                    <input type="hidden" name="glucose" value="{{ $input['glucose'] ?? '' }}">
                    <input type="hidden" name="blood_pressure" value="{{ $input['blood_pressure'] ?? '' }}">
                    <input type="hidden" name="height" value="{{ $input['height'] ?? '' }}"> {{-- Kirim TB --}}
                    <input type="hidden" name="weight" value="{{ $input['weight'] ?? '' }}"> {{-- Kirim BB --}}
                    <input type="hidden" name="bmi" value="{{ $input['bmi'] ?? '' }}"> {{-- Kirim BMI yang dihitung --}}
                    <input type="hidden" name="age" value="{{ $input['age'] ?? '' }}">
                    <input type="hidden" name="result" value="{{ $result ?? '' }}">

                    <button type="submit"
                            class="inline-flex items-center px-4 py-2 bg-blue-600 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-blue-700 active:bg-blue-800 focus:outline-none focus:border-blue-900 focus:ring focus:ring-blue-300 disabled:opacity-25 transition">
                        <i class="ri-save-line mr-2 -ml-1"></i>
                        Simpan Hasil
                    </button>
                </form>

                <a href="{{ route('admin.prediksi.index') }}"
                   class="inline-flex items-center px-4 py-2 bg-white border border-gray-300 rounded-md font-semibold text-xs text-gray-700 uppercase tracking-widest shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-25 transition">
                    Batal / Prediksi Baru
                </a>
            </div>
        </div>
    @endif

</div>
@endsection

@push('scripts')
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const heightInput = document.getElementById('height');
        const weightInput = document.getElementById('weight');
        const bmiInput = document.getElementById('bmi');
        const patientSelect = document.getElementById('patient_id');
        const ageInput = document.getElementById('age');
        const resetFormButton = document.getElementById('resetFormButton');

        function calculateAndSetBmi() {
            const height = parseFloat(heightInput.value); // dalam cm
            const weight = parseFloat(weightInput.value); // dalam kg

            if (height > 0 && weight > 0) {
                const heightInMeters = height / 100;
                const bmi = weight / (heightInMeters * heightInMeters);
                bmiInput.value = bmi.toFixed(2); // 2 angka di belakang koma
            } else {
                bmiInput.value = '';
            }
        }

        function calculateAndSetAge() {
            const selectedOption = patientSelect.options[patientSelect.selectedIndex];
            const tglLahirString = selectedOption.dataset.tglLahir;

            if (tglLahirString) {
                const birthDate = new Date(tglLahirString);
                const today = new Date();
                let age = today.getFullYear() - birthDate.getFullYear();
                const monthDifference = today.getMonth() - birthDate.getMonth();
                if (monthDifference < 0 || (monthDifference === 0 && today.getDate() < birthDate.getDate())) {
                    age--;
                }
                ageInput.value = age > 0 ? age : '';
            } else {
                ageInput.value = '';
            }
        }

        if (heightInput && weightInput && bmiInput) {
            heightInput.addEventListener('input', calculateAndSetBmi);
            weightInput.addEventListener('input', calculateAndSetBmi);
        }

        if (patientSelect && ageInput) {
            patientSelect.addEventListener('change', calculateAndSetAge);
            // Panggil saat load jika sudah ada pasien terpilih (misal dari old input)
            if (patientSelect.value) {
                calculateAndSetAge();
            }
        }
        
        if(resetFormButton) {
            resetFormButton.addEventListener('click', function() {
                // Setelah form direset, panggil kalkulasi ulang jika ada nilai default
                // atau biarkan kosong jika memang itu perilaku reset yang diinginkan
                setTimeout(() => { // Timeout kecil untuk memastikan form sudah direset
                    if (patientSelect.value) {
                         calculateAndSetAge();
                    } else {
                         ageInput.value = '';
                    }
                    calculateAndSetBmi(); // Hitung BMI jika TB/BB punya nilai setelah reset
                }, 0);
            });
        }

    });
</script>
@endpush
