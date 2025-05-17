@extends('layouts.app')
@section('title', 'Kelola Gejala')
@section('page-title', 'Kelola Gejala Diagnosis')

@section('content')
    <div class="container">
        {{-- Notifikasi --}}
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

        <!-- {{-- Daftar Gejala --}}
        <div class="bg-white rounded-xl shadow overflow-hidden border border-gray-200">
            <div class="px-6 py-4 border-b border-gray-200">
                <h2 class="text-xl font-semibold text-gray-800">Daftar Gejala Tersimpan</h2>
            </div> -->

            <div class="overflow-x-auto">
                <table class="min-w-full divide-y divide-gray-200">
                    <thead class="bg-gray-50">
                        <tr>
                            <th scope="col"
                                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Kode</th>
                            <th scope="col"
                                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Nama Gejala</th>
                            <th scope="col"
                                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                MB</th>
                            <th scope="col"
                                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                                MD</th>
                            <th scope="col"
                                class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">
                                Status</th>
                            <th scope="col" class="px-6 py-3 text-center text-xs font-medium space-x-2">Aksi</th>
                        </tr>
                    </thead>
                    <tbody class="bg-white divide-y divide-gray-200">
                        @forelse ($gejalaList as $g)
                            <tr class="hover:bg-gray-50 transition-colors duration-150">
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{{ $g->kode }}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ $g->nama }}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                                    {{ number_format($g->mb, 2, ',', '.') }}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
                                    {{ number_format($g->md, 2, ',', '.') }}</td>
                                <td class="px-6 py-4 whitespace-nowrap text-center text-sm">
                                    @if ($g->aktif)
                                        <span
                                            class="px-2.5 py-0.5 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">Aktif</span>
                                    @else
                                        <span
                                            class="px-2.5 py-0.5 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">Nonaktif</span>
                                    @endif
                                </td>
                                <td class="px-6 py-4 whitespace-nowrap text-center text-sm font-medium space-x-2">
                                    <a href="{{ route('admin.gejala.edit', $g->_id) }}" title="Edit"
                                        class="inline-flex items-center justify-center w-8 h-8 text-indigo-600 hover:text-indigo-900 hover:bg-indigo-100 rounded-full transition">
                                        <i class="ri-pencil-line text-lg"></i>
                                    </a>

                                    <form action="{{ route('admin.gejala.toggleStatus', $g->_id) }}" method="POST"  
                                        class="inline-block"
                                        onsubmit="return confirm('Apakah Anda yakin ingin {{ $g->aktif ? 'menonaktifkan' : 'mengaktifkan' }} gejala ini?');">
                                        @csrf
                                        @method('PATCH')
                                        <button type="submit" title="{{ $g->aktif ? 'Nonaktifkan' : 'Aktifkan' }}"
                                            class="inline-flex items-center justify-center w-8 h-8 {{ $g->aktif ? 'text-yellow-600 hover:text-yellow-900 hover:bg-yellow-100' : 'text-green-600 hover:text-green-900 hover:bg-green-100' }} rounded-full transition">
                                            <i class="{{ $g->aktif ? 'ri-toggle-fill' : 'ri-toggle-line' }} text-xl"></i>
                                        </button>
                                    </form>

                                    <form action="{{ route('admin.gejala.destroy', $g->_id) }}" method="POST"  
                                        class="inline-block"
                                        onsubmit="return confirm('PERHATIAN: Menghapus gejala ini mungkin mempengaruhi data diagnosis yang ada. Apakah Anda yakin ingin melanjutkan?');">
                                        @csrf
                                        @method('DELETE')
                                        <button type="submit" title="Hapus"
                                            class="inline-flex items-center justify-center w-8 h-8 text-red-600 hover:text-red-900 hover:bg-red-100 rounded-full transition">
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
@endsection

@push('scripts')
    <script>
        // Script tambahan jika diperlukan
    </script>
@endpush