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
                        {{-- Tombol Hapus Riwayat (MODIFIKASI) --}}
                        <form action="{{ route('admin.prediction_history.destroy', $history) }}" method="POST" class="inline-block form-hapus-riwayat">
                            @csrf
                            @method('DELETE')
                            <button type="button" {{-- Diubah dari type="submit" --}}
                                    class="text-red-500 hover:text-red-700 tombol-hapus-riwayat"
                                    title="Hapus Riwayat"
                                    data-history-id="{{ $history->id }}"> {{-- Opsional: untuk referensi --}}
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

{{-- MODAL KONFIRMASI HAPUS RIWAYAT PREDIKSI (Gunakan ID yang sama atau beda, misal konfirmasiUmumModal) --}}
<div id="konfirmasiHapusModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full flex items-center justify-center" style="display: none; z-index: 1050;"> {{-- Pastikan z-index cukup tinggi --}}
    <div id="modalKonten" class="relative bg-white p-6 rounded-lg shadow-xl w-full max-w-md mx-auto" style="position: absolute;">
        <div class="text-center">
            <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-100">
                <svg class="h-6 w-6 text-red-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z" />
                </svg>
            </div>
            <h3 class="text-lg leading-6 font-medium text-gray-900 mt-3" id="modalTitle">Konfirmasi Penghapusan</h3>
            <div class="mt-2 px-7 py-3">
                <p class="text-sm text-gray-500" id="modalMessage">Apakah Anda yakin ingin menghapus riwayat prediksi ini?</p> {{-- Pesan default --}}
            </div>
            <div class="flex justify-center items-center px-4 py-3 gap-3">
                <button id="tombolBatalKonfirmasi" class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md hover:bg-gray-300 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500">
                    Batal
                </button>
                <button id="tombolHapusKonfirmasi" class="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500">
                    Ya, Hapus
                </button>
            </div>
        </div>
    </div>
</div>
@endsection

@push('scripts')
<script>
document.addEventListener('DOMContentLoaded', function () {
    const modal = document.getElementById('konfirmasiHapusModal');
    const modalKonten = document.getElementById('modalKonten');
    const modalMessage = document.getElementById('modalMessage'); // Untuk mengubah pesan jika perlu
    const tombolBatal = document.getElementById('tombolBatalKonfirmasi');
    const tombolHapus = document.getElementById('tombolHapusKonfirmasi');
    let formUntukDihapus = null;

    // Pastikan elemen modal ada sebelum menambahkan event listener
    if (modal && modalKonten && modalMessage && tombolBatal && tombolHapus) {
        document.querySelectorAll('.tombol-hapus-riwayat').forEach(button => {
            button.addEventListener('click', function (event) {
                event.preventDefault(); // Mencegah aksi default jika ada

                formUntukDihapus = this.closest('form.form-hapus-riwayat');
                
                // Atur pesan default atau kustom jika perlu
                // const historyId = this.dataset.historyId; // Jika ingin menggunakan ID di pesan
                modalMessage.textContent = 'Apakah Anda yakin ingin menghapus riwayat prediksi ini?';

                // Kalkulasi posisi modal
                const buttonRect = this.getBoundingClientRect();
                const scrollY = window.scrollY || window.pageYOffset;
                const scrollX = window.scrollX || window.pageXOffset;

                // Sesuaikan offset ini agar posisi modal pas dekat tombol hapus
                // Mungkin perlu nilai berbeda dari halaman pasien karena struktur tombol bisa beda
                let topPos = buttonRect.bottom + scrollY + 10;
                let leftPos = buttonRect.left + scrollX - (modalKonten.offsetWidth / 2) + (buttonRect.width / 2) - 375; // Contoh offset -100px

                // Batasan agar modal tidak keluar layar
                if (leftPos < 10) leftPos = 10;
                if ((leftPos + modalKonten.offsetWidth) > (window.innerWidth - 10)) {
                    leftPos = window.innerWidth - modalKonten.offsetWidth - 10;
                }
                if ((topPos + modalKonten.offsetHeight) > (window.innerHeight + scrollY - 10) ) {
                     topPos = buttonRect.top + scrollY - modalKonten.offsetHeight - 10;
                }
                 if (topPos < (scrollY + 10)) { // Pastikan tidak terlalu ke atas
                    topPos = scrollY + 10;
                }

                modalKonten.style.top = `${topPos}px`;
                modalKonten.style.left = `${leftPos}px`;
                modal.style.display = 'flex';
            });
        });

        tombolBatal.addEventListener('click', function () {
            modal.style.display = 'none';
            formUntukDihapus = null;
        });

        tombolHapus.addEventListener('click', function () {
            if (formUntukDihapus) {
                formUntukDihapus.submit();
            }
            modal.style.display = 'none';
            formUntukDihapus = null;
        });

        // Tutup modal jika klik di luar konten modal
        modal.addEventListener('click', function (event) {
            if (event.target === modal) {
                modal.style.display = 'none';
                formUntukDihapus = null;
            }
        });
    } else {
        console.warn('Elemen modal konfirmasi hapus tidak ditemukan. Pastikan HTML modal ada dan ID-nya benar.');
    }
});
</script>
@endpush