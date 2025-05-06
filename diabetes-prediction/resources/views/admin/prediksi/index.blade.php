@extends('layouts.app')

@section('title', 'Prediksi Diabetes')
@section('page-title', 'Formulir Prediksi Diabetes')

@section('content')
<div class="space-y-8">

    {{-- Notifikasi Sukses/Error --}}
    @if (session('success'))
        <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-6" role="alert">
            <strong class="font-bold">Sukses!</strong>
            <span class="block sm:inline">{{ session('success') }}</span>
        </div>
    @endif
    @if (session('error'))
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-6" role="alert">
            <strong class="font-bold">Error!</strong>
            <span class="block sm:inline">{{ session('error') }}</span>
        </div>
    @endif

    {{-- Form Utama untuk Input Prediksi --}}
    <div class="bg-white rounded-xl shadow p-6 md:p-8 border border-gray-200">
        {{-- Judul Form Diubah --}}
        <h2 class="text-xl font-semibold text-gray-800 mb-6">Pilih Pasien & Masukkan Data Pemeriksaan</h2>

        {{-- Menampilkan Error Validasi Umum --}}
        @if ($errors->any() && !isset($result)) {{-- Hanya tampilkan jika bukan dari hasil --}}
            <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6" role="alert">
                <p class="font-bold">Harap perbaiki input berikut:</p>
                <ul>
                    @foreach ($errors->all() as $error)
                        <li>{{ $error }}</li>
                    @endforeach
                </ul>
            </div>
        @endif

        {{-- Form Prediksi --}}
        <form action="{{ route('admin.prediksi.submit') }}" method="POST" class="space-y-4">
            @csrf

            {{-- === BAGIAN BARU: Input Pemilihan Pasien === --}}
            <div class="mb-4">
                <label for="patient_id" class="block text-sm font-medium text-gray-700 mb-1">Pilih Pasien <span class="text-red-500">*</span></label>
                <select name="patient_id" id="patient_id" required
                        class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('patient_id') border-red-500 @enderror">
                    <option value="" disabled {{ old('patient_id', $input['patient_id'] ?? '') == '' ? 'selected' : '' }}>-- Pilih Pasien --</option>
                    {{-- Loop data pasien dari Controller --}}
                    @isset($patients)
                        @foreach ($patients as $patient)
                            {{-- Asumsi $patient punya 'id' dan 'name' --}}
                            {{-- Ganti 'id' dengan '_id' jika Anda menggunakan _id MongoDB secara langsung --}}
                            <option value="{{ $patient->id ?? $patient['_id'] }}"
                                    {{ old('patient_id', $input['patient_id'] ?? '') == ($patient->id ?? $patient['_id']) ? 'selected' : '' }}>
                                {{ $patient->name ?? 'Nama Tidak Tersedia' }} (ID: {{ $patient->id ?? $patient['_id'] }})
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
            {{-- === AKHIR BAGIAN BARU === --}}


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

                <div>
                    <label for="bmi" class="block text-sm font-medium text-gray-700 mb-1">Indeks Massa Tubuh (BMI)</label>
                    <input type="number" step="0.1" name="bmi" id="bmi" min="0" required
                           value="{{ old('bmi', $input['bmi'] ?? '') }}"
                           class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('bmi') border-red-500 @enderror">
                     @error('bmi')
                        <p class="text-red-500 text-xs mt-1">{{ $message }}</p>
                    @enderror
                </div>

                <div class="md:col-span-2">
                    <label for="age" class="block text-sm font-medium text-gray-700 mb-1">Umur (Tahun)</label>
                    {{-- Pertimbangkan untuk mengambil umur dari data pasien terpilih jika memungkinkan --}}
                    <input type="number" name="age" id="age" min="1" required
                           value="{{ old('age', $input['age'] ?? '') }}"
                           class="w-full md:w-1/2 px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('age') border-red-500 @enderror">
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
                 <button type="reset"
                         class="inline-flex items-center px-4 py-2 bg-white border border-gray-300 rounded-md font-semibold text-xs text-gray-700 uppercase tracking-widest shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-25 transition">
                     Reset Form
                 </button>
            </div>
        </form>
    </div>

    {{-- Bagian Menampilkan Hasil Prediksi dan Tombol Simpan --}}
    @if (isset($result) && isset($input) && isset($input['patient_id'])) {{-- Pastikan patient_id ada --}}
        <div class="bg-white rounded-xl shadow p-6 md:p-8 border border-gray-200">
            <h2 class="text-xl font-semibold text-gray-800 mb-4">Hasil Prediksi</h2>

             {{-- Menampilkan Nama Pasien di Hasil (Opsional tapi bagus) --}}
            @isset($selected_patient_name)
            <p class="text-md font-medium text-gray-700 mb-4">Untuk Pasien: <span class="font-bold">{{ $selected_patient_name }}</span> (ID: {{ $input['patient_id'] }})</p>
            @else
            <p class="text-md font-medium text-gray-700 mb-4">Untuk Pasien ID: <span class="font-bold">{{ $input['patient_id'] }}</span></p>
            @endisset

            {{-- Hasil Prediksi --}}
            <div class="text-center py-6 px-4 border rounded-lg
                        {{ $result == 1 ? 'bg-red-50 border-red-200' : 'bg-green-50 border-green-200' }}">
                <p class="text-lg font-medium
                            {{ $result == 1 ? 'text-red-800' : 'text-green-800' }}">
                    {{ $result == 1 ? 'Pasien Berisiko Terkena Diabetes' : 'Pasien Berisiko Rendah Terkena Diabetes' }}
                </p>
            </div>

            {{-- Data yang Digunakan --}}
            <div class="mt-6 border-t border-gray-200 pt-4">
                <h3 class="text-base font-semibold text-gray-700 mb-2">Data yang Digunakan:</h3>
                <dl class="grid grid-cols-2 gap-x-4 gap-y-1 text-sm">
                    <dt class="text-gray-500">Jumlah Kehamilan:</dt> <dd class="text-gray-800 font-medium">{{ $input['pregnancies'] ?? 'N/A' }}</dd>
                    <dt class="text-gray-500">Glukosa:</dt> <dd class="text-gray-800 font-medium">{{ $input['glucose'] ?? 'N/A' }} mg/dL</dd>
                    <dt class="text-gray-500">Tekanan Darah:</dt> <dd class="text-gray-800 font-medium">{{ $input['blood_pressure'] ?? 'N/A' }} mmHg</dd>
                    <dt class="text-gray-500">BMI:</dt> <dd class="text-gray-800 font-medium">{{ number_format($input['bmi'] ?? 0, 1) }}</dd>
                    <dt class="text-gray-500">Umur:</dt> <dd class="text-gray-800 font-medium">{{ $input['age'] ?? 'N/A' }} Tahun</dd>
                </dl>
            </div>

            {{-- Tombol Simpan Hasil & Batal --}}
            <div class="flex items-center space-x-4 mt-6 border-t border-gray-200 pt-6">
                {{-- Form untuk menyimpan hasil --}}
                <form action="{{ route('admin.prediksi.save') }}" method="POST">
                    @csrf
                    {{-- === PENTING: Sertakan patient_id untuk disimpan === --}}
                    <input type="hidden" name="patient_id" value="{{ $input['patient_id'] ?? '' }}">

                    {{-- Data lainnya yang akan disimpan --}}
                    <input type="hidden" name="pregnancies" value="{{ $input['pregnancies'] ?? '' }}">
                    <input type="hidden" name="glucose" value="{{ $input['glucose'] ?? '' }}">
                    <input type="hidden" name="blood_pressure" value="{{ $input['blood_pressure'] ?? '' }}">
                    <input type="hidden" name="bmi" value="{{ $input['bmi'] ?? '' }}">
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
{{-- Jika Anda ingin menggunakan library select2 untuk pencarian pasien yang lebih baik --}}
{{-- <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" /> --}}
{{-- <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> --}}
{{-- <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script> --}}
{{-- <script>
    $(document).ready(function() {
        $('#patient_id').select2({
            placeholder: "-- Pilih Pasien --",
            allowClear: true // Opsional
        });
    });
</script> --}}
@endpush