@extends('layouts.public_layout') {{-- Menggunakan layout publik Anda --}}

@section('title', 'Selamat Datang di DiabetaCare - Solusi Informasi Diabetes Terdepan')
@section('meta_description', 'DiabetaCare adalah platform informasi terpercaya untuk membantu Anda memahami, mencegah, dan mengelola diabetes dengan lebih baik melalui artikel edukasi dan panduan kesehatan.')
@section('meta_keywords', 'diabetes, informasi diabetes, edukasi kesehatan, gula darah, manajemen diabetes, DiabetaCare')
{{-- Pastikan path gambar OG default Anda benar --}}
@section('og_image', asset('images/diabetacare_og_blue_default.jpg'))

@section('content')

    {{-- Hero Section --}}
    <section class="bg-gradient-to-r from-brand-blue-600 via-brand-blue-500 to-brand-accent text-grey py-20 md:py-32">
        <div class="container mx-auto text-center px-4">
            <h1 class="text-4xl sm:text-5xl md:text-6xl font-bold mb-6 leading-tight font-display animate-fadeInUp" style="animation-delay: 0.2s;">
                Pahami Diabetes, Kendalikan Hidup Anda
            </h1>
            <p class="text-lg sm:text-xl mb-10 max-w-3xl mx-auto opacity-90 animate-fadeInUp" style="animation-delay: 0.4s;">
                Temukan informasi akurat, panduan praktis, dan artikel edukasi terbaru untuk membantu Anda dan keluarga dalam perjalanan mengelola diabetes menuju hidup yang lebih sehat dan berkualitas.
            </p>
            <div class="space-y-4 sm:space-y-0 sm:space-x-6 animate-fadeInUp" style="animation-delay: 0.6s;">
                <a href="{{ route('public.articles.index') }}"
                   class="inline-block bg-white text-brand-primary-dark font-semibold px-10 py-4 rounded-lg shadow-lg hover:bg-brand-gray-100 transition-all duration-300 text-lg transform hover:scale-105 focus:outline-none focus:ring-2 focus:ring-white focus:ring-opacity-50">
                    Jelajahi Artikel
                </a>
                {{-- Contoh tombol sekunder jika diperlukan untuk halaman lain dari hero --}}
                {{-- <a href="{{ route('public.about') }}"
                   class="inline-block bg-transparent border-2 border-white text-white font-semibold px-10 py-4 rounded-lg hover:bg-white hover:text-brand-primary-dark transition-all duration-300 text-lg transform hover:scale-105 focus:outline-none focus:ring-2 focus:ring-white focus:ring-opacity-50">
                    Tentang Kami
                </a> --}}
            </div>
        </div>
    </section>

    {{-- Featured Articles Section --}}
    @if(isset($featuredArticles) && $featuredArticles->count() > 0)
    <section class="py-16 lg:py-24 bg-white">
        <div class="container mx-auto px-4">
            <div class="text-center mb-12 md:mb-16">
                <span class="inline-block text-sm font-semibold text-brand-primary-DEFAULT uppercase tracking-wider mb-2">Wawasan Terbaru</span>
                <h2 class="text-3xl md:text-4xl font-bold text-brand-navy mb-4 font-display">Artikel Edukasi Unggulan</h2>
                <p class="text-brand-gray-600 max-w-xl mx-auto text-base md:text-lg">
                    Pilihan artikel terbaik kami untuk membantu Anda memahami diabetes lebih dalam.
                </p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                @foreach ($featuredArticles as $article)
                <div class="premium-card flex flex-col reveal-on-scroll"> {{-- Menggunakan kelas .premium-card dari layout --}}
                    <a href="{{ route('public.articles.show', $article->slug) }}" class="block overflow-hidden rounded-t-xl group">
                        <img src="{{ $article->main_image_url }}" alt="{{ $article->title }}" class="w-full h-56 object-cover transform group-hover:scale-105 transition-transform duration-300">
                    </a>
                    <div class="p-6 flex flex-col flex-grow">
                        @if($article->category)
                        <span class="inline-block bg-brand-blue-100 text-brand-primary-dark text-xs font-semibold px-3 py-1 rounded-full mb-3 self-start">{{ $article->category }}</span>
                        @endif
                        <h3 class="text-xl font-semibold text-brand-navy mb-3 font-display leading-tight">
                            <a href="{{ route('public.articles.show', $article->slug) }}" class="hover:text-brand-primary-DEFAULT transition-colors">
                                {{ Str::limit($article->title, 60) }}
                            </a>
                        </h3>
                        <p class="text-sm text-brand-gray-600 leading-relaxed mb-5 flex-grow">
                            {{ Str::limit(strip_tags($article->content), 110) }}
                        </p>
                        <div class="mt-auto pt-4 border-t border-brand-gray-200">
                             <div class="flex items-center justify-between text-xs text-brand-gray-500">
                                <span class="inline-flex items-center">
                                    <i class="ri-calendar-2-line mr-1.5 text-brand-accent"></i>
                                    {{ $article->published_at ? $article->published_at->translatedFormat('d M Y') : 'Segera' }}
                                </span>
                                <a href="{{ route('public.articles.show', $article->slug) }}" class="font-semibold text-brand-primary-DEFAULT hover:text-brand-primary-dark inline-flex items-center group/link">
                                    Baca Selengkapnya <i class="ri-arrow-right-s-line ml-1 group-hover/link:translate-x-1 transition-transform"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                @endforeach
            </div>
            {{-- Tampilkan tombol "Lihat Semua Artikel" jika ada artikel unggulan --}}
            @if($featuredArticles->count() > 0)
            <div class="text-center mt-12 md:mt-16">
                <a href="{{ route('public.articles.index') }}"
                   class="btn-primary text-base px-8 py-3.5">
                    Lihat Semua Artikel
                </a>
            </div>
            @endif
        </div>
    </section>
    @endif

    {{-- About Us Snippet Section --}}
    <section class="py-16 lg:py-24 bg-brand-blue-50">
        <div class="container mx-auto px-4">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
                <div class="reveal-on-scroll">
                    {{-- Ganti dengan gambar yang relevan dan menarik --}}
                    <img src="https://placehold.co/600x475/E0EFFF/1E40AF?text=DiabetaCare+Team" alt="Tentang DiabetaCare" class="rounded-xl shadow-elegant w-full">
                </div>
                <div class="reveal-on-scroll" style="animation-delay: 0.15s;">
                    <span class="inline-block text-sm font-semibold text-brand-primary-DEFAULT uppercase tracking-wider mb-2">Kenali Kami Lebih Dekat</span>
                    <h2 class="text-3xl md:text-4xl font-bold text-brand-navy mb-6 font-display">Misi Kami di DiabetaCare</h2>
                    <p class="text-brand-gray-700 leading-relaxed mb-6 text-base md:text-lg">
                        DiabetaCare berkomitmen untuk menjadi sumber informasi terpercaya dan pendamping Anda dalam mengelola diabetes. Kami percaya bahwa dengan pengetahuan yang tepat, setiap individu dapat menjalani hidup yang lebih sehat dan bermakna.
                    </p>
                    <p class="text-brand-gray-700 leading-relaxed mb-8 text-base md:text-lg">
                        Kami menyajikan artikel edukasi, tips praktis, dan panduan berdasarkan bukti ilmiah terkini, yang dikurasi oleh para ahli di bidangnya untuk Anda.
                    </p>
                    <a href="{{ route('public.about') }}"
                       class="btn-secondary text-base px-8 py-3.5">
                        Pelajari Lebih Lanjut Tentang Kami
                    </a>
                </div>
            </div>
        </div>
    </section>

    {{-- Call to Action (jika ada aplikasi mobile) --}}
    {{--
    <section id="download-app" class="py-16 lg:py-24 blue-gradient-bg text-white">
        <div class="container mx-auto text-center px-4">
            <h2 class="text-3xl md:text-4xl font-bold mb-6 font-display">Dapatkan Aplikasi DiabetaCare Mobile!</h2>
            <p class="text-lg sm:text-xl mb-10 max-w-2xl mx-auto opacity-90">
                Kelola kesehatan diabetes Anda lebih mudah dengan fitur pencatatan, pengingat, dan akses artikel langsung dari genggaman Anda.
            </p>
            <div class="flex flex-col sm:flex-row items-center justify-center space-y-4 sm:space-y-0 sm:space-x-6">
                <a href="#" class="inline-block transform hover:scale-105 transition-transform">
                    <img src="{{ asset('images/google-play-badge.png') }}" alt="Get it on Google Play" class="h-14 md:h-16">
                </a>
                <a href="#" class="inline-block transform hover:scale-105 transition-transform">
                    <img src="{{ asset('images/app-store-badge.png') }}" alt="Download on the App Store" class="h-14 md:h-16">
                </a>
            </div>
        </div>
    </section>
    --}}

@endsection

@push('styles')
<style>
    /* Animasi sederhana untuk elemen yang muncul saat scroll */
    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    .animate-fadeInUp {
        opacity: 0; /* Mulai tidak terlihat */
        animation: fadeInUp 0.8s ease-out forwards;
    }
    .reveal-on-scroll {
        opacity: 0; /* Defaultnya tidak terlihat, akan dianimasikan oleh JS jika diimplementasikan */
    }
</style>
@endpush

@push('scripts')
<script>
// Skrip untuk animasi reveal on scroll (opsional, bisa dihapus jika tidak ingin)
document.addEventListener('DOMContentLoaded', () => {
    const revealElements = document.querySelectorAll('.reveal-on-scroll');

    if ("IntersectionObserver" in window) {
        const observer = new IntersectionObserver((entries, obs) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    // Mengambil delay dari data-delay atau default ke 0s
                    const delay = entry.target.dataset.delay || '0s';
                    entry.target.style.animationDelay = delay;
                    entry.target.classList.add('animate-fadeInUp');
                    obs.unobserve(entry.target); // Hentikan observasi setelah animasi
                }
            });
        }, { threshold: 0.1 }); // Munculkan saat 10% elemen terlihat

        revealElements.forEach(el => {
            observer.observe(el);
        });
    } else {
        // Fallback untuk browser yang tidak mendukung IntersectionObserver
        revealElements.forEach(el => {
            el.style.opacity = 1; // Langsung tampilkan elemen
        });
    }
});
</script>
@endpush
