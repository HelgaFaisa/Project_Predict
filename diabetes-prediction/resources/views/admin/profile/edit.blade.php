@extends('layouts.app') {{-- Atau layout admin Anda: layouts.admin --}}

@section('title', 'Edit Profil')
@section('page-title', 'Edit Profil: ' . $profile->name)

@section('content')
<div class="bg-white rounded-lg shadow-md p-6 md:p-8">
    <h2 class="text-2xl font-semibold text-gray-800 mb-6">Form Edit Profil</h2>

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

    <form action="{{ route('admin.profile.update', $profile->id) }}" method="POST" enctype="multipart/form-data"> {{-- Tambah enctype jika ada upload file --}}
        @csrf {{-- Token CSRF --}}
        @method('PUT') {{-- Method Spoofing untuk Update --}}

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            {{-- Nama Lengkap --}}
            <div class="md:col-span-1">
                <label for="name" class="block text-sm font-medium text-gray-700 mb-1">Nama Lengkap <span class="text-red-500">*</span></label>
                <input type="text" name="name" id="name" value="{{ old('name', $profile->name) }}" required
                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
            </div>

            {{-- Email --}}
            <div class="md:col-span-1">
                <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Email <span class="text-red-500">*</span></label>
                <input type="email" name="email" id="email" value="{{ old('email', $profile->email) }}" required
                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
            </div>

             {{-- Role --}}
            <div class="md:col-span-1">
                <label for="role" class="block text-sm font-medium text-gray-700 mb-1">Role <span class="text-red-500">*</span></label>
                <select name="role" id="role" required
                        class="w-full px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
                    <option value="doctor" {{ old('role', $profile->role) == 'doctor' ? 'selected' : '' }}>Dokter</option>
                    <option value="admin" {{ old('role', $profile->role) == 'admin' ? 'selected' : '' }}>Admin</option>
                    <option value="patient" {{ old('role', $profile->role) == 'patient' ? 'selected' : '' }}>Pasien</option>
                    {{-- Tambah role lain jika ada --}}
                </select>
            </div>

            {{-- Nomor STR (Contoh field dokter) --}}
             <div class="md:col-span-1">
                <label for="str_number" class="block text-sm font-medium text-gray-700 mb-1">Nomor STR</label>
                <input type="text" name="str_number" id="str_number" value="{{ old('str_number', $profile->str_number ?? '') }}"
                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
            </div>

             {{-- Nomor Telepon --}}
            <div class="md:col-span-1">
                <label for="phone_number" class="block text-sm font-medium text-gray-700 mb-1">Nomor Telepon</label>
                <input type="tel" name="phone_number" id="phone_number" value="{{ old('phone_number', $profile->phone_number ?? '') }}"
                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
            </div>

            {{-- Spesialisasi (Contoh dropdown jika ada relasi) --}}
            {{--
            <div class="md:col-span-1">
                <label for="specialization_id" class="block text-sm font-medium text-gray-700 mb-1">Spesialisasi</label>
                <select name="specialization_id" id="specialization_id"
                        class="w-full px-3 py-2 border border-gray-300 bg-white rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
                    <option value="">-- Pilih Spesialisasi --</option>
                    @foreach($specializations as $spec)
                        <option value="{{ $spec->id }}" {{ old('specialization_id', optional($profile->specialization)->id) == $spec->id ? 'selected' : '' }}>
                            {{ $spec->name }}
                        </option>
                    @endforeach
                </select>
            </div>
            --}}

             {{-- Ganti Password (Opsional) --}}
            <div class="md:col-span-2 pt-4 border-t border-gray-200">
                 <p class="text-sm text-gray-600 mb-2">Kosongkan jika tidak ingin mengganti password.</p>
            </div>
            <div class="md:col-span-1">
                <label for="password" class="block text-sm font-medium text-gray-700 mb-1">Password Baru</label>
                <input type="password" name="password" id="password"
                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
            </div>
            <div class="md:col-span-1">
                <label for="password_confirmation" class="block text-sm font-medium text-gray-700 mb-1">Konfirmasi Password Baru</label>
                <input type="password" name="password_confirmation" id="password_confirmation"
                       class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
            </div>

            {{-- Tambahkan field lain sesuai kebutuhan (Bio, Tempat Praktik, Jadwal, Avatar Upload) --}}

        </div>

        {{-- Tombol Aksi --}}
        <div class="mt-8 flex justify-end space-x-3">
            <a href="{{ route('admin.profile.index') }}"
               class="px-4 py-2 bg-gray-200 text-gray-700 rounded-md text-sm font-medium hover:bg-gray-300 transition-colors">
               Batal
            </a>
            <button type="submit"
                    class="px-4 py-2 bg-sidebar-purple text-white rounded-md text-sm font-medium hover:bg-opacity-90 transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                Simpan Perubahan
            </button>
        </div>
    </form>
</div>
@endsection

@push('scripts')
{{-- Script JS jika diperlukan (misal untuk preview avatar) --}}
@endpush