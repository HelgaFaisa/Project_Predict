@extends('layouts.app')
@section('title', 'Kelola Gejala')
@section('page-title', 'Kelola Gejala Diagnosis')

@section('content')
    <div class="container">
        {{-- Notifikasi --}}
        @if (session('success'))
            <div id="alert-success" class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-6" role="alert">
                <strong class="font-bold">Sukses!</strong>
                <span class="block sm:inline">{{ session('success') }}</span>
                <button type="button" class="absolute top-0 bottom-0 right-0 px-4 py-3" onclick="closeAlert('alert-success')">
                    <svg class="fill-current h-6 w-6 text-green-500" role="button" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><title>Close</title><path d="M14.348 14.849a1.2 1.2 0 0 1-1.697 0L10 11.819l-2.651 3.029a1.2 1.2 0 1 1-1.697-1.697l2.758-3.15-2.759-3.152a1.2 1.2 0 1 1 1.697-1.697L10 8.183l2.651-3.031a1.2 1.2 0 1 1 1.697 1.697l-2.758 3.152 2.758 3.15a1.2 1.2 0 0 1 0 1.698z"/></svg>
                </button>
            </div>
        @endif

        @if (session('error'))
            <div id="alert-error" class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-6" role="alert">
                <strong class="font-bold">Error!</strong>
                <span class="block sm:inline">{{ session('error') }}</span>
                <button type="button" class="absolute top-0 bottom-0 right-0 px-4 py-3" onclick="closeAlert('alert-error')">
                    <svg class="fill-current h-6 w-6 text-red-500" role="button" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><title>Close</title><path d="M14.348 14.849a1.2 1.2 0 0 1-1.697 0L10 11.819l-2.651 3.029a1.2 1.2 0 1 1-1.697-1.697l2.758-3.15-2.759-3.152a1.2 1.2 0 1 1 1.697-1.697L10 8.183l2.651-3.031a1.2 1.2 0 1 1 1.697 1.697l-2.758 3.152 2.758 3.15a1.2 1.2 0 0 1 0 1.698z"/></svg>
                </button>
            </div>
        @endif

        {{-- Judul Halaman --}}
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-2xl font-bold text-gray-800">Daftar Gejala Tersimpan</h1>
            
            {{-- Button Tambah Gejala --}}
            <div>
                <a href="{{ route('admin.gejala.create') }}"
                    class="inline-flex items-center px-4 py-2 bg-indigo-600 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-indigo-700 active:bg-indigo-800 focus:outline-none focus:border-indigo-900 focus:ring focus:ring-indigo-300 disabled:opacity-25 transition">
                    <i class="ri-add-line mr-2"></i>
                    Tambah Gejala Baru
                </a>
            </div>
        </div>

        <div class="bg-white rounded-xl shadow overflow-hidden border border-gray-200">
            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Kode</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nama Gejala</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">MB</th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">MD</th>
                            <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                            <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">Aksi</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        @forelse ($gejalaList as $g)
                            <tr class="hover:bg-gray-50 transition-colors duration-150">
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ $g->kode }}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ $g->nama }}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">{{ number_format($g->mb, 2, ',', '.') }}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">{{ number_format($g->md, 2, ',', '.') }}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-center text-sm">
                                    @if ($g->aktif)
                                        <span class="px-2.5 py-0.5 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">Aktif</span>
                                    @else
                                        <span class="px-2.5 py-0.5 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">Nonaktif</span>
                                    @endif
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-center text-sm font-medium space-x-2">
                                    <a href="{{ route('admin.gejala.edit', $g->id) }}" title="Edit"
                                        class="inline-flex items-center justify-center w-8 h-8 text-indigo-600 hover:text-indigo-900 hover:bg-indigo-100 rounded-full transition">
                                        <i class="ri-pencil-line text-lg"></i>
                                    </a>

                                    {{-- FORM TOGGLE STATUS --}}
                                    <form action="{{ route('admin.gejala.toggleStatus', $g->id) }}" method="POST" class="inline-block form-aksi-gejala">
                                        @csrf
                                        @method('PATCH')
                                        <button type="button"
                                                class="tombol-aksi-gejala inline-flex items-center justify-center w-8 h-8 {{ $g->aktif ? 'text-yellow-600 hover:text-yellow-900 hover:bg-yellow-100' : 'text-green-600 hover:text-green-900 hover:bg-green-100' }} rounded-full transition"
                                                title="{{ $g->aktif ? 'Nonaktifkan' : 'Aktifkan' }}"
                                                data-modal-title="Konfirmasi Ubah Status"
                                                data-modal-message="Apakah Anda yakin ingin {{ $g->aktif ? 'menonaktifkan' : 'mengaktifkan' }} gejala '{{ $g->nama }}' ini?"
                                                data-modal-confirm-text="{{ $g->aktif ? 'Ya, Nonaktifkan' : 'Ya, Aktifkan' }}"
                                                data-modal-confirm-button-class="{{ $g->aktif ? 'bg-yellow-500 hover:bg-yellow-600 focus:ring-yellow-400' : 'bg-green-500 hover:bg-green-600 focus:ring-green-400' }}"
                                                data-modal-icon-bg-class="{{ $g->aktif ? 'bg-yellow-100' : 'bg-green-100' }}"
                                                data-modal-icon-text-class="{{ $g->aktif ? 'text-yellow-600' : 'text-green-600' }}"
                                                data-modal-icon-path="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z" {{-- Default icon warning, bisa diubah di JS jika perlu icon lain --}}
                                                >
                                            <i class="{{ $g->aktif ? 'ri-toggle-fill' : 'ri-toggle-line' }} text-xl"></i>
                                        </button>
                                    </form>

                                    {{-- FORM HAPUS GEJALA --}}
                                    <form action="{{ route('admin.gejala.destroy', $g->id) }}" method="POST" class="inline-block form-aksi-gejala">
                                        @csrf
                                        @method('DELETE')
                                        <button type="button"
                                                class="tombol-aksi-gejala inline-flex items-center justify-center w-8 h-8 text-red-600 hover:text-red-900 hover:bg-red-100 rounded-full transition"
                                                title="Hapus"
                                                data-modal-title="Konfirmasi Hapus Gejala"
                                                data-modal-message="PERHATIAN: Menghapus gejala '{{ $g->nama }}' ini mungkin mempengaruhi data diagnosis yang ada. Apakah Anda yakin ingin melanjutkan?"
                                                data-modal-confirm-text="Ya, Hapus"
                                                data-modal-confirm-button-class="bg-red-600 hover:bg-red-700 focus:ring-red-500"
                                                data-modal-icon-bg-class="bg-red-100"
                                                data-modal-icon-text-class="text-red-600"
                                                data-modal-icon-path="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z"
                                                >
                                            <i class="ri-delete-bin-line text-lg"></i>
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="6" class="px-6 py-10 text-center text-sm text-gray-500">
                                    Belum ada data gejala yang tersimpan. Silakan tambahkan gejala baru menggunakan tombol di atas.
                                </td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>

            @if ($gejalaList instanceof \Illuminate\Pagination\LengthAwarePaginator && $gejalaList->hasPages())
                <div class="px-6 py-4 border-t border-gray-200 bg-white">
                    {{ $gejalaList->links() }}
                </div>
            @endif
        </div>
    </div>

{{-- MODAL KONFIRMASI AKSI GEJALA (UMUM) --}}
<div id="konfirmasiAksiGejalaModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full flex items-center justify-center" style="display: none; z-index: 1050;">
    <div id="modalAksiGejalaKonten" class="relative bg-white p-6 rounded-lg shadow-xl w-full max-w-md mx-auto" style="position: absolute;">
        <div class="text-center">
            <div id="modalAksiGejalaIconContainer" class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-100"> {{-- Default to red --}}
                <svg id="modalAksiGejalaIconSVG" class="h-6 w-6 text-red-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                    {{-- Path default, bisa diubah oleh JS --}}
                    <path id="modalAksiGejalaIconPath" stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z" />
                </svg>
            </div>
            <h3 class="text-lg leading-6 font-medium text-gray-900 mt-3" id="modalAksiGejalaTitle">Konfirmasi Aksi</h3>
            <div class="mt-2 px-7 py-3">
                <p class="text-sm text-gray-500" id="modalAksiGejalaMessage">Apakah Anda yakin ingin melanjutkan aksi ini?</p>
            </div>
            <div class="flex justify-center items-center px-4 py-3 gap-3">
                <button id="tombolBatalAksiGejala" class="px-4 py-2 bg-gray-200 text-gray-800 rounded-md hover:bg-gray-300 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500">
                    Batal
                </button>
                <button id="tombolKonfirmasiAksiGejala" class="px-4 py-2 text-white rounded-md focus:outline-none focus:ring-2 focus:ring-offset-2">
                    Ya, Lanjutkan
                </button>
            </div>
        </div>
    </div>
</div>
@endsection

@push('scripts')
    <script>
        // Auto-hide alerts
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(function() {
                ['alert-success', 'alert-error'].forEach(function(alertId) {
                    const alertElement = document.getElementById(alertId);
                    if (alertElement) {
                        alertElement.style.transition = 'opacity 1s';
                        alertElement.style.opacity = '0';
                        setTimeout(() => alertElement.style.display = 'none', 1000);
                    }
                });
            }, 5000);
        });

        function closeAlert(alertId) {
            const alertElement = document.getElementById(alertId);
            if (alertElement) {
                alertElement.style.transition = 'opacity 0.5s';
                alertElement.style.opacity = '0';
                setTimeout(() => alertElement.style.display = 'none', 500);
            }
        }

        // Modal Konfirmasi Aksi Gejala
        const modalAksiGejala = document.getElementById('konfirmasiAksiGejalaModal');
        const modalAksiGejalaKonten = document.getElementById('modalAksiGejalaKonten');
        const modalAksiGejalaTitle = document.getElementById('modalAksiGejalaTitle');
        const modalAksiGejalaMessage = document.getElementById('modalAksiGejalaMessage');
        const tombolKonfirmasiAksiGejala = document.getElementById('tombolKonfirmasiAksiGejala');
        const tombolBatalAksiGejala = document.getElementById('tombolBatalAksiGejala');
        
        const modalAksiGejalaIconContainer = document.getElementById('modalAksiGejalaIconContainer');
        const modalAksiGejalaIconPath = document.getElementById('modalAksiGejalaIconPath');
        const modalAksiGejalaIconSVG = document.getElementById('modalAksiGejalaIconSVG');


        let formUntukAksiGejala = null;

        if (modalAksiGejala && modalAksiGejalaKonten && modalAksiGejalaTitle && modalAksiGejalaMessage && tombolKonfirmasiAksiGejala && tombolBatalAksiGejala) {
            document.querySelectorAll('.tombol-aksi-gejala').forEach(button => {
                button.addEventListener('click', function(event) {
                    event.preventDefault();
                    formUntukAksiGejala = this.closest('form.form-aksi-gejala');

                    // Ambil data dari atribut tombol
                    const title = this.dataset.modalTitle || 'Konfirmasi Aksi';
                    const message = this.dataset.modalMessage || 'Apakah Anda yakin ingin melanjutkan aksi ini?';
                    const confirmText = this.dataset.modalConfirmText || 'Ya, Lanjutkan';
                    const confirmButtonClass = this.dataset.modalConfirmButtonClass || 'bg-indigo-600 hover:bg-indigo-700 focus:ring-indigo-500';
                    const iconBgClass = this.dataset.modalIconBgClass || 'bg-blue-100';
                    const iconTextClass = this.dataset.modalIconTextClass || 'text-blue-600';
                    const iconPathD = this.dataset.modalIconPath || 'M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z'; // Default: info icon

                    // Set konten modal
                    modalAksiGejalaTitle.textContent = title;
                    modalAksiGejalaMessage.textContent = message;
                    tombolKonfirmasiAksiGejala.textContent = confirmText;
                    
                    // Reset dan set class tombol konfirmasi
                    tombolKonfirmasiAksiGejala.className = 'px-4 py-2 text-white rounded-md focus:outline-none focus:ring-2 focus:ring-offset-2'; // base classes
                    confirmButtonClass.split(' ').forEach(cls => tombolKonfirmasiAksiGejala.classList.add(cls));

                    // Set ikon
                    modalAksiGejalaIconContainer.className = 'mx-auto flex items-center justify-center h-12 w-12 rounded-full'; // base classes
                    iconBgClass.split(' ').forEach(cls => modalAksiGejalaIconContainer.classList.add(cls));
                    
                    modalAksiGejalaIconSVG.className = 'h-6 w-6'; // base classes
                    iconTextClass.split(' ').forEach(cls => modalAksiGejalaIconSVG.classList.add(cls));
                    modalAksiGejalaIconPath.setAttribute('d', iconPathD);


                    // Kalkulasi posisi modal
                    const buttonRect = this.getBoundingClientRect();
                    const scrollY = window.scrollY || window.pageYOffset;
                    const scrollX = window.scrollX || window.pageXOffset;

                    let topPos = buttonRect.bottom + scrollY + 10;
                    // Sesuaikan offset ini. Mungkin perlu lebih ke tengah atau sedikit ke kiri dari tombol.
                    let leftPos = buttonRect.left + scrollX - (modalAksiGejalaKonten.offsetWidth / 2) + (buttonRect.width / 2) - 375; 

                    if (leftPos < 10) leftPos = 10;
                    if ((leftPos + modalAksiGejalaKonten.offsetWidth) > (window.innerWidth - 10)) {
                        leftPos = window.innerWidth - modalAksiGejalaKonten.offsetWidth - 10;
                    }
                    if ((topPos + modalAksiGejalaKonten.offsetHeight) > (window.innerHeight + scrollY -10)) {
                        topPos = buttonRect.top + scrollY - modalAksiGejalaKonten.offsetHeight - 10;
                    }
                    if (topPos < (scrollY + 10)) {
                        topPos = scrollY + 10;
                    }

                    modalAksiGejalaKonten.style.top = `${topPos}px`;
                    modalAksiGejalaKonten.style.left = `${leftPos}px`;
                    modalAksiGejala.style.display = 'flex';
                });
            });

            tombolBatalAksiGejala.addEventListener('click', function() {
                modalAksiGejala.style.display = 'none';
                formUntukAksiGejala = null;
            });

            tombolKonfirmasiAksiGejala.addEventListener('click', function() {
                if (formUntukAksiGejala) {
                    formUntukAksiGejala.submit();
                }
                modalAksiGejala.style.display = 'none';
                formUntukAksiGejala = null;
            });

            modalAksiGejala.addEventListener('click', function(event) {
                if (event.target === modalAksiGejala) {
                    modalAksiGejala.style.display = 'none';
                    formUntukAksiGejala = null;
                }
            });
        } else {
            console.warn('Elemen modal konfirmasi aksi gejala tidak sepenuhnya ditemukan.');
        }
    </script>
@endpush