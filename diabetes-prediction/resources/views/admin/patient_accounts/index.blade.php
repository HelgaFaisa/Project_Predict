@extends('layouts.app')

@section('title', 'Manajemen Akun Pasien')
@section('page-title', 'Daftar Akun Pasien')

@section('content')
<div class="bg-white rounded-xl shadow p-6 md:p-8 border border-gray-200">
    <div class="flex flex-col sm:flex-row justify-between items-center mb-6 gap-4">
        <h2 class="text-xl font-semibold text-gray-800">Akun Login Pasien</h2>
        <div class="flex flex-col sm:flex-row items-center gap-2 w-full sm:w-auto">
            <form action="{{ route('admin.patient-accounts.index') }}" method="GET" class="flex gap-2 w-full sm:w-auto">
                <input type="text" name="search" placeholder="Cari nama/email..." value="{{ request('search') }}"
                       class="w-full sm:w-64 px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 text-sm">
                <button type="submit" class="inline-flex items-center px-3 py-2 bg-gray-200 border border-gray-300 rounded-md font-semibold text-xs text-gray-700 hover:bg-gray-300 transition">
                    <i class="ri-search-line"></i>
                </button>
            </form>
            <a href="{{ route('admin.patient-accounts.create') }}" class="w-full mt-2 sm:mt-0 sm:w-auto inline-flex items-center justify-center px-4 py-2 bg-indigo-600 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-indigo-700 active:bg-indigo-800 focus:outline-none focus:border-indigo-900 focus:ring focus:ring-indigo-300 disabled:opacity-25 transition">
                <i class="ri-user-add-line mr-2 -ml-1"></i> Tambah Akun
            </a>
        </div>
    </div>

    @include('partials.alerts')

    <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
                <tr>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nama Pasien</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Email Login</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">No. Telepon</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                    <th scope="col" class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">Aksi</th>
                </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
                @forelse ($accounts as $account)
                <tr class="hover:bg-gray-50 transition-colors">
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div class="text-sm font-medium text-gray-900">{{ $account->name }}</div>
                        <div class="text-xs text-gray-500">ID Pasien: {{ $account->patient_id }}</div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ $account->email }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{{ $account->phone_number ?? '-' }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-sm">
                        @if($account->status == 'active')
                            <span class="px-2.5 py-0.5 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                Aktif
                            </span>
                        @else
                            <span class="px-2.5 py-0.5 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">
                                Tidak Aktif
                            </span>
                        @endif
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium space-x-2">
                        <a href="{{ route('admin.patient-accounts.edit', $account) }}" class="text-indigo-600 hover:text-indigo-800" title="Edit Akun">
                            <i class="ri-pencil-line text-lg"></i>
                        </a>
                        {{-- FORM HAPUS AKUN (MODIFIKASI) --}}
                        <form action="{{ route('admin.patient-accounts.destroy', $account) }}" method="POST" class="inline-block form-hapus-akun">
                            @csrf
                            @method('DELETE')
                            <button type="button" {{-- Diubah dari type="submit" --}}
                                    class="text-red-600 hover:text-red-800 tombol-hapus-akun"
                                    title="Hapus Akun"
                                    data-account-name="{{ $account->name }}"> {{-- Menyimpan nama akun --}}
                                <i class="ri-delete-bin-line text-lg"></i>
                            </button>
                        </form>
                    </td>
                </tr>
                @empty
                <tr>
                    <td colspan="5" class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">
                        Belum ada akun pasien.
                    </td>
                </tr>
                @endforelse
            </tbody>
        </table>
    </div>
    <div class="mt-6">
        {{ $accounts->appends(request()->query())->links() }}
    </div>
</div>

{{-- MODAL KONFIRMASI HAPUS (struktur sama seperti sebelumnya) --}}
<div id="konfirmasiHapusModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 overflow-y-auto h-full w-full flex items-center justify-center" style="display: none; z-index: 1050;">
    <div id="modalKonten" class="relative bg-white p-6 rounded-lg shadow-xl w-full max-w-md mx-auto" style="position: absolute;">
        <div class="text-center">
            <div class="mx-auto flex items-center justify-center h-12 w-12 rounded-full bg-red-100">
                <svg class="h-6 w-6 text-red-600" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z" />
                </svg>
            </div>
            <h3 class="text-lg leading-6 font-medium text-gray-900 mt-3" id="modalTitle">Konfirmasi Penghapusan</h3>
            <div class="mt-2 px-7 py-3">
                <p class="text-sm text-gray-500" id="modalMessage">Apakah Anda yakin ingin melanjutkan aksi ini?</p> {{-- Akan diisi oleh JS --}}
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
    // Script untuk Modal Konfirmasi Hapus Akun
    const modal = document.getElementById('konfirmasiHapusModal');
    const modalKonten = document.getElementById('modalKonten');
    const modalMessage = document.getElementById('modalMessage');
    const tombolBatal = document.getElementById('tombolBatalKonfirmasi');
    const tombolHapus = document.getElementById('tombolHapusKonfirmasi');
    let formUntukDihapus = null;

    if (modal && modalKonten && modalMessage && tombolBatal && tombolHapus) {
        document.querySelectorAll('.tombol-hapus-akun').forEach(button => {
            button.addEventListener('click', function (event) {
                event.preventDefault(); 

                formUntukDihapus = this.closest('form.form-hapus-akun');
                const accountName = this.dataset.accountName || 'akun ini'; // Fallback jika nama tidak ada
                
                modalMessage.textContent = `Apakah Anda yakin ingin menghapus akun untuk '${accountName}'?`;

                const buttonRect = this.getBoundingClientRect();
                const scrollY = window.scrollY || window.pageYOffset;
                const scrollX = window.scrollX || window.pageXOffset;

                // Sesuaikan offset ini agar pas dengan tombol hapus akun
                let topPos = buttonRect.bottom + scrollY + 10;
                let leftPos = buttonRect.left + scrollX - (modalKonten.offsetWidth / 2) + (buttonRect.width / 2) - 375; // Contoh offset -150px

                if (leftPos < 10) leftPos = 10;
                if ((leftPos + modalKonten.offsetWidth) > (window.innerWidth - 10)) {
                    leftPos = window.innerWidth - modalKonten.offsetWidth - 10;
                }
                if ((topPos + modalKonten.offsetHeight) > (window.innerHeight + scrollY - 10) ) {
                     topPos = buttonRect.top + scrollY - modalKonten.offsetHeight - 10;
                }
                if (topPos < (scrollY + 10)) {
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
    } else {
        console.warn('Elemen modal konfirmasi hapus tidak ditemukan. Pastikan HTML modal ada dan ID-nya benar.');
    }
</script>
@endpush