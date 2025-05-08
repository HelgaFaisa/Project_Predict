@extends('layouts.app') {{-- Sesuaikan dengan layout utama Anda --}}

@section('title', 'Profil Saya')
@section('page-title', 'Profil Pengguna')

@section('content')
<div class="space-y-8">
    {{-- Card Informasi Profil --}}
    <div class="bg-white rounded-xl shadow p-6 md:p-8 border border-gray-200">
        <h2 class="text-xl font-semibold text-gray-800 mb-6 border-b pb-4">Informasi Profil</h2>

        @include('partials.alerts') {{-- Untuk menampilkan pesan sukses/error --}}

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            {{-- Kolom Kiri: Avatar & Nama --}}
            <div class="md:col-span-1 flex flex-col items-center text-center">
                <div class="w-24 h-24 rounded-full bg-indigo-100 flex items-center justify-center overflow-hidden border-2 border-indigo-300 mb-4">
                    <span class="font-bold text-3xl text-sidebar-purple">{{ substr($user->name ?? 'AD', 0, 2) }}</span>
                </div>
                <h3 class="text-lg font-semibold text-gray-900">{{ $user->name }}</h3>
                <p class="text-sm text-gray-500">{{ $user->email }}</p>
                <p class="text-xs text-gray-400 mt-2">Bergabung pada: {{ $user->created_at ? $user->created_at->translatedFormat('d F Y') : '-' }}</p>
                {{-- Tambahkan info lain jika ada (misal: role) --}}
            </div>

            {{-- Kolom Kanan: Ubah Password --}}
            <div class="md:col-span-2">
                <h3 class="text-lg font-medium text-gray-900 mb-4">Ubah Password</h3>
                <form action="{{ route('admin.profile.password.update') }}" method="POST" class="space-y-4">
                    @csrf
                    @method('PUT')

                    <div>
                        <label for="current_password" class="block text-sm font-medium text-gray-700 mb-1">Password Saat Ini <span class="text-red-500">*</span></label>
                        <input type="password" name="current_password" id="current_password" required
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('current_password', 'updatePassword') border-red-500 @enderror">
                        @error('current_password', 'updatePassword') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
                    </div>

                    <div>
                        <label for="password" class="block text-sm font-medium text-gray-700 mb-1">Password Baru <span class="text-red-500">*</span></label>
                        <input type="password" name="password" id="password" required
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('password', 'updatePassword') border-red-500 @enderror">
                        @error('password', 'updatePassword') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
                    </div>

                    <div>
                        <label for="password_confirmation" class="block text-sm font-medium text-gray-700 mb-1">Konfirmasi Password Baru <span class="text-red-500">*</span></label>
                        <input type="password" name="password_confirmation" id="password_confirmation" required
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500">
                    </div>

                    <div class="pt-2">
                        <button type="submit" class="inline-flex items-center px-4 py-2 bg-indigo-600 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                            <i class="ri-key-2-line mr-2"></i> Ubah Password
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    {{-- Anda bisa menambahkan card lain di sini jika perlu, misal untuk edit info profil dasar --}}

</div>
@endsection
