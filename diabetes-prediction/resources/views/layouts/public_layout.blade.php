<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    {{-- SEO Meta Tags --}}
    <title>@yield('title', 'DiabetaCare - Solusi Perawatan Diabetes Terdepan')</title>
    <meta name="description" content="@yield('meta_description', 'DiabetaCare menyediakan informasi ahli, artikel eksklusif, dan panduan personal untuk manajemen diabetes dan hidup lebih sehat.')">
    <meta name="keywords" content="@yield('meta_keywords', 'perawatan diabetes, manajemen diabetes, monitoring glukosa, solusi kesehatan, layanan kesehatan eksekutif, kebugaran')">
    <meta name="author" content="DiabetaCare">
    {{-- Open Graph Meta Tags --}}
    <meta property="og:title" content="@yield('title', 'DiabetaCare - Solusi Perawatan Diabetes Terdepan')">
    <meta property="og:description" content="@yield('meta_description', 'DiabetaCare menyediakan informasi ahli dan panduan personal untuk manajemen diabetes.')">
    <meta property="og:image" content="@yield('og_image', asset('images/diabetacare_og_blue_default.jpg'))">
    <meta property="og:url" content="{{ url()->current() }}">
    <meta property="og:type" content="website">

    {{-- Tailwind CSS & Configuration --}}
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        'brand-primary': {
                            light: '#7FB9FB',
                            DEFAULT: '#2563EB',
                            dark: '#1E40AF',
                        },
                        'brand-secondary': '#172554',
                        'brand-accent': '#4A90E2',
                        'brand-blue': {
                            50: '#F0F7FF',100: '#E0EFFF',200: '#B9DAFF',300: '#7FB9FB',400: '#4A90E2',500: '#2563EB',600: '#1D4ED8',700: '#1E40AF',800: '#1E3A8A',900: '#172554',
                        },
                        'brand-navy': '#0A192F',
                        'brand-cream': '#F0F7FF',
                        'brand-charcoal': '#1F2937', // Pastikan warna ini kontras dengan putih
                        'brand-gray': {
                            50: '#F9FAFB',100: '#F3F4F6',200: '#E5E7EB',300: '#D1D5DB',400: '#9CA3AF',500: '#6B7280',600: '#4B5563',700: '#374151',800: '#1F2937',900: '#111827',
                        },
                    },
                    fontFamily: {
                        'sans': ['Montserrat', 'sans-serif'],
                        'display': ['Playfair Display', 'serif'],
                    },
                    container: {
                        center: true,
                        padding: { DEFAULT: '1.5rem', sm: '2rem', lg: '4rem', xl: '5rem' },
                    },
                    boxShadow: {
                        'soft': '0 10px 25px -3px rgba(0, 0, 0, 0.05)',
                        'elegant': '0 20px 30px -12px rgba(29, 78, 216, 0.15)',
                        'premium': '0 25px 50px -12px rgba(29, 78, 216, 0.25)',
                        'footer-shadow': '0 -4px 6px -1px rgba(0, 0, 0, 0.05), 0 -2px 4px -1px rgba(0, 0, 0, 0.03)' // Contoh shadow untuk footer putih
                    }
                }
            },
            plugins: [
                require('@tailwindcss/typography'),
                require('@tailwindcss/forms'),
            ],
        }
    </script>

    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.2.0/fonts/remixicon.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@300;400;500;600;700;800&family=Playfair+Display:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        body { font-family: 'Montserrat', sans-serif; -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale; color: #374151; }
        .gradient-text-blue { background: linear-gradient(135deg, #4A90E2 0%, #1D4ED8 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; text-fill-color: transparent; }
        .blue-gradient-bg { background: linear-gradient(135deg, #2563EB 0%, #1E40AF 100%); }
        .active-nav-link { color: #2563EB; font-weight: 600; position: relative; }
        .active-nav-link::after { content: ''; position: absolute; bottom: -6px; left: 50%; transform: translateX(-50%); width: 20px; height: 2px; background-color: #2563EB; }
        .nav-link { @apply px-3 py-2 rounded-lg text-sm font-medium text-brand-gray-600 hover:text-brand-primary-DEFAULT transition-colors duration-200 relative; }
        .nav-link:hover::after { content: ''; position: absolute; bottom: -6px; left: 50%; transform: translateX(-50%); width: 20px; height: 2px; background-color: #2563EB; opacity: 0.5; }
        .premium-card { @apply bg-white rounded-xl shadow-elegant border border-brand-gray-100 overflow-hidden transition-all duration-300; }
        .premium-card:hover { @apply shadow-premium transform -translate-y-1; }
        .btn-primary { @apply px-6 py-3 bg-gradient-to-r from-brand-blue-500 to-brand-blue-700 text-white font-medium rounded-full shadow-md hover:shadow-lg transform hover:-translate-y-0.5 transition-all duration-300; }
        .btn-secondary { @apply px-6 py-3 bg-white text-brand-charcoal border border-brand-gray-200 font-medium rounded-full shadow-md hover:shadow-lg hover:border-brand-blue-300 transform hover:-translate-y-0.5 transition-all duration-300; }
        .prose { @apply text-brand-gray-700; }
        .prose h1, .prose h2, .prose h3, .prose h4, .prose h5, .prose h6 { @apply font-display text-brand-navy; }
        .prose h1 { @apply text-3xl md:text-4xl font-bold; } .prose h2 { @apply text-2xl md:text-3xl font-semibold; }
        .prose a { @apply text-brand-primary-DEFAULT hover:text-brand-primary-dark; }
        .prose strong { @apply text-brand-charcoal font-semibold; }
        .glass-effect { background: rgba(224, 239, 255, 0.7); backdrop-filter: blur(8px); -webkit-backdrop-filter: blur(8px); border: 1px solid rgba(185, 218, 255, 0.2); }
        @keyframes float { 0% { transform: translateY(0px); } 50% { transform: translateY(-10px); } 100% { transform: translateY(0px); } }
        .animate-float { animation: float 6s ease-in-out infinite; }
    </style>
    @stack('styles')
</head>
<body class="bg-gradient-to-br from-brand-blue-50 to-brand-gray-50 min-h-screen flex flex-col">

<header class="glass-effect sticky top-0 z-50 shadow-sm">
    <div class="container mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex items-center justify-between h-24">
            {{-- Logo --}}
            <div class="flex-shrink-0">
                <a href="{{ route('public.home') }}" class="flex items-center">
                    <div class="flex-shrink-0 w-12 h-12 blue-gradient-bg rounded-full flex items-center justify-center shadow-md">
                        <i class="ri-heart-pulse-line text-white text-2xl"></i>
                    </div>
                    <div class="ml-3">
                        <span class="text-2xl font-display font-bold gradient-text-blue">DiabetaCare</span>
                        <span class="block text-xs text-brand-primary-DEFAULT mt-0.5">Solusi Kesehatan Terdepan</span>
                    </div>
                </a>
            </div>

            {{-- Desktop Navigation (Tautan Utama) --}}
            <nav class="hidden md:flex space-x-6 items-center">
                <a href="{{ route('public.home') }}" class="nav-link {{ request()->routeIs('public.home') ? 'active-nav-link' : '' }}">Beranda</a>
                <a href="{{ route('public.articles.index') }}" class="nav-link {{ request()->routeIs('public.articles.index') || request()->routeIs('public.articles.show') ? 'active-nav-link' : '' }}">Artikel Edukasi</a>
                <a href="{{ route('public.about') }}" class="nav-link {{ request()->routeIs('public.about') ? 'active-nav-link' : '' }}">Tentang Kami</a>
            </nav>

            {{-- Grup Tombol Kanan: Ikon Login & Tombol WhatsApp (Desktop) --}}
            <div class="hidden md:flex items-center space-x-3"> 
                {{-- Tombol Ikon Login --}}
                <a href="{{ route('login') }}" title="Login Admin"
                   class="p-2 text-brand-gray-700 hover:text-brand-primary-DEFAULT transition-colors duration-150 rounded-md hover:bg-brand-blue-50">
                    <i class="ri-user-line text-xl"></i>
                </a>

                {{-- Tombol Ikon WhatsApp (Desktop) - GRADASI --}}
                <a href="https://wa.me/6281310384433?text={{ urlencode('Halo DiabetaCare, saya ingin bertanya...') }}" target="_blank" rel="noopener noreferrer"
                   class="inline-flex items-center justify-center p-2 blue-gradient-bg text-white rounded-full hover:opacity-90 transition-opacity duration-150 shadow-md"
                   title="Hubungi kami via WhatsApp">
                    <i class="ri-whatsapp-fill text-xl"></i>
                </a>
            </div>

            {{-- Mobile Menu Button --}}
            <div class="md:hidden">
                <button id="mobileMenuButton" type="button" class="inline-flex items-center justify-center p-2 rounded-lg text-brand-gray-500 hover:text-brand-primary-DEFAULT hover:bg-brand-gray-100 focus:outline-none" aria-controls="mobile-menu" aria-expanded="false">
                    <span class="sr-only">Buka menu utama</span>
                    <i class="ri-menu-3-line text-2xl block" id="menuIconOpen"></i>
                    <i class="ri-close-line text-2xl hidden" id="menuIconClose"></i>
                </button>
            </div>
        </div>
    </div>

    {{-- Mobile Menu --}}
    <div class="md:hidden hidden" id="mobileMenu">
        <div class="px-4 pt-3 pb-6 space-y-2 border-t border-brand-gray-100 bg-white shadow-lg">
            <a href="{{ route('public.home') }}" class="block px-4 py-3 rounded-lg text-base font-medium {{ request()->routeIs('public.home') ? 'text-brand-primary-DEFAULT bg-brand-blue-50' : 'text-brand-gray-700 hover:text-brand-primary-DEFAULT hover:bg-brand-gray-50' }}">Beranda</a>
            <a href="{{ route('public.articles.index') }}" class="block px-4 py-3 rounded-lg text-base font-medium {{ request()->routeIs('public.articles.index') || request()->routeIs('public.articles.show') ? 'text-brand-primary-DEFAULT bg-brand-blue-50' : 'text-brand-gray-700 hover:text-brand-primary-DEFAULT hover:bg-brand-gray-50' }}">Artikel Edukasi</a>
            <a href="{{ route('public.about') }}" class="block px-4 py-3 rounded-lg text-base font-medium {{ request()->routeIs('public.about') ? 'text-brand-primary-DEFAULT bg-brand-blue-50' : 'text-brand-gray-700 hover:text-brand-primary-DEFAULT hover:bg-brand-gray-50' }}">Tentang Kami</a>

            <div class="pt-5 mt-5 border-t border-brand-gray-200">
                <a href="https://wa.me/6281310384433?text={{ urlencode('Halo DiabetaCare, saya ingin bertanya...') }}" target="_blank" rel="noopener noreferrer"
                   class="flex items-center justify-center w-full px-4 py-3 bg-green-500 text-white rounded-lg text-base font-medium hover:bg-green-600 transition-colors shadow-md">
                    <i class="ri-whatsapp-fill text-lg mr-2"></i> Hubungi via WhatsApp
                </a>
                <a href="{{ route('login') }}" class="block text-center mt-4 px-4 py-3 rounded-lg text-sm font-medium text-brand-gray-600 hover:text-brand-primary-DEFAULT hover:bg-brand-blue-50">
                    Login Admin
                </a>
            </div>
        </div>
    </div>
</header>

    <main class="py-12 sm:py-16 flex-grow">
        {{-- PASTIKAN ADA KONTEN DI SINI UNTUK TESTING --}}
        {{-- Contoh konten minimal: --}}
        <div class="container mx-auto">
             @yield('content', '<p class="text-center text-brand-gray-500">Tidak ada konten yang ditampilkan.</p>')
        </div>
    </main>

    {{-- PERUBAHAN WARNA FOOTER DAN PENAMBAHAN SHADOW JIKA DIINGINKAN --}}
<footer class="blue-gradient-bg text-white shadow-footer-shadow"> 
        <div class="container mx-auto px-4 sm:px-6 lg:px-8 py-16">
            <div class="grid grid-cols-1 md:grid-cols-4 gap-12">
                <div class="col-span-1 md:col-span-2">
                    <div class="flex items-center mb-6">
                        <div class="flex-shrink-0 w-12 h-12 blue-gradient-bg rounded-full flex items-center justify-center shadow-md">
                            <i class="ri-heart-pulse-line text-white text-2xl"></i>
                        </div>
                        <div class="ml-3">
                            <span class="text-2xl font-display font-bold text-white">DiabetaCare</span>
                            <span class="block text-xs text-brand-blue-100 mt-0.5">Solusi Kesehatan Terdepan</span>
                        </div>
                    </div>
                    <p class="text-brand-blue-50 leading-relaxed mb-8 max-w-md">Menyediakan informasi dan dukungan untuk membantu Anda mengelola diabetes dan hidup lebih sehat.</p>
                    <div class="flex space-x-5">
                        <a href="#" class="text-brand-blue-200 hover:text-white transition-colors"><i class="ri-facebook-circle-fill text-2xl"></i></a>
                        <a href="#" class="text-brand-blue-200 hover:text-white transition-colors"><i class="ri-instagram-fill text-2xl"></i></a>
                        <a href="#" class="text-brand-blue-200 hover:text-white transition-colors"><i class="ri-twitter-x-fill text-2xl"></i></a>
                        <a href="#" class="text-brand-blue-200 hover:text-white transition-colors"><i class="ri-linkedin-box-fill text-2xl"></i></a>
                    </div>
                </div>
                <div>
                    <h3 class="text-lg font-semibold text-white mb-5 font-display">Tautan Cepat</h3>
                    <ul class="space-y-3 text-brand-blue-100">
                        <li><a href="{{ route('public.home') }}" class="hover:text-white transition-colors inline-flex items-center"><i class="ri-arrow-right-s-line mr-2 text-brand-blue-300"></i> Beranda</a></li>
                        <li><a href="{{ route('public.articles.index') }}" class="hover:text-white transition-colors inline-flex items-center"><i class="ri-arrow-right-s-line mr-2 text-brand-blue-300"></i> Artikel Edukasi</a></li>
                        <li><a href="{{ route('public.about') }}" class="hover:text-white transition-colors inline-flex items-center"><i class="ri-arrow-right-s-line mr-2 text-brand-blue-300"></i> Tentang Kami</a></li>
                        <li><a href="#" class="hover:text-white transition-colors inline-flex items-center"><i class="ri-arrow-right-s-line mr-2 text-brand-blue-300"></i> Kebijakan Privasi</a></li>
                        <li><a href="#" class="hover:text-white transition-colors inline-flex items-center"><i class="ri-arrow-right-s-line mr-2 text-brand-blue-300"></i> Syarat & Ketentuan</a></li>
                    </ul>
                </div>
                <div>
                    <h3 class="text-lg font-semibold text-white mb-5 font-display">Hubungi Kami</h3>
                    <ul class="space-y-4 text-brand-blue-100">
                        <li class="flex items-start"><i class="ri-map-pin-2-line text-brand-blue-300 mt-1 mr-3"></i><span>Kantor Pusat DiabetaCare<br>Jl. Kesehatan No. 123<br>Jakarta, Indonesia</span></li>
                        <li class="flex items-center"><i class="ri-mail-send-line text-brand-blue-300 mr-3"></i><span>info@diabetacare.id</span></li>
                        <li class="flex items-center"><i class="ri-phone-line text-brand-blue-300 mr-3"></i><span>+62 81310 4433</span></li>
                        <li class="flex items-center"><i class="ri-whatsapp-line text-brand-blue-300 mr-3"></i><span>+62 81310 4433</span></li>
                    </ul>
                </div>
            </div>
            <div class="mt-16 pt-8 border-t border-brand-blue-500 text-center text-sm text-brand-blue-200"> 
                <div class="flex flex-col md:flex-row items-center justify-between">
                    <p>&copy; {{ date('Y') }} DiabetaCare. Solusi Kesehatan Terdepan.</p>
                    <div class="mt-4 md:mt-0 flex items-center justify-center space-x-6">
                        <a href="#" class="text-brand-blue-200 hover:text-white transition-colors">Privacy Policy</a>
                        <span class="hidden md:inline text-brand-blue-200">•</span>
                        <a href="#" class="text-brand-blue-200 hover:text-white transition-colors">Terms of Service</a>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <button id="backToTop" title="Kembali ke atas" class="fixed bottom-8 right-8 w-12 h-12 blue-gradient-bg rounded-full flex items-center justify-center shadow-lg opacity-0 invisible transition-all duration-300 cursor-pointer z-40 hover:opacity-90">
        <i class="ri-arrow-up-line text-white text-xl"></i>
    </button>

    <script>
        const mobileMenuButton = document.getElementById('mobileMenuButton');
        const mobileMenu = document.getElementById('mobileMenu');
        const menuIconOpen = document.getElementById('menuIconOpen');
        const menuIconClose = document.getElementById('menuIconClose');
        if (mobileMenuButton && mobileMenu && menuIconOpen && menuIconClose) {
            mobileMenuButton.addEventListener('click', () => {
                const expanded = mobileMenuButton.getAttribute('aria-expanded') === 'true' || false;
                mobileMenuButton.setAttribute('aria-expanded', !expanded);
                mobileMenu.classList.toggle('hidden');
                menuIconOpen.classList.toggle('hidden');
                menuIconClose.classList.toggle('hidden');
            });
        }
        const backToTopButton = document.getElementById('backToTop');
        if (backToTopButton) {
            window.addEventListener('scroll', () => {
                if (window.pageYOffset > 300) {
                    backToTopButton.classList.remove('opacity-0', 'invisible');
                    backToTopButton.classList.add('opacity-100', 'visible');
                } else {
                    backToTopButton.classList.remove('opacity-100', 'visible');
                    backToTopButton.classList.add('opacity-0', 'invisible');
                }
            });
            backToTopButton.addEventListener('click', () => {
                window.scrollTo({ top: 0, behavior: 'smooth' });
            });
        }
    </script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    @stack('scripts')
</body>
</html>