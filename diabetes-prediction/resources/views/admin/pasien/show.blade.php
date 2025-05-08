@extends('layouts.app') {{-- Sesuaikan dengan layout utama Anda --}}

@section('title', 'Detail Pasien: ' . $patient->name)
@section('page-title', 'Detail Pasien')

@section('content')
<div class="space-y-8">
    {{-- Informasi Detail Pasien --}}
    <div class="bg-white rounded-xl shadow p-6 md:p-8 border border-gray-200">
        <div class="flex flex-col sm:flex-row justify-between items-start mb-6 pb-4 border-b border-gray-200 gap-4">
            <div>
                <h2 class="text-2xl font-semibold text-gray-800">{{ $patient->name }}</h2>
                <p class="text-sm text-gray-500">ID Pasien: {{ $patient->_id }}</p>
            </div>
            <div class="flex space-x-2">
                 <a href="{{ route('admin.pasien.edit', $patient) }}" class="inline-flex items-center px-4 py-2 bg-indigo-100 border border-indigo-200 rounded-md font-semibold text-xs text-indigo-700 uppercase tracking-widest hover:bg-indigo-200 transition">
                    <i class="ri-pencil-line mr-2"></i>Edit Pasien
                </a>
                 <form action="{{ route('admin.pasien.destroy', $patient) }}" method="POST" onsubmit="return confirm('Apakah Anda yakin ingin menghapus pasien ini? Semua data terkait mungkin akan hilang.');">
                    @csrf
                    @method('DELETE')
                    <button type="submit" class="inline-flex items-center px-4 py-2 bg-red-100 border border-red-200 rounded-md font-semibold text-xs text-red-700 uppercase tracking-widest hover:bg-red-200 transition">
                        <i class="ri-delete-bin-line mr-2"></i>Hapus
                    </button>
                </form>
            </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-4 text-sm">
            {{-- NIK Ditampilkan di sini --}}
            <div>
                <dt class="font-medium text-gray-500">NIK</dt>
                <dd class="mt-1 text-gray-900 font-mono">{{ $patient->nik ?? '-' }}</dd> {{-- Font mono untuk angka --}}
            </div>
            <div>
                <dt class="font-medium text-gray-500">Jenis Kelamin</dt>
                <dd class="mt-1 text-gray-900">{{ $patient->gender ?? '-' }}</dd>
            </div>
            <div>
                <dt class="font-medium text-gray-500">Tanggal Lahir</dt>
                <dd class="mt-1 text-gray-900">{{ $patient->date_of_birth ? $patient->date_of_birth->translatedFormat('d F Y') : '-' }} (Usia: {{ $patient->age ?? 'N/A' }})</dd>
            </div>
            {{-- Bagian Email dan Kontak Dihapus --}}
            <div class="md:col-span-2">
                <dt class="font-medium text-gray-500">Alamat Lengkap</dt>
                <dd class="mt-1 text-gray-900 whitespace-pre-line">{{ $patient->address ?? '-' }}</dd>
            </div>
             <div class="md:col-span-2">
                <dt class="font-medium text-gray-500">Tanggal Registrasi</dt>
                <dd class="mt-1 text-gray-900">{{ $patient->created_at ? $patient->created_at->translatedFormat('l, d F Y H:i') : '-' }}</dd>
            </div>

            {{-- Status Prediksi Terakhir (Kode yang sudah ada) --}}
            <div class="md:col-span-2 pt-4 border-t border-gray-200 mt-2">
                <dt class="font-medium text-gray-500 mb-1">Status Prediksi Diabetes Terakhir</dt>
                <dd class="mt-1 text-gray-900">
                    @if($latestPrediction)
                        <span class="px-3 py-1 inline-flex text-sm leading-5 font-semibold rounded-full {{ $latestPrediction->result == 1 ? 'bg-red-100 text-red-800' : 'bg-green-100 text-green-800' }}">
                            {{ $latestPrediction->result == 1 ? 'Positif (Risiko Tinggi)' : 'Negatif (Risiko Rendah)' }}
                        </span>
                        <span class="text-xs text-gray-500 ml-2">
                            (Prediksi pada: {{ $latestPrediction->prediction_timestamp->translatedFormat('d M Y, H:i') }})
                        </span>
                        <a href="{{ route('admin.prediction_history.index', ['patient_id' => $patient->_id]) }}" class="text-indigo-600 hover:text-indigo-800 text-xs ml-3 font-medium">
                            Lihat Riwayat Lengkap &rarr;
                        </a>
                    @else
                        <span class="px-3 py-1 inline-flex text-sm leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">
                            Belum Ada Prediksi
                        </span>
                         <a href="{{ route('admin.prediksi.index', ['patient_id' => $patient->_id]) }}" class="text-indigo-600 hover:text-indigo-800 text-xs ml-3 font-medium">
                            Lakukan Prediksi Baru &rarr;
                        </a>
                    @endif
                </dd>
            </div>
        </div>
         <div class="mt-8 pt-6 border-t border-gray-200">
            <a href="{{ route('admin.pasien.index') }}" class="inline-flex items-center px-4 py-2 bg-gray-200 border border-gray-300 rounded-md font-semibold text-xs text-gray-700 uppercase tracking-widest hover:bg-gray-300 transition">
                &larr; Kembali ke Daftar Pasien
            </a>
        </div>
    </div>
</div>
@endsection
