<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title', 'Dashboard Dokter') | DiabetaCare</title>

    {{-- Tailwind CSS --}}
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'sidebar-purple': '#6D5BD0',
                        'sidebar-active': 'rgba(255, 255, 255, 0.2)',
                        'content-bg': '#F8F7FC',
                    }
                }
            }
        }
    </script>

    {{-- Icon Libraries --}}
    <script src="https://unpkg.com/@phosphor-icons/web"></script>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.2.0/fonts/remixicon.css" rel="stylesheet">
    {{-- Google Fonts --}}
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            -webkit-font-smoothing: antialiased;
            -moz-osx-font-smoothing: grayscale;
        }
        .sidebar-transition {
            transition: transform 0.3s ease-in-out, width 0.3s ease-in-out; /* Tambahkan transisi width */
        }
        .menu-item {
            text-decoration: none;
        }
    </style>
    @stack('styles')
</head>
<body class="bg-content-bg">
    <div class="flex h-screen overflow-hidden">

        @include('layouts.sidebar')

        <div class="flex-1 flex flex-col overflow-hidden bg-content-bg">
            <header class="sticky top-0 z-30 bg-white border-b border-gray-200">
                <div class="flex items-center justify-between px-6 h-20">
                    <div class="flex items-center">
                        <button id="toggleSidebar" class="lg:hidden mr-4 p-2 rounded-full text-gray-600 hover:bg-gray-100 transition-colors focus:outline-none focus:ring-2 focus:ring-inset focus:ring-indigo-500">
                            <span class="sr-only">Buka menu</span>
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M4 6h16M4 12h16M4 18h16" />
                            </svg>
                        </button>
                        <div>
                            <h1 class="text-xl font-semibold text-gray-800">@yield('page-title', 'Dashboard')</h1>
                        </div>
                    </div>
                    <div class="flex items-center space-x-3 sm:space-x-5">
                        <a href="{{ route('admin.pasien.create') }}" class="hidden sm:flex items-center gap-2 px-4 py-2 bg-sidebar-purple text-white rounded-lg text-sm font-medium hover:bg-opacity-90 transition-colors">
                            <i class="ri-add-line"></i>
                            Tambah Pasien
                        </a>

                        {{-- AWAL BLOK PROFIL PENGGUNA YANG DIRAPIKAN --}}
                        <div class="relative" x-data="{ open: false }">
                            <button @click="open = !open" class="flex items-center gap-2 focus:outline-none">
                                {{-- Area Avatar (Foto atau Inisial) --}}
                                <div class="w-10 h-10 rounded-full bg-indigo-100 flex items-center justify-center overflow-hidden border border-gray-300">
                                    @php
                                        $namaKolomFoto = 'avatar_url'; // Nama kolom sudah disesuaikan
                                        $user = Auth::user();
                                        $pathFotoDariUser = null;
                                        $urlGambarFinalUntukSrc = null;

                                        if ($user && isset($user->{$namaKolomFoto}) && !empty(trim($user->{$namaKolomFoto}))) {
                                            $pathFotoDariUser = trim($user->{$namaKolomFoto});

                                            if (strpos($pathFotoDariUser, 'http://') === 0 || strpos($pathFotoDariUser, 'https://') === 0) {
                                                $urlGambarFinalUntukSrc = $pathFotoDariUser;
                                            } elseif (strpos($pathFotoDariUser, '/storage/') === 0) {
                                                $urlGambarFinalUntukSrc = asset($pathFotoDariUser);
                                            } else {
                                                $urlGambarFinalUntukSrc = asset('storage/' . $pathFotoDariUser);
                                            }
                                        }
                                    @endphp

                                    @if ($user && $pathFotoDariUser && $urlGambarFinalUntukSrc)
                                        {{-- Jika semua kondisi terpenuhi, tampilkan gambar --}}
                                        {{-- Teks debug visual "FOTO" dihilangkan untuk tampilan bersih --}}
                                        <img src="{{ $urlGambarFinalUntukSrc }}" alt="{{ $user->name }}" class="w-full h-full object-cover">
                                    @else
                                        {{-- Jika tidak, tampilkan inisial --}}
                                        {{-- Teks debug visual "INISIAL" dihilangkan untuk tampilan bersih --}}
                                        <span class="font-semibold text-sm text-sidebar-purple">{{ substr(Auth::user()->name ?? 'DR', 0, 2) }}</span>
                                    @endif
                                </div>
                                {{-- Nama Pengguna dan Ikon Panah --}}
                                <div class="hidden md:block text-left">
                                    <span class="font-medium text-sm text-gray-700">{{ Auth::user()->name ?? 'Dokter' }}</span>
                                    <i class="ri-arrow-down-s-line text-xs text-gray-500"></i>
                                </div>
                            </button>

                            {{-- Dropdown Menu --}}
                            <div x-show="open" @click.away="open = false"
                                 x-transition:enter="transition ease-out duration-100"
                                 x-transition:enter-start="transform opacity-0 scale-95"
                                 x-transition:enter-end="transform opacity-100 scale-100"
                                 x-transition:leave="transition ease-in duration-75"
                                 x-transition:leave-start="transform opacity-100 scale-100"
                                 x-transition:leave-end="transform opacity-0 scale-95"
                                 class="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-xl z-50 border border-gray-200 py-1"
                                 style="display: none;">
                                <a href="{{ route('admin.profile.index') }}" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                                    <i class="ri-user-line mr-2"></i>Profil Saya
                                </a>
                                <div class="border-t border-gray-100 my-1"></div>
                                <form method="POST" action="{{ route('logout') }}" class="w-full">
                                    @csrf
                                    <button type="submit" class="w-full text-left block px-4 py-2 text-sm text-red-600 hover:bg-red-50 hover:text-red-700">
                                        <i class="ri-logout-box-r-line mr-2"></i>Logout
                                    </button>
                                </form>
                            </div>
                        </div>
                        {{-- AKHIR BLOK PROFIL PENGGUNA YANG DIRAPIKAN --}}
                    </div>
                </div>
            </header>

            <main class="flex-1 overflow-x-hidden overflow-y-auto">
                <div class="container mx-auto px-6 py-8">
                    @yield('content')
                </div>
            </main>
        </div>
    </div>

    {{-- Alpine.js --}}
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>

    {{-- JavaScript Anda --}}
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // ... (sisa kode JavaScript Anda tetap sama) ...
            const sidebar = document.getElementById('sidebar');
            const toggleSidebarBtn = document.getElementById('toggleSidebar');
            // const toggleExpandSidebarBtn = document.getElementById('toggleExpandSidebar'); // Anda mungkin menggunakan ini

            if (sidebar && toggleSidebarBtn) {
                toggleSidebarBtn.addEventListener('click', function() {
                    sidebar.classList.toggle('-translate-x-full');
                });
                document.addEventListener('click', function(event) {
                    if (window.innerWidth < 1024 && !sidebar.classList.contains('-translate-x-full') && !sidebar.contains(event.target) && !toggleSidebarBtn.contains(event.target)) {
                        sidebar.classList.add('-translate-x-full');
                    }
                });
            }

            const currentPath = window.location.pathname;
            if (sidebar) {
                const menuLinks = sidebar.querySelectorAll('nav a.menu-item');
                menuLinks.forEach(link => {
                    const linkUrl = new URL(link.href, window.location.origin);
                    const isLogoutForm = link.closest('form') && link.closest('form').action.includes('logout');
                    let isActive = false;
                    link.classList.remove('bg-white/20', 'text-white', 'bg-red-500/50');
                    link.classList.add('text-white/80', 'hover:bg-white/10');
                    if (isLogoutForm) {
                        link.classList.remove('hover:bg-white/10');
                        link.classList.add('hover:bg-red-500/30');
                    }
                    const icon = link.querySelector('i');
                    if (icon && icon.className.includes('-fill')) {
                        icon.className = icon.className.replace('-fill', '-line');
                    }
                    if (linkUrl.pathname === "/" && currentPath === "/") {
                        //
                    } else if (linkUrl.pathname !== "/" && currentPath.startsWith(linkUrl.pathname)) {
                        isActive = true;
                    } else if (linkUrl.pathname === currentPath) {
                        isActive = true;
                    }
                    if (isActive) {
                        if (!isLogoutForm) {
                            link.classList.add('bg-white/20', 'text-white');
                            link.classList.remove('text-white/80', 'hover:bg-white/10');
                            if (icon && icon.className.includes('-line')) {
                                icon.className = icon.className.replace('-line', '-fill');
                            }
                        }
                    }
                });
            }
        });
    </script>
    @stack('scripts')
</body>
</html>