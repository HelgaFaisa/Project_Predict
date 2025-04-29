{{-- Menggunakan layout utama --}}
@extends('layouts.app')

{{-- Mengatur judul spesifik untuk halaman ini --}}
@section('title', 'Dashboard Utama')

{{-- Mengatur judul yang tampil di Topbar untuk halaman ini --}}
@section('page-title', 'Dashboard')

{{-- Mendefinisikan konten utama halaman ini --}}
@section('content')
<div class="space-y-8">
    {{-- Header Sambutan --}}
    <div>
        {{-- Ganti Nama Dokter dengan data dinamis jika ada --}}
        <h1 class="text-3xl font-bold text-gray-800">Selamat Datang Kembali, Dokter!</h1>
        {{-- Format tanggal sesuai locale Indonesia --}}
        <p class="mt-1 text-gray-600">Berikut ringkasan aktivitas terbaru Anda per {{ \Carbon\Carbon::now()->translatedFormat('l, d F Y') }}.</p>
    </div>

    {{-- Grid Kartu Statistik --}}
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        {{-- Card 1: Pasien Aktif --}}
        <div class="bg-white rounded-xl shadow p-6 hover:shadow-lg transition-shadow border border-gray-200">
            <div class="flex items-center justify-between">
                <span class="text-sm font-semibold text-gray-500 uppercase tracking-wider">Pasien Aktif</span>
                <div class="p-2 rounded-full bg-blue-100 text-blue-600">
                    <i class="ri-group-line text-xl"></i>
                </div>
            </div>
            <div class="mt-3">
                <span class="text-4xl font-bold text-gray-800">75</span> {{-- Ganti dengan data dinamis --}}
                <p class="mt-1 text-xs text-green-600 flex items-center">
                    <i class="ri-arrow-up-line mr-1"></i> 5 baru minggu ini {{-- Ganti dengan data dinamis --}}
                </p>
            </div>
        </div>

        {{-- Card 2: Prediksi Baru --}}
        <div class="bg-white rounded-xl shadow p-6 hover:shadow-lg transition-shadow border border-gray-200">
            <div class="flex items-center justify-between">
                <span class="text-sm font-semibold text-gray-500 uppercase tracking-wider">Prediksi Baru</span>
                <div class="p-2 rounded-full bg-yellow-100 text-yellow-600">
                    <i class="ri-flask-line text-xl"></i>
                </div>
            </div>
            <div class="mt-3">
                <span class="text-4xl font-bold text-gray-800">12</span> {{-- Ganti dengan data dinamis --}}
                <p class="mt-1 text-xs text-gray-500">
                    Memerlukan tinjauan Anda
                </p>
            </div>
        </div>

        {{-- Card 3: Janji Hari Ini --}}
        <div class="bg-white rounded-xl shadow p-6 hover:shadow-lg transition-shadow border border-gray-200">
            <div class="flex items-center justify-between">
                <span class="text-sm font-semibold text-gray-500 uppercase tracking-wider">Janji Hari Ini</span>
                <div class="p-2 rounded-full bg-green-100 text-green-600">
                    <i class="ri-calendar-check-line text-xl"></i>
                </div>
            </div>
            <div class="mt-3">
                <span class="text-4xl font-bold text-gray-800">8</span> {{-- Ganti dengan data dinamis --}}
                <p class="mt-1 text-xs text-gray-500">
                    3 Selesai, 5 Menunggu {{-- Ganti dengan data dinamis --}}
                </p>
            </div>
        </div>

         {{-- Card 4: Pasien Risiko Tinggi --}}
        <div class="bg-white rounded-xl shadow p-6 hover:shadow-lg transition-shadow border border-gray-200">
            <div class="flex items-center justify-between">
                <span class="text-sm font-semibold text-gray-500 uppercase tracking-wider">Risiko Tinggi</span>
                <div class="p-2 rounded-full bg-red-100 text-red-600">
                     <i class="ri-alert-line text-xl"></i>
                </div>
            </div>
            <div class="mt-3">
                <span class="text-4xl font-bold text-gray-800">4</span> {{-- Ganti dengan data dinamis --}}
                <p class="mt-1 text-xs text-gray-500">
                     Perlu perhatian khusus
                </p>
            </div>
        </div>
    </div> {{-- End Grid Cards --}}

     {{-- Placeholder Grafik --}}
    <div>
        <div class="bg-white rounded-xl shadow p-6 border border-gray-200">
            <h2 class="text-xl font-semibold text-gray-800 mb-4">Tren Pasien Baru (Mingguan)</h2>
            <div class="h-64 bg-gradient-to-br from-indigo-50 via-white to-blue-50 flex items-center justify-center rounded-lg">
                <span class="text-gray-400 italic">Area Grafik Akan Ditampilkan di Sini</span>
                {{-- Implementasi chart library (Chart.js, ApexCharts) di sini --}}
            </div>
        </div>
    </div>

    {{-- Daftar Pasien (Ringkasan) --}}
    <div class="bg-white rounded-xl shadow overflow-hidden border border-gray-200">
        {{-- Header Tabel & Link Lihat Semua --}}
        <div class="px-6 py-4 border-b border-gray-200 flex items-center justify-between">
           <h2 class="text-xl font-semibold text-gray-800">Pasien Terbaru</h2>
           {{-- Ganti dengan route yang benar untuk daftar pasien --}}
            <a href="#" class="text-sm font-medium text-indigo-600 hover:text-indigo-800 transition duration-150 ease-in-out">
                Lihat Semua &rarr;
            </a>
        </div>
        {{-- Tabel Pasien Ringkasan --}}
        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nama</th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status Prediksi</th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tanggal Masuk</th>
                        <th scope="col" class="relative px-6 py-3">
                            <span class="sr-only">Aksi</span>
                        </th>
                    </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                    {{-- Contoh Data Pasien - Ganti dengan loop data dinamis --}}
                    <tr class="hover:bg-gray-50 transition-colors duration-150">
                        <td class="px-6 py-4 whitespace-nowrap">
                             <div class="flex items-center">
                                  <div class="flex-shrink-0 h-8 w-8 rounded-full bg-blue-100 flex items-center justify-center text-blue-600 font-medium">BS</div>
                                  <div class="ml-3">
                                      <div class="text-sm font-medium text-gray-900">Budi Santoso</div>
                                  </div>
                             </div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm">
                            <span class="px-2.5 py-0.5 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                Negatif
                            </span>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">28 Apr 2025</td>
                        <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                             {{-- Ganti # dengan route detail pasien --}}
                            <a href="#" title="Lihat Detail" class="text-indigo-600 hover:text-indigo-900 p-1 hover:bg-indigo-100 rounded-full transition">
                                 <i class="ri-eye-line text-lg"></i>
                            </a>
                        </td>
                    </tr>
                    <tr class="hover:bg-gray-50 transition-colors duration-150">
                        <td class="px-6 py-4 whitespace-nowrap">
                             <div class="flex items-center">
                                  <div class="flex-shrink-0 h-8 w-8 rounded-full bg-pink-100 flex items-center justify-center text-pink-600 font-medium">CL</div>
                                  <div class="ml-3">
                                      <div class="text-sm font-medium text-gray-900">Citra Lestari</div>
                                  </div>
                             </div>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm">
                            <span class="px-2.5 py-0.5 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">
                                Positif
                            </span>
                        </td>
                        <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">27 Apr 2025</td>
                        <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                            <a href="#" title="Lihat Detail" class="text-indigo-600 hover:text-indigo-900 p-1 hover:bg-indigo-100 rounded-full transition">
                                 <i class="ri-eye-line text-lg"></i>
                            </a>
                        </td>
                    </tr>
                    {{-- Akhir Contoh Data --}}
                </tbody>
            </table>
        </div>
    </div> {{-- End Table Card --}}

</div> {{-- End Content Wrapper Space Y --}}
@endsection

{{-- Opsional: Jika halaman ini butuh JS spesifik (misal untuk chart) --}}
@push('scripts')
    {{-- <script src="https://cdn.jsdelivr.net/npm/chart.js"></script> --}}
    {{-- <script> // Kode JS untuk inisialisasi chart </script> --}}
@endpush