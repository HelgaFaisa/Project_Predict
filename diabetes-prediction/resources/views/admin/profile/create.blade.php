@extends('layouts.app') {{-- Atau layout admin Anda: layouts.admin --}}

@section('title', 'Tambah Profil Baru')
@section('page-title', 'Tambah Profil Pengguna Baru')

@section('content')
<div class="bg-white rounded-lg shadow-md p-6 md:p-8">
    <h2 class="text-2xl font-semibold text-gray-800 mb-6">Form Tambah Profil</h2>

    {{-- Menampilkan Error Validasi --}}
    @if ($errors->any())
        <div class="mb-4 p-4 bg-red-100 text-red-700 border border-red-200 rounded-md">
             <strong class="font-bold">Oops! Ada kesalahan:</strong>
            <ul class="mt-1 list-disc list-inside text-sm">
                @foreach ($errors->all() as $error)
                    <li>{{ $error }}</li>
                @endforeach
            </ul>
        </div>
    @endif

    <form action="{{ route('admin.profile.store') }}" method="POST" enctype="multipart/form-data">
        @csrf {{-- Token CSRF --}}

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            {{-- Nama Lengkap --}}
            <div class="md:col-span-1">
                <label for="name" class="block text-sm font-medium text-gray-700 mb-1">Nama Lengkap <span class="text-red-500">*</span></label>
                <input type="text" name="name" id="name" value="{{ old('name') }}" required
                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
            </div>

            {{-- Email --}}
            <div class="md:col-span-1">
                <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Email <span class="text-red-500">*</span></label>
                <input type="email" name="email" id="email" value="{{ old('email') }}" required
                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
            </div>

             {{-- Role --}}
            <div class="md:col-span-1">
                <label for="role" class="block text-sm font-medium text-gray-700 mb-1">Role <span class="text-red-500">*</span></label>
                <select name="role" id="role" required
                        class="w-full px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
                    <option value="">-- Pilih Role --</option>
                    <option value="doctor" {{ old('role') == 'doctor' ? 'selected' : '' }}>Dokter</option>
                    <option value="admin" {{ old('role') == 'admin' ? 'selected' : '' }}>Admin</option>
                    <option value="patient" {{ old('role') == 'patient' ? 'selected' : '' }}>Pasien</option>
                    {{-- Tambah role lain jika ada --}}
                </select>
            </div>

            {{-- Nomor STR (Contoh field dokter) --}}
             <div class="md:col-span-1">
                <label for="str_number" class="block text-sm font-medium text-gray-700 mb-1">Nomor STR</label>
                <input type="text" name="str_number" id="str_number" value="{{ old('str_number') }}"
                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
            </div>

             {{-- Nomor Telepon --}}
            <div class="md:col-span-1">
                <label for="phone_number" class="block text-sm font-medium text-gray-700 mb-1">Nomor Telepon</label>
                <input type="tel" name="phone_number" id="phone_number" value="{{ old('phone_number') }}"
                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
            </div>

            {{-- Password --}}
             <div class="md:col-span-1">
                <label for="password" class="block text-sm font-medium text-gray-700 mb-1">Password <span class="text-red-500">*</span></label>
                <input type="password" name="password" id="password" required
                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
            </div>
            <div class="md:col-span-1">
                <label for="password_confirmation" class="block text-sm font-medium text-gray-700 mb-1">Konfirmasi Password <span class="text-red-500">*</span></label>
                <input type="password" name="password_confirmation" id="password_confirmation" required
                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
            </div>

            {{-- Tambahkan field lain jika perlu (Spesialisasi, Bio, dll.) --}}

        </div>

        {{-- Tombol Aksi --}}
        <div class="mt-8 flex justify-end space-x-3">
            <a href="{{ route('admin.profile.index') }}"
               class="px-4 py-2 bg-gray-200 text-gray-700 rounded-md text-sm font-medium hover:bg-gray-300 transition-colors">
               Batal
            </a>
            <button type="submit"
                    class="px-4 py-2 bg-sidebar-purple text-white rounded-md text-sm font-medium hover:bg-opacity-90 transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                Simpan Profil Baru
            </button>
        </div>
    </form>
</div>
@endsection