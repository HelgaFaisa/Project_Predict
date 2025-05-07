@extends('layouts.app')

@section('title', 'Dashboard Utama')
@section('page-title', 'Dashboard')

@section('content')
<div class="space-y-8">
    {{-- Header Sambutan --}}
    <div>
        <h1 class="text-3xl font-bold text-gray-800">Selamat Datang Kembali, {{ $userName ?? 'Dokter' }}!</h1>
        <p class="mt-1 text-gray-600">Berikut ringkasan aktivitas terbaru Anda per {{ \Carbon\Carbon::now()->translatedFormat('l, d F Y') }}.</p>
    </div>

    {{-- Grid Kartu Statistik --}}
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
        {{-- Card 1: Pasien Aktif --}}
        <div class="bg-white rounded-xl shadow p-6 hover:shadow-lg transition-shadow duration-300 ease-in-out border border-gray-200">
            <div class="flex items-center justify-between">
                <span class="text-sm font-semibold text-gray-500 uppercase tracking-wider">Pasien Aktif</span>
                <div class="p-2 rounded-full bg-blue-100 text-blue-600">
                    <i class="ri-group-line text-xl"></i>
                </div>
            </div>
            <div class="mt-3">
                <span class="text-4xl font-bold text-gray-800">{{ $totalActivePatients ?? 0 }}</span>
                <p class="mt-1 text-xs {{ ($newPatientsThisWeek ?? 0) > 0 ? 'text-green-600' : 'text-gray-500' }} flex items-center">
                    @if(($newPatientsThisWeek ?? 0) > 0)
                        <i class="ri-arrow-up-line mr-1"></i> {{ $newPatientsThisWeek }} baru minggu ini
                    @else
                        Tidak ada pasien baru minggu ini
                    @endif
                </p>
            </div>
        </div>

        {{-- Card 2: Prediksi Hari Ini --}}
        <div class="bg-white rounded-xl shadow p-6 hover:shadow-lg transition-shadow duration-300 ease-in-out border border-gray-200">
            <div class="flex items-center justify-between">
                <span class="text-sm font-semibold text-gray-500 uppercase tracking-wider">Prediksi Hari Ini</span>
                <div class="p-2 rounded-full bg-yellow-100 text-yellow-600">
                    <i class="ri-flask-line text-xl"></i>
                </div>
            </div>
            <div class="mt-3">
                <span class="text-4xl font-bold text-gray-800">{{ $newPredictionsToday ?? 0 }}</span>
                <p class="mt-1 text-xs text-gray-500">
                    @if(($newPredictionsToday ?? 0) > 0)
                        Dilakukan hari ini
                    @else
                        Belum ada prediksi hari ini
                    @endif
                </p>
            </div>
        </div>

        {{-- Card 3: Pasien Risiko Tinggi --}}
        <div class="bg-white rounded-xl shadow p-6 hover:shadow-lg transition-shadow duration-300 ease-in-out border border-gray-200">
            <div class="flex items-center justify-between">
                <span class="text-sm font-semibold text-gray-500 uppercase tracking-wider">Total Risiko Tinggi</span>
                <div class="p-2 rounded-full bg-red-100 text-red-600">
                    <i class="ri-alert-line text-xl"></i>
                </div>
            </div>
            <div class="mt-3">
                <span class="text-4xl font-bold text-gray-800">{{ $highRiskPredictionsCount ?? 0 }}</span>
                <p class="mt-1 text-xs text-gray-500">
                    Prediksi hasil positif
                </p>
            </div>
        </div>

        {{-- Card 4: Artikel Edukasi --}}
        <div class="bg-white rounded-xl shadow p-6 hover:shadow-lg transition-shadow duration-300 ease-in-out border border-gray-200">
            <div class="flex items-center justify-between">
                <span class="text-sm font-semibold text-gray-500 uppercase tracking-wider">Artikel Edukasi</span>
                 <div class="p-2 rounded-full bg-green-100 text-green-600">
                    <i class="ri-book-open-line text-xl"></i>
                </div>
            </div>
            <div class="mt-3">
                <span class="text-4xl font-bold text-gray-800">{{ $educationArticleCount ?? 0 }}</span>
                <p class="mt-1 text-xs text-gray-500">
                    Total artikel tersedia
                </p>
            </div>
        </div>
    </div>

    {{-- Baris untuk Grafik dan Kalender --}}
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {{-- Grafik Tren Pasien Baru --}}
        <div class="bg-white rounded-xl shadow p-6 border border-gray-200 lg:col-span-1">
            <h2 class="text-xl font-semibold text-gray-800 mb-4">Tren Pasien Baru</h2>
            <div class="h-72 md:h-80">
                <canvas id="patientTrendChart"></canvas>
            </div>
        </div>

        {{-- Grafik Distribusi Hasil Prediksi --}}
        <div class="bg-white rounded-xl shadow p-6 border border-gray-200 lg:col-span-1">
            <h2 class="text-xl font-semibold text-gray-800 mb-4">Distribusi Prediksi</h2>
            <div class="h-72 md:h-80 flex items-center justify-center">
                <canvas id="predictionDistributionChart" style="max-width: 300px; max-height: 300px;"></canvas>
            </div>
        </div>

        {{-- Kalender --}}
        <div class="bg-white rounded-xl shadow p-6 border border-gray-200 lg:col-span-1">
            <h2 class="text-xl font-semibold text-gray-800 mb-4">Kalender</h2>
            <div id="calendarContainer" class="text-sm">
                {{-- Kalender akan dirender di sini oleh JavaScript --}}
            </div>
        </div>
    </div>


    {{-- Daftar Pasien (Ringkasan) --}}
    <div class="bg-white rounded-xl shadow overflow-hidden border border-gray-200">
        <div class="px-6 py-4 border-b border-gray-200 flex items-center justify-between">
           <h2 class="text-xl font-semibold text-gray-800">Pasien Terbaru</h2>
            <a href="{{ route('admin.pasien.index') }}" class="text-sm font-medium text-indigo-600 hover:text-indigo-800 transition duration-150 ease-in-out">
                Lihat Semua &rarr;
            </a>
        </div>
        <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
                <thead class="bg-gray-50">
                    <tr>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Nama</th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status Prediksi Terakhir</th>
                        <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Tgl. Prediksi/Masuk</th>
                        <th scope="col" class="relative px-6 py-3">
                            <span class="sr-only">Aksi</span>
                        </th>
                    </tr>
                </thead>
                <tbody class="bg-white divide-y divide-gray-200">
                    @forelse ($recentPatientsData as $data)
                        <tr class="hover:bg-gray-50 transition-colors duration-150">
                            <td class="px-6 py-4 whitespace-nowrap">
                                <div class="flex items-center">
                                    <div class="flex-shrink-0 h-8 w-8 rounded-full bg-blue-100 flex items-center justify-center text-blue-600 font-medium">
                                        @php
                                            $nameParts = explode(' ', $data['patient']->name);
                                            $initials = count($nameParts) > 1 ? strtoupper(substr($nameParts[0], 0, 1) . substr(end($nameParts), 0, 1)) : strtoupper(substr($nameParts[0], 0, 2));
                                        @endphp
                                        {{ $initials }}
                                    </div>
                                    <div class="ml-3">
                                        <div class="text-sm font-medium text-gray-900">{{ $data['patient']->name }}</div>
                                    </div>
                                </div>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm">
                                @if($data['latest_prediction_status'] == 'Positif')
                                    <span class="px-2.5 py-0.5 inline-flex text-xs leading-5 font-semibold rounded-full bg-red-100 text-red-800">
                                        Positif
                                    </span>
                                @elseif($data['latest_prediction_status'] == 'Negatif')
                                    <span class="px-2.5 py-0.5 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">
                                        Negatif
                                    </span>
                                @else
                                    <span class="px-2.5 py-0.5 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">
                                        {{ $data['latest_prediction_status'] }}
                                    </span>
                                @endif
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                                {{ $data['latest_prediction_date'] ? $data['latest_prediction_date']->translatedFormat('d M Y') : ($data['patient']->created_at ? $data['patient']->created_at->translatedFormat('d M Y') : 'N/A') }}
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                <a href="{{ route('admin.pasien.show', $data['patient']->_id) }}" title="Lihat Detail" class="text-indigo-600 hover:text-indigo-900 p-1 hover:bg-indigo-100 rounded-full transition">
                                    <i class="ri-eye-line text-lg"></i>
                                </a>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="4" class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 text-center">
                                Belum ada data pasien terbaru.
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>

    {{-- BAGIAN BARU: Artikel Edukasi Terbaru (Ringkasan) --}}
    <div class="bg-white rounded-xl shadow overflow-hidden border border-gray-200">
        <div class="px-6 py-4 border-b border-gray-200 flex items-center justify-between">
           <h2 class="text-xl font-semibold text-gray-800">Artikel Edukasi Terbaru</h2>
            <a href="{{ route('admin.education.index') }}" class="text-sm font-medium text-indigo-600 hover:text-indigo-800 transition duration-150 ease-in-out">
                Lihat Semua Artikel &rarr;
            </a>
        </div>
        <div class="divide-y divide-gray-200">
            @forelse ($recentEducationArticles as $article)
                <div class="p-6 hover:bg-gray-50 transition-colors duration-150">
                    <div class="flex items-start space-x-4">
                        {{-- Gambar Artikel --}}
                        @if($article->main_image_path)
                            <img src="{{ $article->main_image_url }}" alt="{{ Str::limit($article->title, 20) }}" class="h-20 w-32 object-cover rounded-md border border-gray-200 flex-shrink-0">
                        @else
                            <div class="h-20 w-32 bg-gray-100 rounded-md flex items-center justify-center text-gray-400 text-xs flex-shrink-0">
                                <i class="ri-image-line text-3xl"></i>
                            </div>
                        @endif
                        {{-- Detail Artikel --}}
                        <div class="flex-grow">
                            <h3 class="text-md font-semibold text-gray-800 hover:text-indigo-600">
                                <a href="{{ route('admin.education.show', $article) }}" title="{{ $article->title }}">
                                    {{ Str::limit($article->title, 70) }}
                                </a>
                            </h3>
                            <p class="text-xs text-gray-500 mt-1">
                                <span class="font-medium">{{ $article->category ?? 'Umum' }}</span> |
                                Dipublikasikan: {{ $article->published_at ? $article->published_at->translatedFormat('d M Y') : 'Belum dipublikasikan' }}
                                @if($article->author_name)
                                    | Oleh: {{ $article->author_name }}
                                @endif
                            </p>
                            {{-- Snippet Konten --}}
                            <p class="text-sm text-gray-600 mt-2 leading-relaxed">
                                {{ Str::limit(strip_tags($article->content), 120) }}
                            </p>
                        </div>
                        {{-- Tombol Aksi Cepat --}}
                        <div class="flex-shrink-0">
                             <a href="{{ route('admin.education.show', $article) }}" class="text-indigo-600 hover:text-indigo-800 p-1 hover:bg-indigo-100 rounded-full transition" title="Lihat Artikel">
                                <i class="ri-eye-line text-lg"></i>
                            </a>
                        </div>
                    </div>
                </div>
            @empty
                <div class="p-6 text-sm text-gray-500 text-center">
                    Belum ada artikel edukasi yang dipublikasikan.
                    <a href="{{ route('admin.education.create') }}" class="text-indigo-600 hover:underline ml-1">Tambah artikel baru?</a>
                </div>
            @endforelse
        </div>
    </div> {{-- End Artikel Edukasi Card --}}

</div>
@endsection

@push('scripts')
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Data dari PHP Controller
            const patientTrendLabels = @json($patientTrendLabels ?? []);
            const patientTrendData = @json($patientTrendData ?? []);
            const predictionDistributionLabels = @json($predictionDistributionLabels ?? []);
            const predictionDistributionData = @json($predictionDistributionData ?? []);

            // 1. Grafik Tren Pasien Baru (Line Chart)
            const patientTrendCtx = document.getElementById('patientTrendChart');
            if (patientTrendCtx) {
                new Chart(patientTrendCtx, {
                    type: 'line',
                    data: {
                        labels: patientTrendLabels,
                        datasets: [{
                            label: 'Pasien Baru',
                            data: patientTrendData,
                            borderColor: 'rgb(99, 102, 241)', // Indigo-500
                            backgroundColor: 'rgba(99, 102, 241, 0.2)',
                            tension: 0.3,
                            fill: true,
                            pointBackgroundColor: 'rgb(99, 102, 241)',
                            pointBorderColor: '#fff',
                            pointHoverBackgroundColor: '#fff',
                            pointHoverBorderColor: 'rgb(99, 102, 241)'
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {
                                    stepSize: 1,
                                    callback: function(value) {if (Number.isInteger(value)) {return value;}},
                                    color: '#6b7280' // Gray-500
                                },
                                grid: {
                                    color: '#e5e7eb' // Gray-200
                                }
                            },
                            x: {
                                ticks: {
                                    color: '#6b7280' // Gray-500
                                },
                                grid: {
                                    display: false
                                }
                            }
                        },
                        plugins: {
                            legend: {
                                display: true,
                                position: 'top',
                                labels: {
                                    color: '#374151' // Gray-700
                                }
                            },
                            tooltip: {
                                backgroundColor: '#1f2937', // Gray-800
                                titleColor: '#f3f4f6', // Gray-100
                                bodyColor: '#d1d5db', // Gray-300
                                mode: 'index',
                                intersect: false,
                                padding: 10,
                                cornerRadius: 4
                            }
                        }
                    }
                });
            }

            // 2. Grafik Distribusi Hasil Prediksi (Pie Chart)
            const predictionDistributionCtx = document.getElementById('predictionDistributionChart');
            if (predictionDistributionCtx) {
                const hasPredictionData = predictionDistributionData.some(value => value > 0);

                if (hasPredictionData) {
                    new Chart(predictionDistributionCtx, {
                        type: 'pie',
                        data: {
                            labels: predictionDistributionLabels,
                            datasets: [{
                                label: 'Distribusi Prediksi',
                                data: predictionDistributionData,
                                backgroundColor: [
                                    'rgb(239, 68, 68)',
                                    'rgb(34, 197, 94)'
                                ],
                                borderColor: [
                                    'rgb(255, 255, 255)',
                                    'rgb(255, 255, 255)'
                                ],
                                borderWidth: 2,
                                hoverOffset: 8
                            }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                legend: {
                                    position: 'bottom',
                                    labels: {
                                        color: '#374151',
                                        padding: 15
                                    }
                                },
                                tooltip: {
                                    backgroundColor: '#1f2937',
                                    titleColor: '#f3f4f6',
                                    bodyColor: '#d1d5db',
                                    padding: 10,
                                    cornerRadius: 4,
                                    callbacks: {
                                        label: function(context) {
                                            let label = context.label || '';
                                            if (label) {
                                                label += ': ';
                                            }
                                            if (context.parsed !== null) {
                                                label += context.parsed;
                                            }
                                            let total = context.dataset.data.reduce((acc, val) => acc + val, 0);
                                            let percentage = total > 0 ? ((context.parsed / total) * 100).toFixed(1) + '%' : '0%';
                                            label += ` (${percentage})`;
                                            return label;
                                        }
                                    }
                                }
                            }
                        }
                    });
                } else {
                    const parentDiv = predictionDistributionCtx.parentNode;
                    parentDiv.innerHTML = '<p class="text-center text-gray-500 italic py-10">Belum ada data prediksi untuk ditampilkan.</p>';
                }
            }

            // 3. Kalender Sederhana
            const calendarContainer = document.getElementById('calendarContainer');
            if (calendarContainer) {
                const today = new Date();
                let currentMonth = today.getMonth();
                let currentYear = today.getFullYear();
                const monthNames = ["Januari", "Februari", "Maret", "April", "Mei", "Juni", "Juli", "Agustus", "September", "Oktober", "November", "Desember"];
                const dayNames = ["Min", "Sen", "Sel", "Rab", "Kam", "Jum", "Sab"];

                function renderCalendar(month, year) {
                    calendarContainer.innerHTML = '';
                    const header = document.createElement('div');
                    header.className = 'flex items-center justify-between mb-4 px-1';
                    const monthYearText = document.createElement('h3');
                    monthYearText.className = 'text-lg font-semibold text-gray-700';
                    monthYearText.textContent = monthNames[month] + ' ' + year;
                    const navButtons = document.createElement('div');
                    navButtons.className = 'flex space-x-2';
                    const prevButton = document.createElement('button');
                    prevButton.innerHTML = '<i class="ri-arrow-left-s-line text-xl text-gray-600 hover:text-indigo-600"></i>';
                    prevButton.className = 'p-1 rounded-full hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-indigo-300';
                    prevButton.onclick = () => {
                        currentMonth--;
                        if (currentMonth < 0) { currentMonth = 11; currentYear--; }
                        renderCalendar(currentMonth, currentYear);
                    };
                    const nextButton = document.createElement('button');
                    nextButton.innerHTML = '<i class="ri-arrow-right-s-line text-xl text-gray-600 hover:text-indigo-600"></i>';
                    nextButton.className = 'p-1 rounded-full hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-indigo-300';
                    nextButton.onclick = () => {
                        currentMonth++;
                        if (currentMonth > 11) { currentMonth = 0; currentYear++; }
                        renderCalendar(currentMonth, currentYear);
                    };
                    navButtons.appendChild(prevButton);
                    navButtons.appendChild(nextButton);
                    header.appendChild(monthYearText);
                    header.appendChild(navButtons);
                    calendarContainer.appendChild(header);
                    const table = document.createElement('table');
                    table.className = 'w-full';
                    const a_thead = table.createTHead();
                    const headerRow = a_thead.insertRow();
                    dayNames.forEach(day => {
                        const th = document.createElement('th');
                        th.className = 'pb-2 text-xs text-gray-500 font-medium text-center';
                        th.textContent = day;
                        headerRow.appendChild(th);
                    });
                    const tbody = table.createTBody();
                    const firstDayOfMonth = new Date(year, month, 1).getDay();
                    const daysInMonth = new Date(year, month + 1, 0).getDate();
                    let date = 1;
                    for (let i = 0; i < 6; i++) {
                        if (date > daysInMonth) break;
                        const row = tbody.insertRow();
                        for (let j = 0; j < 7; j++) {
                            const cell = row.insertCell();
                            cell.className = 'p-1.5 text-center';
                            if (i === 0 && j < firstDayOfMonth) {
                                cell.textContent = '';
                            } else if (date > daysInMonth) {
                                cell.textContent = '';
                            } else {
                                const daySpan = document.createElement('span');
                                daySpan.textContent = date;
                                daySpan.className = 'w-8 h-8 flex items-center justify-center rounded-full cursor-default hover:bg-gray-100';
                                if (date === today.getDate() && year === today.getFullYear() && month === today.getMonth()) {
                                    daySpan.classList.add('bg-indigo-500', 'text-white', 'font-semibold');
                                    daySpan.classList.remove('hover:bg-gray-100');
                                } else {
                                    daySpan.classList.add('text-gray-700');
                                }
                                cell.appendChild(daySpan);
                                date++;
                            }
                        }
                    }
                    calendarContainer.appendChild(table);
                }
                renderCalendar(currentMonth, currentYear);
            }
        });
    </script>
@endpush
