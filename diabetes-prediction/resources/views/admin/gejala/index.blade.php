@extends('layouts.app')

@section('title', 'Kelola Gejala')
@section('page-title', 'Kelola Gejala Diagnosis')

@section('content')
<div class="space-y-8">

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

    <div class="bg-white rounded-xl shadow p-6 border border-gray-200">
        <h2 class="text-xl font-semibold text-gray-800 mb-4">
            @isset($editingGejala)
                Edit Gejala: {{ $editingGejala->name }}
            @else
                Tambah Gejala Baru
            @endisset
        </h2>

        @if ($errors->any())
            <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-4" role="alert">
                <p class="font-bold">Terjadi Kesalahan:</p>
                <ul>
                    @foreach ($errors->all() as $error)
                        <li>{{ $error }}</li>
                    @endforeach
                </ul>
            </div>
        @endif

        <form method="POST" action="{{ isset($editingGejala) ? route('admin.gejala.update', $editingGejala->id) : route('admin.gejala.store') }}" class="space-y-4">
            @csrf
            @isset($editingGejala)
                @method('PUT')
            @endisset

            <div>
                <label for="name" class="block text-sm font-medium text-gray-700 mb-1">Nama Gejala</label>
                <input type="text" name="name" id="name" placeholder="Masukkan nama gejala" required
                       value="{{ old('name', $editingGejala->name ?? '') }}"
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('name') border-red-500 @enderror">
                @error('name')
                    <p class="text-red-500 text-xs mt-1">{{ $message }}</p>
                @enderror
            </div>

            <div>
                <label for="weight" class="block text-sm font-medium text-gray-700 mb-1">Bobot</label>
                <input type="number" name="weight" id="weight" step="0.01" placeholder="Contoh: 0.5" required
                       value="{{ old('weight', $editingGejala->weight ?? '') }}"
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('weight') border-red-500 @enderror">
                @error('weight')
                    <p class="text-red-500 text-xs mt-1">{{ $message }}</p>
                @enderror
            </div>

            <div class="flex items-center space-x-4 pt-2">
                <button type="submit"
                        class="inline-flex items-center px-4 py-2 bg-indigo-600 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-indigo-700 active:bg-indigo-800 focus:outline-none focus:border-indigo-900 focus:ring focus:ring-indigo-300 disabled:opacity-25 transition">
                    <i class="{{ isset($editingGejala) ? 'ri-save-line' : 'ri-add-line' }} mr-2 -ml-1"></i>
                    {{ isset($editingGejala) ? 'Simpan Perubahan' : 'Tambah Gejala' }}
                </button>

                @isset($editingGejala)
                    <a href="{{ route('admin.gejala.index') }}"
                       class="inline-flex items-center px-4 py-2 bg-white border border-gray-300 rounded-md font-semibold text-xs text-gray-700 uppercase tracking-widest shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-25 transition">
                        Batal
                    </a>
                @endisset
            </div>
        </form>
    </div>

    <div class="bg-white rounded-xl shadow overflow-hidden border border-gray-200">
        <div class="px-6 py-4 border-b border-gray-200">
           <h2 class="text-xl font-semibold text-gray-800">Daftar Gejala Tersimpan</h2>
        </div>

        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nama Gejala</th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Bobot</th>
                        <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
                        <th scope="col" class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase tracking-wider">Aksi</th>
                    </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                    @forelse ($gejalaList as $gejala)
                        <tr class="hover:bg-gray-50 transition-colors duration-150">
                            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">{{ $gejala->name }}</td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">{{ number_format($gejala->weight, 2, ',', '.') }}</td>
                            <td class="px-6 py-4 whitespace-nowrap text-center text-sm">
                                @if ($gejala->active)
                                    <span class="px-2.5 py-0.5 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                        Aktif
                                    </span>
                                @else
                                    <span class="px-2.5 py-0.5 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">
                                        Nonaktif
                                    </span>
                                @endif
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-center text-sm font-medium space-x-1">
                                <a href="{{ route('admin.gejala.edit', $gejala->id) }}" title="Edit"
                                   class="inline-flex items-center justify-center w-8 h-8 text-indigo-600 hover:text-indigo-900 hover:bg-indigo-100 rounded-full transition">
                                    <i class="ri-pencil-line text-lg"></i>
                                </a>

                                <form action="{{ route('admin.gejala.toggleStatus', $gejala->id) }}" method="POST" class="inline-block" onsubmit="return confirm('Apakah Anda yakin ingin {{ $gejala->active ? 'menonaktifkan' : 'mengaktifkan' }} gejala ini?');">
                                    @csrf
                                    @method('PUT')
                                    <button type="submit" title="{{ $gejala->active ? 'Nonaktifkan' : 'Aktifkan' }}"
                                            class="inline-flex items-center justify-center w-8 h-8 {{ $gejala->active ? 'text-yellow-600 hover:text-yellow-900 hover:bg-yellow-100' : 'text-green-600 hover:text-green-900 hover:bg-green-100' }} rounded-full transition">
                                        <i class="{{ $gejala->active ? 'ri-toggle-fill' : 'ri-toggle-line' }} text-xl"></i>
                                    </button>
                                </form>

                                <form action="{{ route('admin.gejala.destroy', $gejala->id) }}" method="POST" class="inline-block" onsubmit="return confirm('PERHATIAN: Menghapus gejala ini mungkin mempengaruhi data diagnosis yang ada. Apakah Anda yakin ingin melanjutkan?');">
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
                            <td colspan="4" class="px-6 py-10 text-center text-sm text-gray-500">
                                Belum ada data gejala yang tersimpan. Silakan tambahkan gejala baru menggunakan form di atas.
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
@endpush
