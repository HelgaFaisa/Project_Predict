@extends('layouts.app') {{-- Sesuaikan dengan layout admin Anda --}}

@section('title', 'Edit Profil Saya')
@section('page-title', 'Edit Informasi Profil')

@section('content')
<div class="bg-white rounded-lg shadow-md p-6 mx-auto max-w-2xl">
    <h2 class="text-xl font-semibold text-gray-700 mb-6">Edit Informasi Pribadi</h2>

    {{-- ... (Pesan error sesi dan validasi umum seperti sebelumnya) ... --}}
    @if (session('error'))
        <div class="mb-4 p-3 bg-red-100 text-red-700 border border-red-200 rounded-md text-sm">
            {{ session('error') }}
        </div>
    @endif
    @if ($errors->any() && !session('error'))
        <div class="mb-4 p-3 bg-red-100 text-red-700 border border-red-200 rounded-md text-sm">
            <p class="font-medium">Terdapat beberapa kesalahan pada input Anda:</p>
            <ul class="list-disc pl-5 mt-1">
                @foreach ($errors->all() as $error)
                    <li>{{ $error }}</li>
                @endforeach
            </ul>
        </div>
    @endif

    <form action="{{ route('admin.profile.update') }}" method="POST" enctype="multipart/form-data">
        @csrf
        @method('PUT')

        {{-- Nama Lengkap --}}
        <div class="mb-4">
            <label for="name" class="block text-sm font-medium text-gray-700 mb-1">Nama Lengkap <span class="text-red-500">*</span></label>
            <input type="text" name="name" id="name" value="{{ old('name', $user->name) }}" required
                   class="w-full px-3 py-2 border {{ $errors->has('name') ? 'border-red-500' : 'border-gray-300' }} rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
            @error('name') <p class="text-xs text-red-500 mt-1">{{ $message }}</p> @enderror
        </div>

        {{-- Alamat Email --}}
        <div class="mb-4">
            <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Alamat Email <span class="text-red-500">*</span></label>
            <input type="email" name="email" id="email" value="{{ old('email', $user->email) }}" required
                   class="w-full px-3 py-2 border {{ $errors->has('email') ? 'border-red-500' : 'border-gray-300' }} rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm">
            @error('email') <p class="text-xs text-red-500 mt-1">{{ $message }}</p> @enderror
        </div>

        {{-- Nomor Telepon (Opsional) --}}
        <div class="mb-4">
            <label for="phone_number" class="block text-sm font-medium text-gray-700 mb-1">Nomor Telepon</label>
            <input type="text" name="phone_number" id="phone_number" value="{{ old('phone_number', $user->phone_number ?? '') }}"
                   class="w-full px-3 py-2 border {{ $errors->has('phone_number') ? 'border-red-500' : 'border-gray-300' }} rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                   placeholder="Contoh: 08123456789">
            @error('phone_number') <p class="text-xs text-red-500 mt-1">{{ $message }}</p> @enderror
        </div>

        <hr class="my-6">

        {{-- Upload File Foto Profil --}}
        <div class="mb-4">
            <label for="avatar_file" class="block text-sm font-medium text-gray-700 mb-1">Foto Profil</label>
            <div class="mt-2 flex items-center">
                <img id="avatar_file_preview"
                     src="{{ $user->avatar_url }}" {{-- Accessor akan handle default jika null --}}
                     alt="Foto Profil Saat Ini"
                     class="h-20 w-20 rounded-full object-cover">
                <input type="file" name="avatar_file" id="avatar_file" accept="image/jpeg,image/png,image/webp,image/jpg"
                       class="ml-5 block w-full text-sm text-gray-900 border border-gray-300 rounded-lg cursor-pointer bg-gray-50 focus:outline-none
                              file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0
                              file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700
                              hover:file:bg-indigo-100 {{ $errors->has('avatar_file') ? 'border-red-500' : '' }}">
            </div>
            @error('avatar_file') <p class="text-xs text-red-500 mt-1">{{ $message }}</p> @enderror
            <p class="text-xs text-gray-500 mt-1">Max. 2MB. Format: JPG, JPEG, PNG, WEBP. Kosongkan jika tidak ingin mengubah.</p>
            {{-- Anda bisa menambahkan opsi untuk menghapus avatar jika diinginkan --}}
            {{-- <div class="mt-2">
                <label for="remove_avatar" class="inline-flex items-center">
                    <input type="checkbox" name="remove_avatar" id="remove_avatar" value="1" class="rounded border-gray-300 text-indigo-600 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50">
                    <span class="ml-2 text-sm text-gray-600">Hapus foto profil saat ini</span>
                </label>
            </div> --}}
        </div>


        <hr class="my-6">

        <h3 class="text-md font-semibold text-gray-700 mb-3">Informasi Tambahan (Opsional)</h3>

        {{-- Spesialisasi (Opsional) --}}
        <div class="mb-4">
            <label for="specialization" class="block text-sm font-medium text-gray-700 mb-1">Spesialisasi</label>
            <input type="text" name="specialization" id="specialization" value="{{ old('specialization', $user->specialization ?? '') }}"
                   class="w-full px-3 py-2 border {{ $errors->has('specialization') ? 'border-red-500' : 'border-gray-300' }} rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                   placeholder="Contoh: Kardiologi, Dokter Umum">
            @error('specialization') <p class="text-xs text-red-500 mt-1">{{ $message }}</p> @enderror
        </div>

        {{-- Nomor STR (Opsional) --}}
        <div class="mb-6">
            <label for="str_number" class="block text-sm font-medium text-gray-700 mb-1">Nomor STR</label>
            <input type="text" name="str_number" id="str_number" value="{{ old('str_number', $user->str_number ?? '') }}"
                   class="w-full px-3 py-2 border {{ $errors->has('str_number') ? 'border-red-500' : 'border-gray-300' }} rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                   placeholder="Masukkan nomor STR jika ada">
            @error('str_number') <p class="text-xs text-red-500 mt-1">{{ $message }}</p> @enderror
        </div>

        {{-- Tombol Aksi --}}
        <div class="mt-8 flex items-center justify-end space-x-3">
            <a href="{{ route('admin.profile.index') }}" class="px-4 py-2 border border-gray-300 rounded-lg text-sm font-medium text-gray-700 hover:bg-gray-50 transition-colors">
                Batal
            </a>
            <button type="submit" class="px-4 py-2 bg-indigo-600 text-white rounded-lg text-sm font-medium hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors flex items-center justify-center gap-1">
                <i class="ri-save-line"></i> Simpan Perubahan
            </button>
        </div>
    </form>
</div>
@endsection

@push('scripts')
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const avatarFileInput = document.getElementById('avatar_file');
        const avatarPreview = document.getElementById('avatar_file_preview');
        const originalAvatarSrc = avatarPreview.src; // Simpan src awal (avatar saat ini atau default)

        if (avatarFileInput && avatarPreview) {
            avatarFileInput.addEventListener('change', function(event) {
                const file = event.target.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        avatarPreview.src = e.target.result;
                    }
                    reader.readAsDataURL(file);
                } else {
                    // Jika tidak ada file dipilih (misal, pengguna klik cancel), kembalikan ke gambar asli
                    avatarPreview.src = originalAvatarSrc;
                }
            });
        }
    });
</script>
@endpush