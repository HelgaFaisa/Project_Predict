@extends('layouts.app') {{-- Sesuaikan dengan layout utama Anda --}}

@section('title', 'Kelola Pasien')
@section('page-title', 'Daftar Pasien')

@section('content')
<div class="bg-white rounded-xl shadow p-6 md:p-8 border border-gray-200">
    <div class="flex flex-col sm:flex-row justify-between items-center mb-6 gap-4">
        <h2 class="text-xl font-semibold text-gray-800">Daftar Pasien Terdaftar</h2>
        {{-- Bagian yang dimodifikasi untuk alignment --}}
        <div class="flex flex-col sm:flex-row items-center sm:items-baseline gap-2 w-full sm:w-auto">
            <form action="{{ route('admin.pasien.index') }}" method="GET" class="flex items-center gap-2 w-full sm:w-auto"> 
                <input type="text" name="search" placeholder="Cari nama/NIK..." value="{{ request('search') }}"
                       class="w-full sm:w-64 px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 text-sm">
                <button type="submit" class="inline-flex items-center px-3 py-2 bg-gray-200 border border-gray-300 rounded-md font-semibold text-xs text-gray-700 hover:bg-gray-300 transition">
                    <i class="ri-search-line"></i>
                </button>
            </form>
            <a href="{{ route('admin.pasien.create') }}" class="w-full mt-2 sm:mt-0 sm:w-auto inline-flex items-center justify-center px-4 py-2 bg-indigo-600 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-indigo-700 active:bg-indigo-800 focus:outline-none focus:border-indigo-900 focus:ring focus:ring-indigo-300 disabled:opacity-25 transition">
                <i class="ri-user-add-line mr-2 -ml-1"></i> Tambah Pasien
            </a>
        </div>
        {{-- Akhir bagian yang dimodifikasi --}}
    </div>

    @include('partials.alerts') {{-- Pastikan Anda punya partials/alerts.blade.php --}}

    <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
                <tr>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nama Pasien</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">NIK</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Usia</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Jenis Kelamin</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tgl. Registrasi</th>
                    <th scope="col" class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Aksi</th>
                </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
                @forelse ($patients as $pasien)
                <tr class="hover:bg-gray-50 transition-colors">
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm font-medium text-gray-900">{{ $pasien->name }}</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ $pasien->nik ?? '-' }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {{ $pasien->age ?? 'N/A' }} {{-- Menggunakan accessor 'age' dari model --}}
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ $pasien->gender ?? '-' }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                        {{ $pasien->created_at ? $pasien->created_at->translatedFormat('d M Y') : '-' }}
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium space-x-2">
                        <a href="{{ route('admin.pasien.show', $pasien) }}" class="text-blue-600 hover:text-blue-800" title="Lihat Detail">
                            <i class="ri-eye-line text-lg"></i>
                        </a>
                        <a href="{{ route('admin.pasien.edit', $pasien) }}" class="text-indigo-600 hover:text-indigo-800" title="Edit">
                            <i class="ri-pencil-line text-lg"></i>
                        </a>
                        <form action="{{ route('admin.pasien.destroy', $pasien) }}" method="POST" class="inline-block delete-pasien-form">
                            @csrf
                            @method('DELETE')
                            <button type="button" {{-- Ubah type menjadi "button" untuk mencegah submit langsung --}}
                                    class="text-red-600 hover:text-red-800 tombol-hapus-pasien"
                                    title="Hapus"
                                    data-pasien-name="{{ $pasien->name }}"
                                    data-form-action="{{ route('admin.pasien.destroy', $pasien) }}"> {{-- Simpan action form --}}
                                <i class="ri-delete-bin-line text-lg"></i>
                            </button>
                        </form>
                    </td>
                </tr>
                @empty
                <tr>
                    <td colspan="6" class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">
                        Belum ada data pasien terdaftar.
                    </td>
                </tr>
                @endforelse
            </tbody>
        </table>
    </div>
    <div class="mt-6">
        {{ $patients->appends(request()->query())->links() }}
    </div>
</div>
@endsection {{-- Akhir dari @section('content') --}}

{{-- MODAL KONFIRMASI HAPUS --}}
<div id="konfirmasiHapusModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full flex items-center justify-center" style="display: none; z-index: 100;">
    <div id="modalKonten" class="relative bg-white p-6 rounded-lg shadow-xl w-full max-w-md mx-auto" style="position: absolute;"> {{-- position: absolute untuk positioning dinamis --}}
        <div class="text-center">
            <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-100">
                <svg class="h-6 w-6 text-red-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z" />
                </svg>
            </div>
            <h3 class="text-lg leading-6 font-medium text-gray-900 mt-3" id="modalTitle">Konfirmasi Penghapusan</h3>
            <div class="mt-2 px-7 py-3">
                <p class="text-sm text-gray-500" id="modalMessage">Apakah Anda yakin ingin menghapus pasien ini?</p>
            </div>
            <div class="items-center px-4 py-3 gap-3"> {{-- Seharusnya flex atau inline-flex untuk gap-3 berfungsi, atau gunakan margin manual jika tidak --}}
                <button id="tombolBatalKonfirmasi" class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md hover:bg-gray-300 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500 mr-2">
                    Batal
                </button>
                <button id="tombolHapusKonfirmasi" class="px-4 py-2 bg-red-600 text-white rounded-md hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-red-500">
                    Ya, Hapus
                </button>
            </div>
        </div>
    </div>
</div>

@push('scripts')
<script>
document.addEventListener('DOMContentLoaded', function () {
    const modal = document.getElementById('konfirmasiHapusModal');
    const modalKonten = document.getElementById('modalKonten');
    const modalMessage = document.getElementById('modalMessage');
    const tombolBatal = document.getElementById('tombolBatalKonfirmasi');
    const tombolHapus = document.getElementById('tombolHapusKonfirmasi');
    let formUntukDihapus = null;

    document.querySelectorAll('.tombol-hapus-pasien').forEach(button => {
        button.addEventListener('click', function (event) {
            event.preventDefault(); // Mencegah aksi default tombol

            const pasienName = this.dataset.pasienName;
            formUntukDihapus = this.closest('form.delete-pasien-form'); // Dapatkan form terdekat

            modalMessage.textContent = `Apakah Anda yakin ingin menghapus pasien '${pasienName}'?`;

            // Kalkulasi posisi modal
            const buttonRect = this.getBoundingClientRect();
            const scrollY = window.scrollY || window.pageYOffset;
            const scrollX = window.scrollX || window.pageXOffset;

            let topPos = buttonRect.bottom + scrollY + 10;
            // Anda telah mengubah offset menjadi -375, ini dipertahankan
            let leftPos = buttonRect.left + scrollX - (modalKonten.offsetWidth / 2) + (buttonRect.width / 2) - 375;

            // Batasi agar modal tidak keluar layar
            if (leftPos < 10) { // Beri sedikit padding dari tepi kiri
                leftPos = 10;
            }
            if ((leftPos + modalKonten.offsetWidth) > (window.innerWidth - 10)) { // Beri sedikit padding dari tepi kanan
                leftPos = window.innerWidth - modalKonten.offsetWidth - 10;
            }
            if ((topPos + modalKonten.offsetHeight) > (window.innerHeight + scrollY -10) ) { // Cek jika keluar bawah viewport
                 topPos = buttonRect.top + scrollY - modalKonten.offsetHeight - 10; // Coba tampilkan di atas tombol
            }
            if (topPos < (scrollY + 10)) { // Cek jika keluar atas viewport (setelah penyesuaian di atas)
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

    modal.addEventListener('click', function (event) {
        if (event.target === modal) {
            modal.style.display = 'none';
            formUntukDihapus = null;
        }
    });
});
</script>
@endpush