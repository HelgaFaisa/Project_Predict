@extends('layouts.app')

{{-- Asumsi $patient dikirim dari Controller --}}
@section('title', 'Detail Pasien: ' . ($patient->name ?? 'N/A'))
@section('page-title', 'Detail Informasi Pasien')

@section('content')
<div class="bg-white rounded-xl shadow p-6 md:p-8 border border-gray-200">
    <div class="flex justify-between items-start mb-6">
        <div>
            <h2 class="text-2xl font-semibold text-gray-800">{{ $patient->name ?? 'N/A' }}</h2>
            <p class="text-sm text-gray-500">ID Pasien: {{ $patient->id ?? $patient['_id'] ?? 'N/A' }}</p>
        </div>
        <div class="flex space-x-2">
             <a href="{{ route('admin.pasien.edit', ['pasien' => $patient->id ?? $patient['_id']]) }}" class="inline-flex items-center px-4 py-2 bg-yellow-500 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-yellow-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-yellow-500 transition">
                <i class="ri-pencil-line mr-1"></i> Edit
            </a>
             <a href="{{ route('admin.pasien.index') }}" class="inline-flex items-center px-4 py-2 bg-white border border-gray-300 rounded-md font-semibold text-xs text-gray-700 uppercase tracking-widest shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition">
                Kembali ke Daftar
            </a>
        </div>
    </div>

    {{-- Detail Informasi Pasien --}}
    <div class="border-t border-gray-200 pt-6">
        <dl class="grid grid-cols-1 md:grid-cols-3 gap-x-4 gap-y-4 text-sm">
            <div class="md:col-span-1">
                <dt class="font-medium text-gray-500">Nama Lengkap</dt>
                <dd class="mt-1 text-gray-900">{{ $patient->name ?? 'N/A' }}</dd>
            </div>
            <div class="md:col-span-1">
                <dt class="font-medium text-gray-500">Tanggal Lahir</dt>
                <dd class="mt-1 text-gray-900">{{ isset($patient->date_of_birth) ? \Carbon\Carbon::parse($patient->date_of_birth)->isoFormat('D MMMM YYYY') : 'N/A' }}</dd>
            </div>
             <div class="md:col-span-1">
                <dt class="font-medium text-gray-500">Umur</dt>
                {{-- <dd class="mt-1 text-gray-900">{{ isset($patient->date_of_birth) ? \Carbon\Carbon::parse($patient->date_of_birth)->age . ' Tahun' : 'N/A' }}</dd> --}}
                 <dd class="mt-1 text-gray-900">N/A</dd> {{-- Placeholder jika logic umur belum ada --}}
            </div>
             <div class="md:col-span-1">
                <dt class="font-medium text-gray-500">Jenis Kelamin</dt>
                <dd class="mt-1 text-gray-900">{{ $patient->gender ?? 'N/A' }}</dd>
            </div>
             <div class="md:col-span-1">
                <dt class="font-medium text-gray-500">Nomor Kontak</dt>
                <dd class="mt-1 text-gray-900">{{ $patient->contact_number ?? 'N/A' }}</dd>
            </div>
            <div class="md:col-span-1">
                <dt class="font-medium text-gray-500">Alamat Email</dt>
                <dd class="mt-1 text-gray-900">{{ $patient->email ?? 'N/A' }}</dd>
            </div>
             <div class="md:col-span-3">
                <dt class="font-medium text-gray-500">Alamat Lengkap</dt>
                <dd class="mt-1 text-gray-900 whitespace-pre-line">{{ $patient->address ?? 'N/A' }}</dd>
            </div>
            {{-- Tambahkan field detail lainnya jika ada --}}
        </dl>
    </div>

    {{-- Placeholder untuk Riwayat Pemeriksaan/Prediksi --}}
    <div class="mt-8 border-t border-gray-200 pt-6">
        <h3 class="text-lg font-semibold text-gray-700 mb-4">Riwayat Pemeriksaan/Prediksi</h3>
        <div class="text-center text-gray-500 italic">
            (Fitur riwayat pemeriksaan untuk pasien ini akan ditampilkan di sini)
        </div>
        {{-- Di sini nanti bisa ditambahkan tabel atau list riwayat dari koleksi 'pemeriksaan' --}}
        {{-- yang memiliki patient_id = $patient->id --}}

         {{-- Tombol untuk langsung ke form prediksi untuk pasien ini --}}
         <div class="mt-4">
             <a href="{{ route('admin.prediksi.index', ['prefill_patient_id' => $patient->id ?? $patient['_id']]) }}" class="inline-flex items-center px-4 py-2 bg-green-600 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 transition">
                 <i class="ri-flask-line mr-1"></i> Lakukan Prediksi Baru untuk Pasien Ini
             </a>
         </div>
    </div>

</div>
@endsection