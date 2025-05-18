@extends('layouts.app') {{-- Atau layout admin Anda, misal: layouts.admin --}}

@section('title', 'Profil Saya')
@section('page-title', 'Profil Pengguna')

@section('content')
<div class="grid grid-cols-1 md:grid-cols-3 gap-6">
    {{-- Kolom Informasi Profil Pengguna --}}
    <div class="md:col-span-1">
        <div class="bg-white rounded-lg shadow-md p-6">
            <h2 class="text-xl font-semibold text-gray-700 mb-4">Informasi Akun</h2>
            @if(isset($user))
                <div class="text-center mb-6">
                    <img class="h-24 w-24 rounded-full object-cover mx-auto mb-3"
                         src="{{ $user->avatar_url ?? 'https://ui-avatars.com/api/?name=' . urlencode($user->name ?? 'Pengguna') . '&background=EBF4FF&color=6D5BD0&size=96' }}"
                         alt="Avatar {{ $user->name ?? 'Pengguna' }}">
                    <h3 class="text-lg font-medium text-gray-800">{{ $user->name ?? 'Nama Tidak Ada' }}</h3>
                    <p class="text-sm text-gray-500">{{ $user->email ?? 'Email Tidak Ada' }}</p>
                    @if($user->role) {{-- Pastikan role ada sebelum ditampilkan --}}
                    <span class="mt-2 px-2 inline-flex text-xs leading-5 font-semibold rounded-full
                        {{ ($user->role ?? '') === 'admin' ? 'bg-red-100 text-red-800' : (($user->role ?? '') === 'doctor' ? 'bg-blue-100 text-blue-800' : 'bg-green-100 text-green-800') }}">
                        {{ ucfirst($user->role ?? 'N/A') }}
                    </span>
                    @endif
                </div>

                <div class="space-y-3 text-sm mb-6">
                    <div>
                        <span class="font-medium text-gray-600">Nama Lengkap:</span>
                        <span class="text-gray-800 ml-2">{{ $user->name ?? '-' }}</span>
                    </div>
                    <div>
                        <span class="font-medium text-gray-600">Email:</span>
                        <span class="text-gray-800 ml-2">{{ $user->email ?? '-' }}</span>
                    </div>
                    @if(isset($user->phone_number) && !empty($user->phone_number)) {{-- Tampilkan jika ada dan tidak kosong --}}
                    <div>
                        <span class="font-medium text-gray-600">Telepon:</span>
                        <span class="text-gray-800 ml-2">{{ $user->phone_number }}</span>
                    </div>
                    @endif
                    @if(isset($user->specialization) && !empty($user->specialization)) {{-- Jika specialization adalah string langsung --}}
                    <div>
                        <span class="font-medium text-gray-600">Spesialisasi:</span>
                        {{-- Jika 'specialization' adalah string langsung di model User --}}
                        <span class="text-gray-800 ml-2">{{ $user->specialization }}</span>
                        {{-- Jika 'specialization' adalah relasi, gunakan: --}}
                        {{-- <span class="text-gray-800 ml-2">{{ optional($user->specialization)->name ?? '-' }}</span> --}}
                    </div>
                    @endif
                    @if(isset($user->str_number) && !empty($user->str_number))
                    <div>
                        <span class="font-medium text-gray-600">No. STR:</span>
                        <span class="text-gray-800 ml-2">{{ $user->str_number }}</span>
                    </div>
                    @endif
                    <div>
                        <span class="font-medium text-gray-600">Terdaftar Sejak:</span>
                        <span class="text-gray-800 ml-2">{{ $user->created_at ? $user->created_at->isoFormat('D MMMM YYYY') : '-' }}</span>
                        {{-- Menggunakan isoFormat('LL') juga bagus untuk format tanggal lokal: $user->created_at->isoFormat('LL') --}}
                    </div>
                </div>
                {{-- Tombol untuk edit profil --}}
                <div class="mt-6">
                    <a href="{{ route('admin.profile.edit') }}" class="w-full block text-center px-4 py-2 bg-blue-600 text-white rounded-lg text-sm font-medium hover:bg-blue-700 transition-colors flex items-center justify-center gap-1">
                        <i class="ri-pencil-line"></i> Edit Informasi Profil
                    </a>
                </div>
            @else
                <p class="text-gray-600">Informasi pengguna tidak tersedia.</p>
            @endif
        </div>
    </div>

    {{-- Kolom untuk Update Password --}}
    <div class="md:col-span-2">
        <div class="bg-white rounded-lg shadow-md p-6">
            <h2 class="text-xl font-semibold text-gray-700 mb-6">Ubah Password</h2>

            {{-- Menampilkan Pesan Sukses/Error dari update password --}}
            @if (session('success'))
                <div class="mb-4 p-3 bg-green-100 text-green-700 border border-green-200 rounded-md text-sm">
                    {{ session('success') }}
                </div>
            @endif
            @if (session('error'))
                <div class="mb-4 p-3 bg-red-100 text-red-700 border border-red-200 rounded-md text-sm">
                    {{ session('error') }}
                </div>
            @endif
            {{-- Menampilkan error validasi (lebih spesifik untuk form ini) --}}
            @if ($errors->has('current_password') || $errors->has('password') || $errors->has('password_confirmation'))
                <div class="mb-4 p-3 bg-red-100 text-red-700 border border-red-200 rounded-md text-sm">
                    <ul class="list-disc pl-5">
                        @foreach ($errors->get('current_password') as $error) <li>{{ $error }}</li> @endforeach
                        @foreach ($errors->get('password') as $error) <li>{{ $error }}</li> @endforeach
                        @foreach ($errors->get('password_confirmation') as $error) <li>{{ $error }}</li> @endforeach
                    </ul>
                </div>
            @elseif ($errors->any() && !session('success') && !session('error')) {{-- Error umum lain jika bukan dari form ini dan belum ada pesan sesi --}}
                <div class="mb-4 p-3 bg-red-100 text-red-700 border border-red-200 rounded-md text-sm">
                     <ul class="list-disc pl-5">
                        @foreach ($errors->all() as $error)
                            <li>{{ $error }}</li>
                        @endforeach
                    </ul>
                </div>
            @endif


            <form action="{{ route('admin.profile.password.update') }}" method="POST">
                @csrf
                @method('PUT')

                <div class="mb-4">
                    <label for="current_password" class="block text-sm font-medium text-gray-700 mb-1">Password Saat Ini <span class="text-red-500">*</span></label>
                    <input type="password" name="current_password" id="current_password" required
                           class="w-full px-3 py-2 border {{ $errors->has('current_password') ? 'border-red-500' : 'border-gray-300' }} rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                           placeholder="Masukkan password Anda saat ini">
                </div>

                <div class="mb-4">
                    <label for="password" class="block text-sm font-medium text-gray-700 mb-1">Password Baru <span class="text-red-500">*</span></label>
                    <input type="password" name="password" id="password" required
                           class="w-full px-3 py-2 border {{ $errors->has('password') ? 'border-red-500' : 'border-gray-300' }} rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                           placeholder="Minimal 8 karakter">
                    @if ($errors->has('password'))
                        {{-- Error spesifik untuk password sudah ditampilkan di atas dalam list --}}
                    @else
                        <p class="text-xs text-gray-500 mt-1">Minimal 8 karakter, huruf besar-kecil, angka, dan simbol.</p>
                    @endif
                </div>

                <div class="mb-6">
                    <label for="password_confirmation" class="block text-sm font-medium text-gray-700 mb-1">Konfirmasi Password Baru <span class="text-red-500">*</span></label>
                    <input type="password" name="password_confirmation" id="password_confirmation" required
                           class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm"
                           placeholder="Ulangi password baru Anda">
                </div>

                <div>
                    <button type="submit" class="w-full px-4 py-2 bg-indigo-600 text-white rounded-lg text-sm font-medium hover:bg-indigo-700 transition-colors flex items-center justify-center gap-1">
                        <i class="ri-save-line"></i> Simpan Perubahan Password
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
@endsection

@push('styles')
{{-- Jika ada CSS tambahan khusus untuk halaman ini --}}
{{-- Contoh: <link rel="stylesheet" href="{{ asset('css/profile-page.css') }}"> --}}
@endpush

@push('scripts')
<script>
    // JS Khusus jika diperlukan, misalnya untuk menampilkan/menyembunyikan password
    // atau interaksi UI lainnya.
</script>
@endpush