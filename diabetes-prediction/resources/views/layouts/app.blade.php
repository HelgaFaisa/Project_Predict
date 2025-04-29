<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title', 'Dashboard Dokter') | DiabetaCare</title>

    {{-- Tailwind CSS --}}
    <script src="https://cdn.tailwindcss.com"></script>
    {{-- Konfigurasi Tambahan Tailwind --}}
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'sidebar-purple': '#6D5BD0', // Warna ungu sidebar
                        'sidebar-active': 'rgba(255, 255, 255, 0.2)', // Background item aktif (semi-transparan putih)
                        'content-bg': '#F8F7FC',     // Background konten utama
                    }
                }
            }
        }
    </script>

    {{-- Icon Libraries --}}
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
    {{-- Google Fonts --}}
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    {{-- Custom CSS --}}
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }
        .sidebar-transition {
            transition: transform 0.3s ease-in-out;
        }
        /* Styling Scrollbar Sidebar (jika sidebar punya scroll internal) */
        /* Pindahkan ini ke dalam <style> di layouts/sidebar.blade.php jika hanya berlaku di sana */
        /* nav::-webkit-scrollbar { ... } */

        /* Pastikan link tidak ada garis bawah default */
        .menu-item {
            text-decoration: none;
        }
    </style>

    @stack('styles') {{-- Slot untuk CSS tambahan per halaman --}}
</head>
<body class="bg-content-bg">
    <div class="flex h-screen overflow-hidden">

        {{-- Panggil Sidebar Partial --}}
        @include('layouts.sidebar')
        {{-- Kode <aside>...</aside> yang sebelumnya ada di sini, sekarang dipindahkan ke layouts/sidebar.blade.php --}}

        {{-- Konten Utama Wrapper --}}
        <div class="flex-1 flex flex-col overflow-hidden bg-content-bg">
            {{-- Header/Topbar --}}
            <header class="sticky top-0 z-10 bg-white border-b border-gray-200">
                <div class="flex items-center justify-between px-6 h-20">
                    {{-- Kiri: Tombol Toggle & Judul Halaman --}}
                    <div class="flex items-center">
                        {{-- Tombol ini HARUS ada di sini karena mengontrol sidebar --}}
                        <button id="toggleSidebar" class="lg:hidden mr-4 p-2 rounded-full text-gray-600 hover:bg-gray-100 transition-colors focus:outline-none focus:ring-2 focus:ring-inset focus:ring-indigo-500">
                            <span class="sr-only">Buka menu</span>
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M4 6h16M4 12h16M4 18h16" />
                            </svg>
                        </button>
                        <div>
                            <h1 class="text-xl font-semibold text-gray-800">@yield('page-title', 'Dashboard')</h1>
                            <p class="text-sm text-gray-500">Selamat datang kembali!</p> {{-- Contoh teks --}}
                        </div>
                    </div>
                    {{-- Kanan: Tombol Aksi, Notifikasi, Profil --}}
                    <div class="flex items-center space-x-5">
                        {{-- Contoh Tombol (sesuaikan) --}}
                        <button class="hidden sm:block text-sm text-gray-600 hover:text-sidebar-purple font-medium">
                            Riwayat Janji Temu
                        </button>
                        <button class="hidden sm:flex items-center gap-2 px-4 py-2 bg-sidebar-purple text-white rounded-lg text-sm font-medium hover:bg-opacity-90 transition-colors">
                            <i class="ri-add-line"></i>
                            Tambah Pasien
                        </button>
                        {{-- Notifikasi --}}
                        <button class="relative p-2 rounded-full text-gray-500 hover:bg-gray-100 hover:text-gray-700 transition-colors focus:outline-none">
                            <span class="sr-only">Lihat Notifikasi</span>
                            <i class="ri-notification-3-line text-xl"></i>
                            <span class="absolute top-1.5 right-1.5 block h-2 w-2 rounded-full bg-red-500 ring-1 ring-white"></span>
                        </button>
                        {{-- Profil Pengguna --}}
                        <div class="relative flex items-center gap-3">
                            <button class="w-10 h-10 rounded-full bg-indigo-100 flex items-center justify-center overflow-hidden border border-gray-300 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-sidebar-purple">
                                <span class="font-semibold text-sm text-sidebar-purple">{{ substr(Auth::user()->name ?? 'DR', 0, 2) }}</span>
                            </button>
                            <div class="hidden md:block text-left">
                                <span class="font-medium text-sm text-gray-700">{{ Auth::user()->name ?? 'Dokter' }}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </header>

            {{-- Area Konten Utama --}}
            <main class="flex-1 overflow-x-hidden overflow-y-auto">
                <div class="container mx-auto px-6 py-8">
                    @yield('content')
                </div>
            </main>

        </div> {{-- Akhir Main Content Wrapper --}}
    </div> {{-- Akhir Root Flex Container --}}

    {{-- JavaScript --}}
    <script>
        // Kode ini perlu mengakses ID sidebar dari file yang di-include
        const sidebar = document.getElementById('sidebar');
        const toggleSidebarBtn = document.getElementById('toggleSidebar'); // Tombol ini ada di header layout ini

        // Pastikan elemen sidebar ditemukan sebelum menambahkan event listener
        if (sidebar && toggleSidebarBtn) {
            const activeClasses = ['bg-sidebar-active', 'text-white'];
            const inactiveClasses = ['text-white/80', 'hover:bg-white/10', 'hover:text-white'];
            const activeLogoutClasses = ['bg-red-500/50', 'text-white'];
            const inactiveLogoutClasses = ['text-white/80', 'hover:bg-red-500/30', 'hover:text-white'];

            function toggleSidebar() {
                sidebar.classList.toggle('-translate-x-full');
            }

            toggleSidebarBtn.addEventListener('click', toggleSidebar);

            // Tutup sidebar saat klik di luar (mobile)
            document.addEventListener('click', function(event) {
                if (!sidebar.classList.contains('-translate-x-full') && sidebar.contains && !sidebar.contains(event.target) && !toggleSidebarBtn.contains(event.target)) {
                    if (window.innerWidth < 1024) {
                        toggleSidebar();
                    }
                }
            });

            // Fungsi menandai menu aktif (diasumsikan link menu ada di dalam sidebar yang di-include)
            document.addEventListener('DOMContentLoaded', function() {
                const currentPath = window.location.pathname;
                // Cari link menu di dalam elemen sidebar
                const menuLinks = sidebar.querySelectorAll('nav a.menu-item');

                menuLinks.forEach(link => {
                    const linkUrl = new URL(link.href);
                    const isLogout = link.classList.contains('logout-item');
                    let isActive = false;

                    link.classList.remove(...activeClasses, ...activeLogoutClasses);
                    if (isLogout) {
                        link.classList.add(...inactiveLogoutClasses);
                    } else {
                        link.classList.add(...inactiveClasses);
                    }
                    const icon = link.querySelector('i');
                    if (icon && icon.className.includes('-fill')) {
                        icon.className = icon.className.replace('-fill', '-line');
                    }

                    if (linkUrl.pathname === currentPath) {
                        isActive = true;
                    } else if (linkUrl.pathname.endsWith('/admin/dashboard') && currentPath.startsWith('/admin/dashboard')) {
                       isActive = true;
                    } else if (linkUrl.pathname !== '/' && currentPath.startsWith(linkUrl.pathname) && linkUrl.pathname.length > 1) {
                         isActive = true;
                     }

                    if (isActive && !isLogout) {
                        link.classList.remove(...inactiveClasses);
                        link.classList.add(...activeClasses);
                        if (icon && icon.className.includes('-line')) {
                           icon.className = icon.className.replace('-line', '-fill');
                        }
                    } else if (isActive && isLogout) {
                        link.classList.remove(...inactiveLogoutClasses);
                        link.classList.add(...activeLogoutClasses);
                    }
                });
            });
        } else {
            if (!sidebar) console.error("Sidebar element with id 'sidebar' not found. Make sure it exists in layouts/sidebar.blade.php");
            if (!toggleSidebarBtn) console.error("Toggle button with id 'toggleSidebar' not found.");
        }
    </script>

    @stack('scripts') {{-- Slot untuk JS tambahan per halaman --}}

</body>
</html>