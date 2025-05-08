@extends('layouts.app') {{-- Sesuaikan dengan layout utama Anda --}}

@section('title', 'Kelola Pasien')
@section('page-title', 'Daftar Pasien')

@section('content')
<div class="bg-white rounded-xl shadow p-6 md:p-8 border border-gray-200">
    <div class="flex flex-col sm:flex-row justify-between items-center mb-6 gap-4">
        <h2 class="text-xl font-semibold text-gray-800">Daftar Pasien Terdaftar</h2>
        <div class="flex flex-col sm:flex-row items-center gap-2 w-full sm:w-auto">
             <form action="{{ route('admin.pasien.index') }}" method="GET" class="flex gap-2 w-full sm:w-auto">
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
                    {{-- Kolom Email & Kontak Dihapus --}}
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
                    {{-- Kolom Email & Kontak Dihapus --}}
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
                        <form action="{{ route('admin.pasien.destroy', $pasien) }}" method="POST" class="inline-block" onsubmit="return confirm('Apakah Anda yakin ingin menghapus pasien \'{{ $pasien->name }}\'?');">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="text-red-600 hover:text-red-800" title="Hapus">
                                <i class="ri-delete-bin-line text-lg"></i>
                            </button>
                        </form>
                    </td>
                </tr>
                @empty
                <tr>
                    {{-- Sesuaikan colspan menjadi 6 karena kolom berkurang --}}
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
@endsection
