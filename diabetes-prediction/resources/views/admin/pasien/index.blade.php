@extends('layouts.app')

@section('title', 'Kelola Pasien')
@section('page-title', 'Daftar Pasien')

@section('content')
<div class="space-y-6">

    {{-- Notifikasi Sukses/Error --}}
    @if (session('success'))
        <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4" role="alert">
            <strong class="font-bold">Sukses!</strong>
            <span class="block sm:inline">{{ session('success') }}</span>
        </div>
    @endif
    @if (session('error'))
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
            <strong class="font-bold">Error!</strong>
            <span class="block sm:inline">{{ session('error') }}</span>
        </div>
    @endif

    <div class="flex justify-between items-center mb-4">
        {{-- Tombol Tambah Pasien --}}
        <a href="{{ route('admin.pasien.create') }}" class="inline-flex items-center px-4 py-2 bg-indigo-600 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-indigo-700 active:bg-indigo-800 focus:outline-none focus:border-indigo-900 focus:ring focus:ring-indigo-300 disabled:opacity-25 transition">
            <i class="ri-add-line mr-2 -ml-1"></i>
            Tambah Pasien Baru
        </a>

        {{-- Fitur Pencarian (Opsional) --}}
        {{-- <form action="{{ route('admin.pasien.index') }}" method="GET">
            <div class="flex">
                <input type="text" name="search" placeholder="Cari Nama/ID Pasien..." value="{{ request('search') }}" class="px-3 py-2 border border-gray-300 rounded-l-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500">
                <button type="submit" class="px-4 py-2 bg-gray-600 text-white rounded-r-md hover:bg-gray-700">Cari</button>
            </div>
        </form> --}}
    </div>

    {{-- Tabel Daftar Pasien --}}
    <div class="bg-white rounded-xl shadow overflow-hidden border border-gray-200">
        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">ID Pasien</th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nama Lengkap</th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tgl Lahir/Umur</th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Kontak</th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Aksi</th>
                    </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                    {{-- Loop data pasien dari Controller --}}
                    {{-- Asumsi $patients adalah Paginator object --}}
                    @forelse ($patients as $patient)
                    <tr>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                            {{-- Ganti 'id' dengan '_id' jika Anda menggunakan _id MongoDB secara langsung --}}
                            {{ $patient->id ?? $patient['_id'] }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                            {{ $patient->name ?? 'N/A' }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                             {{-- Format tanggal jika perlu, contoh: --}}
                            {{ isset($patient->date_of_birth) ? \Carbon\Carbon::parse($patient->date_of_birth)->isoFormat('D MMMM YYYY') : 'N/A' }}
                             {{-- Hitung Umur jika ada tgl lahir --}}
                            {{-- ({{ isset($patient->date_of_birth) ? \Carbon\Carbon::parse($patient->date_of_birth)->age : 'N/A' }} thn) --}}
                        </td>
                         <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                            {{ $patient->contact_number ?? 'N/A' }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm font-medium space-x-2">
                            <a href="{{ route('admin.pasien.show', ['pasien' => $patient->id ?? $patient['_id']]) }}" class="text-blue-600 hover:text-blue-900" title="Lihat Detail">
                                <i class="ri-eye-line text-lg"></i>
                            </a>
                            <a href="{{ route('admin.pasien.edit', ['pasien' => $patient->id ?? $patient['_id']]) }}" class="text-indigo-600 hover:text-indigo-900" title="Edit">
                                <i class="ri-pencil-line text-lg"></i>
                            </a>
                            {{-- Form Hapus dengan Konfirmasi --}}
                            <form action="{{ route('admin.pasien.destroy', ['pasien' => $patient->id ?? $patient['_id']]) }}" method="POST" class="inline-block" onsubmit="return confirm('Apakah Anda yakin ingin menghapus pasien ini? Tindakan ini tidak dapat dibatalkan.');">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="text-red-600 hover:text-red-900" title="Hapus">
                                    <i class="ri-delete-bin-line text-lg"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                    @empty
                    <tr>
                        <td colspan="5" class="px-6 py-4 text-center text-sm text-gray-500">
                            Belum ada data pasien.
                        </td>
                    </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
         {{-- Tampilkan Link Pagination jika ada --}}
         @if ($patients->hasPages())
         <div class="p-4 bg-gray-50 border-t border-gray-200">
             {{ $patients->links() }} {{-- Pastikan Tailwind pagination view sudah di-publish --}}
         </div>
         @endif
    </div>
</div>
@endsection