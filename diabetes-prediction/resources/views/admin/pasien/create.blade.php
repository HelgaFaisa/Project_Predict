@extends('layouts.app') {{-- Sesuaikan dengan layout utama Anda --}}

@section('title', 'Tambah Pasien Baru')
@section('page-title', 'Formulir Tambah Pasien')

@section('content')
<div class="bg-white rounded-xl shadow p-6 md:p-8 border border-gray-200">
    <h2 class="text-xl font-semibold text-gray-800 mb-6">Masukkan Data Pasien Baru</h2>

    {{-- Menampilkan error validasi --}}
    @if ($errors->any())
        <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-md" role="alert">
            <p class="font-bold">Harap perbaiki input berikut:</p>
            <ul class="mt-2 list-disc list-inside text-sm">
                @foreach ($errors->all() as $error)
                    <li>{{ $error }}</li>
                @endforeach
            </ul>
        </div>
    @endif

    <form action="{{ route('admin.pasien.store') }}" method="POST">
        @csrf
        <div class="grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-4">
            {{-- Nama Lengkap --}}
            <div>
                <label for="name" class="block text-sm font-medium text-gray-700 mb-1">Nama Lengkap <span class="text-red-500">*</span></label>
                <input type="text" name="name" id="name" value="{{ old('name') }}" required
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('name') border-red-500 @enderror">
                @error('name') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
            </div>

            {{-- NIK (Nomor Induk Kependudukan) - BARU --}}
            <div>
                <label for="nik" class="block text-sm font-medium text-gray-700 mb-1">NIK <span class="text-red-500">*</span></label>
                <input type="text" inputmode="numeric" pattern="[0-9]{16}" name="nik" id="nik" value="{{ old('nik') }}" required maxlength="16"
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('nik') border-red-500 @enderror"
                       placeholder="16 digit NIK KTP">
                @error('nik') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
                <p class="text-xs text-gray-500 mt-1">Masukkan 16 digit Nomor Induk Kependudukan.</p>
            </div>

            {{-- Tanggal Lahir --}}
            <div>
                <label for="date_of_birth" class="block text-sm font-medium text-gray-700 mb-1">Tanggal Lahir</label>
                <input type="date" name="date_of_birth" id="date_of_birth" value="{{ old('date_of_birth') }}"
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('date_of_birth') border-red-500 @enderror">
                @error('date_of_birth') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
            </div>

            {{-- Jenis Kelamin --}}
            <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Jenis Kelamin</label>
                <div class="flex items-center space-x-4 mt-2">
                    <label class="inline-flex items-center">
                        <input type="radio" name="gender" value="Laki-laki" class="form-radio text-indigo-600" {{ old('gender') == 'Laki-laki' ? 'checked' : '' }}>
                        <span class="ml-2 text-sm text-gray-700">Laki-laki</span>
                    </label>
                    <label class="inline-flex items-center">
                        <input type="radio" name="gender" value="Perempuan" class="form-radio text-indigo-600" {{ old('gender') == 'Perempuan' ? 'checked' : '' }}>
                        <span class="ml-2 text-sm text-gray-700">Perempuan</span>
                    </label>
                </div>
                @error('gender') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
            </div>

            {{-- Alamat (Textarea) --}}
            <div class="md:col-span-2">
                <label for="address" class="block text-sm font-medium text-gray-700 mb-1">Alamat Lengkap</label>
                <textarea name="address" id="address" rows="3"
                          class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('address') border-red-500 @enderror">{{ old('address') }}</textarea>
                @error('address') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
            </div>

            {{-- Field Email dan Nomor Kontak DIHAPUS --}}

        </div>

        <div class="flex items-center space-x-4 pt-6 border-t border-gray-200 mt-6">
            <button type="submit"
                    class="inline-flex items-center px-6 py-2 bg-indigo-600 border border-transparent rounded-md font-semibold text-sm text-white uppercase tracking-widest hover:bg-indigo-700 active:bg-indigo-800 focus:outline-none focus:border-indigo-900 focus:ring focus:ring-indigo-300 disabled:opacity-25 transition">
                <i class="ri-save-line mr-2 -ml-1"></i>
                Simpan Pasien
            </button>
            <a href="{{ route('admin.pasien.index') }}"
               class="inline-flex items-center px-4 py-2 bg-white border border-gray-300 rounded-md font-semibold text-xs text-gray-700 uppercase tracking-widest shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-25 transition">
                Batal
            </a>
        </div>
    </form>
</div>
@endsection
