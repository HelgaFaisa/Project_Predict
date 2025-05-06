@extends('layouts.app') {{-- Atau layout admin Anda: layouts.admin --}}

@section('title', 'Manajemen Profil')
@section('page-title', 'Manajemen Profil Pengguna')

@section('content')
<div class="bg-white rounded-lg shadow-md p-6">
    <div class="flex justify-between items-center mb-4">
        <h2 class="text-xl font-semibold text-gray-700">Daftar Profil</h2>
        {{-- Tombol Tambah Baru --}}
        <a href="{{ route('admin.profile.create') }}" class="px-4 py-2 bg-sidebar-purple text-white rounded-lg text-sm font-medium hover:bg-opacity-90 transition-colors flex items-center gap-1">
            <i class="ri-add-line"></i> Tambah Profil
        </a>
    </div>

    {{-- Menampilkan Pesan Sukses/Error --}}
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

    {{-- Tabel Daftar Profil --}}
    <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
            <thead class="bg-gray-50">
                <tr>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nama</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Email</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Role</th>
                    <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Spesialisasi / STR</th> {{-- Contoh Kolom Tambahan --}}
                    <th scope="col" class="relative px-6 py-3">
                        <span class="sr-only">Aksi</span>
                    </th>
                </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
                @forelse ($profiles as $profile)
                    <tr>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="flex items-center">
                                <div class="flex-shrink-0 h-10 w-10">
                                    {{-- Tampilkan Avatar --}}
                                    <img class="h-10 w-10 rounded-full object-cover"
                                         src="{{ $profile->avatar_url ?? 'https://ui-avatars.com/api/?name=' . urlencode($profile->name ?? 'N/A') . '&background=EBF4FF&color=6D5BD0&size=40' }}"
                                         alt="Avatar {{ $profile->name }}">
                                </div>
                                <div class="ml-4">
                                    <div class="text-sm font-medium text-gray-900">{{ $profile->name }}</div>
                                </div>
                            </div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <div class="text-sm text-gray-900">{{ $profile->email }}</div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full
                                {{ $profile->role === 'admin' ? 'bg-red-100 text-red-800' : ($profile->role === 'doctor' ? 'bg-blue-100 text-blue-800' : 'bg-green-100 text-green-800') }}">
                                {{ ucfirst($profile->role) }} {{-- Tampilkan Role --}}
                            </span>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                            {{-- Tampilkan data tambahan jika ada --}}
                            {{ optional($profile->specialization)->name ?? $profile->str_number ?? '-' }}
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium space-x-2">
                            {{-- Tombol Edit --}}
                            <a href="{{ route('admin.profile.edit', $profile->id) }}" class="text-indigo-600 hover:text-indigo-900" title="Edit">
                                <i class="ri-pencil-line text-lg"></i>
                            </a>
                            {{-- Tombol Delete (Menggunakan Form) --}}
                            <form action="{{ route('admin.profile.destroy', $profile->id) }}" method="POST" class="inline-block" onsubmit="return confirm('Apakah Anda yakin ingin menghapus profil ini?');">
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
                        <td colspan="5" class="px-6 py-4 whitespace-nowrap text-center text-sm text-gray-500">
                            Tidak ada data profil ditemukan.
                        </td>
                    </tr>
                @endforelse
            </tbody>
        </table>
    </div>

    {{-- Link Paginasi --}}
    <div class="mt-4">
        {{ $profiles->links() }} {{-- Pastikan Tailwind Paginator sudah di-publish/konfigurasi --}}
    </div>

</div>
@endsection

@push('scripts')
<script>
    // JS Khusus jika diperlukan
</script>
@endpush