@extends('layouts.app') {{-- Sesuaikan dengan layout admin Anda --}}

@section('title', 'Riwayat Prediksi Diabetes')
@section('page-title', 'Riwayat Prediksi')

@section('content')
<div class="bg-white rounded-xl shadow p-6 md:p-8 border border-gray-200">
    <div class="flex flex-col sm:flex-row justify-between items-center mb-6 gap-4">
        <div>
            <h2 class="text-xl font-semibold text-gray-800">Riwayat Prediksi Diabetes</h2>
            @if($patientFilter)
                <p class="text-sm text-gray-600 mt-1">Menampilkan riwayat untuk pasien: <strong class="text-indigo-700">{{ $patientFilter->name }}</strong> (ID: {{ $patientFilter->_id }})
                    <a href="{{ route('admin.prediction_history.index') }}" class="text-xs text-indigo-500 hover:underline ml-2">(Lihat Semua Riwayat)</a>
                </p>
            @else
                 <p class="text-sm text-gray-600 mt-1">Menampilkan semua riwayat prediksi.</p>
            @endif
        </div>
        {{-- Tambahkan Form Filter di sini jika diperlukan --}}
        {{-- <form action="{{ route('admin.prediction_history.index') }}" method="GET"> ... </form> --}}
    </div>

    @include('partials.alerts')

    <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
                <tr>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nama Pasien</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tanggal Prediksi</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Hasil</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Parameter Input</th>
                    <th scope="col" class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Aksi</th>
                </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
                @forelse ($histories as $history)
                <tr class="hover:bg-gray-50 transition-colors">
                    <td class="px-6 py-4 whitespace-nowrap">
                        @if($history->patient)
                            <a href="{{ route('admin.pasien.show', $history->patient_id) }}" class="text-sm font-medium text-indigo-600 hover:text-indigo-800">
                                {{ $history->patient->name }}
                            </a>
                            <div class="text-xs text-gray-500">ID: {{ $history->patient_id }}</div>
                        @else
                            <span class="text-sm text-gray-500 italic">Pasien Tidak Ditemukan</span>
                             <div class="text-xs text-gray-500">ID: {{ $history->patient_id }}</div>
                        @endif
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {{ $history->prediction_timestamp ? $history->prediction_timestamp->translatedFormat('d M Y, H:i') : '-' }}
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm">
                        @if($history->result == 1)
                            <span class="px-2.5 py-0.5 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">
                                Positif
                            </span>
                        @else
                            <span class="px-2.5 py-0.5 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                Negatif
                            </span>
                        @endif
                    </td>
                     <td class="px-6 py-4 text-xs text-gray-500">
                        Preg: {{ $history->pregnancies ?? 'N/A' }},
                        Glu: {{ $history->glucose ?? 'N/A' }},
                        BP: {{ $history->blood_pressure ?? 'N/A' }},
                        H: {{ $history->height ?? 'N/A' }}cm,
                        W: {{ $history->weight ?? 'N/A' }}kg,
                        BMI: {{ number_format($history->bmi ?? 0, 1) }},
                        Age: {{ $history->age ?? 'N/A' }}
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium space-x-2">
                        {{-- Tombol Hapus Riwayat (Opsional) --}}
                        <form action="{{ route('admin.prediction_history.destroy', $history) }}" method="POST" class="inline-block" onsubmit="return confirm('Apakah Anda yakin ingin menghapus riwayat prediksi ini?');">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="text-red-500 hover:text-red-700" title="Hapus Riwayat">
                                <i class="ri-delete-bin-line text-lg"></i>
                            </button>
                        </form>
                    </td>
                </tr>
                @empty
                <tr>
                    <td colspan="5" class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">
                        @if($patientFilter)
                            Belum ada riwayat prediksi untuk pasien ini.
                        @else
                            Belum ada riwayat prediksi yang tersimpan.
                        @endif
                    </td>
                </tr>
                @endforelse
            </tbody>
        </table>
    </div>
    <div class="mt-6">
        {{ $histories->links() }}
    </div>
</div>
@endsection
