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
        <div class="grid md:grid-cols-2 gap-8 items-center">
            <div class="text-left animate-fadeInUp" style="animation-delay: 0.2s;">
                {{-- Konten teks Anda --}}
                <h1 class="text-4xl sm:text-5xl md:text-6xl font-bold mb-6 leading-tight font-display">
                    Pahami Diabetes, <br class="hidden md:block">Kendalikan Hidup Anda
                </h1>
                <p class="text-lg sm:text-xl mb-10 max-w-xl opacity-90" style="animation-delay: 0.4s;">
                    Temukan informasi akurat, panduan praktis, dan artikel edukasi terbaru untuk membantu Anda dan keluarga dalam perjalanan mengelola diabetes menuju hidup yang lebih sehat dan berkualitas.
                </p>
                <div class="space-y-4 sm:space-y-0 sm:space-x-6" style="animation-delay: 0.6s;">
                    <a href="{{ route('public.articles.index') }}"
                        class="inline-block bg-white text-brand-primary-dark font-semibold px-10 py-4 rounded-lg shadow-lg hover:bg-brand-gray-100 transition-all duration-300 text-lg transform hover:scale-105 focus:outline-none focus:ring-2 focus:ring-white focus:ring-opacity-50">
                        Jelajahi Artikel
                    </a>
                </div>
            </div>
            <div class="animate-fadeInUp hidden md:block" style="animation-delay: 0.3s;">
                {{-- Pastikan src mengarah ke gambar2.png --}}
                <img src="{{ asset('images/gambar2.png') }}" alt="Ilustrasi Kartun Manajemen Diabetes" class="rounded-lg shadow-xl mx-auto">
            </div>
        </div>
    </div>
</section>

    {{-- Key Features/About Snippet Section (Inspired by Teman Diabetes "About" section) --}}
    <section id="key-features" class="py-16 lg:py-24 bg-brand-gray-50">
        <div class="container mx-auto px-4">
            <div class="text-center mb-12 md:mb-16">
                <span class="inline-block text-sm font-semibold text-brand-primary-DEFAULT uppercase tracking-wider mb-2">Fokus Kami</span>
                <h2 class="text-3xl md:text-4xl font-bold text-brand-navy mb-4 font-display">Informasi Diabetes Komprehensif</h2>
                <p class="text-brand-gray-600 max-w-xl mx-auto text-base md:text-lg">
                    DiabetaCare hadir untuk memberdayakan Anda dengan pengetahuan dan dukungan.
                </p>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
                {{-- Feature 1: Cek Kesehatan (adapted to General Info) --}}
                <div class="premium-card text-center reveal-on-scroll">
                    <div class="p-6 md:p-8">
                        <div class="mb-4 inline-block">
                            {{-- Placeholder for icon like 'shield-SkhkqIKpM.png' --}}
<img src="{{ asset('images/gambar1.png') }}" alt="Panduan Kesehatan" class="h-20 w-20 mx-auto">                        </div>
                        <h3 class="text-xl font-semibold text-brand-navy mb-3 font-display">Panduan Kesehatan</h3>
                        <p class="text-sm text-brand-gray-600 leading-relaxed">
                            Dapatkan panduan praktis untuk memantau dan mengelola kondisi diabetes Anda sehari-hari.
                        </p>
                    </div>
                </div>
                {{-- Feature 2: Artikel --}}
                <div class="premium-card text-center reveal-on-scroll" style="animation-delay: 0.1s;">
                    <div class="p-6 md:p-8">
                        <div class="mb-4 inline-block">
                            {{-- Placeholder for icon like 'article-icon.png' --}}
                            <img src="{{ asset('images/gambar3.png') }}" alt="Artikel Edukasi" class="h-20 w-20 mx-auto">
                        </div>
                        <h3 class="text-xl font-semibold text-brand-navy mb-3 font-display">Artikel Edukasi</h3>
                        <p class="text-sm text-brand-gray-600 leading-relaxed">
                            Akses informasi terkini dan terpercaya seputar diabetes, pencegahan, dan pengelolaannya.
                        </p>
                    </div>
                </div>
                {{-- Feature 3: Inner Circle (adapted to Support/Community Info) --}}
                <div class="premium-card text-center reveal-on-scroll" style="animation-delay: 0.2s;">
                    <div class="p-6 md:p-8">
                        <div class="mb-4 inline-block">
                            {{-- Placeholder for icon like 'group-SJA0IYtTM.png' --}}
                            <img src="{{ asset('images/gambar4.png') }}" alt="Tips Gaya Hidup" class="h-20 w-20 mx-auto">
                        </div>
                        <h3 class="text-xl font-semibold text-brand-navy mb-3 font-display">Tips Gaya Hidup Sehat</h3>
                        <p class="text-sm text-brand-gray-600 leading-relaxed">
                            Temukan saran mengenai pola makan, olahraga, dan aspek gaya hidup lainnya untuk penderita diabetes.
                        </p>
                    </div>
                </div>
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
                        {{-- Gunakan $article->main_image_url atau placeholder jika kosong --}}
                        <img src="{{ $article->main_image_url ?: 'https://placehold.co/400x250/EBF4FF/1A365D?text=Artikel+' . $loop->iteration }}" alt="{{ $article->title }}" class="w-full h-56 object-cover transform group-hover:scale-105 transition-transform duration-300">
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

    {{-- Two Column Feature Section (Inspired by Teman Diabetes "Features" section, adapted for information) --}}
    <section class="py-16 lg:py-24 bg-brand-blue-50">
        <div class="container mx-auto px-4">
            {{-- Feature Row 1 --}}
            <div class="grid md:grid-cols-2 gap-12 items-center mb-12 lg:mb-20">
                <div class="reveal-on-scroll">
                    {{-- Placeholder for image like 'Group-14-new.png' --}}
                    <img src="{{ asset('images/gambar5.png') }}" alt="Monitor Gula Darah Anda" class="rounded-xl shadow-elegant w-full">
                </div>
                <div class="reveal-on-scroll" style="animation-delay: 0.15s;">
                    <span class="inline-block text-sm font-semibold text-brand-primary-DEFAULT uppercase tracking-wider mb-2">Pentingnya Pemantauan</span>
                    <h2 class="text-3xl md:text-4xl font-bold text-brand-navy mb-6 font-display">Memahami Kadar Gula Darah</h2>
                    <p class="text-brand-gray-700 leading-relaxed mb-4 text-base md:text-lg">
                        Pelajari mengapa pemantauan gula darah secara teratur sangat krusial dalam manajemen diabetes. Kami menyediakan informasi mengenai cara membaca hasil dan apa artinya bagi kesehatan Anda.
                    </p>
                    <p class="text-brand-gray-700 leading-relaxed mb-6 text-base md:text-lg">
                        Temukan artikel tentang berbagai metode pemantauan dan teknologi terkini yang dapat membantu.
                    </p>
                    {{-- Optional: Link to relevant category or article --}}
                    {{-- <a href="#" class="btn-secondary text-sm px-6 py-2.5">Pelajari Pemantauan</a> --}}
                </div>
            </div>

            {{-- Feature Row 2 (Reversed order for visual variety) --}}
            <div class="grid md:grid-cols-2 gap-12 items-center">
                <div class="md:order-2 reveal-on-scroll">
                        {{-- Placeholder for image like 'new-mockup@2x.png' (perhaps a collage of health info) --}}
                    <img src="{{ asset('images/gambar6.png') }}" alt="Manajemen Diabetes yang Mudah" class="rounded-xl shadow-elegant w-full">
                </div>
                <div class="md:order-1 reveal-on-scroll" style="animation-delay: 0.15s;">
                    <span class="inline-block text-sm font-semibold text-brand-primary-DEFAULT uppercase tracking-wider mb-2">Manajemen Efektif</span>
                    <h2 class="text-3xl md:text-4xl font-bold text-brand-navy mb-6 font-display">Kelola Diabetes dengan Percaya Diri</h2>
                    <p class="text-brand-gray-700 leading-relaxed mb-4 text-base md:text-lg">
                        DiabetaCare membantu Anda memahami aspek-aspek penting manajemen diabetes, mulai dari diet, olahraga, hingga pengelolaan stres.
                    </p>
                    <p class="text-brand-gray-700 leading-relaxed mb-6 text-base md:text-lg">
                        Akses panduan dan tips yang mudah diikuti untuk membantu Anda atau orang terkasih menjalani hidup lebih baik dengan diabetes.
                    </p>
                        {{-- <div class="flex space-x-4 mt-4">
                            <img src="https://placehold.co/50x50/BEE3F8/2C5282?text=i1" alt="Icon 1" class="h-12">
                            <img src="https://placehold.co/50x50/B2F5EA/2C7A7B?text=i2" alt="Icon 2" class="h-12">
                            <img src="https://placehold.co/50x50/C6F6D5/2F855A?text=i3" alt="Icon 3" class="h-12">
                        </div> --}}
                </div>
            </div>
        </div>
    </section>


    {{-- About Us Snippet Section (Already in your blade, keeping it) --}}
    <section class="py-16 lg:py-24 bg-white"> {{-- Changed background to white for variety --}}
        <div class="container mx-auto px-4">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
                <div class="reveal-on-scroll">
                    <img src="{{ asset('images/gambar7.png') }}" alt="Tentang DiabetaCare" class="rounded-xl shadow-elegant w-full">
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

    {{-- Call to Action (jika ada aplikasi mobile - from your original blade, kept commented) --}}
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

    {{-- A section for "Beragam Fitur Menarik" from Teman Diabetes, adapted to "Topik Populer" or "Kategori Utama" if no screenshots of website --}}
    <section class="py-16 lg:py-24 bg-brand-gray-100">
        <div class="container mx-auto px-4">
            <div class="text-center mb-12 md:mb-16">
                <span class="inline-block text-sm font-semibold text-brand-primary-DEFAULT uppercase tracking-wider mb-2">Jelajahi Lebih Lanjut</span>
                <h2 class="text-3xl md:text-4xl font-bold text-brand-navy mb-4 font-display">Kategori Topik Populer</h2>
                <p class="text-brand-gray-600 max-w-xl mx-auto text-base md:text-lg">
                    Temukan informasi mendalam mengenai berbagai aspek penting dalam perjalanan diabetes Anda.
                </p>
            </div>
            {{-- This would ideally be a dynamic list of categories or curated links. Using placeholders for now. --}}
            {{-- Replaces the Owl Carousel screenshot slider --}}
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
              @php
    $popularTopics = [
        ['title' => 'Dasar-Dasar Diabetes', 'image_placeholder' => asset('images/gambar8.png'), 'description' => 'Pahami jenis, gejala, dan diagnosis awal diabetes.'],
        ['title' => 'Pola Makan Sehat', 'image_placeholder' => asset('images/gambar9.png'), 'description' => 'Rencanakan diet seimbang untuk mengontrol gula darah.'],
        ['title' => 'Aktivitas Fisik', 'image_placeholder' => asset('images/gambar10.png'), 'description' => 'Manfaat olahraga dan tips memulai rutinitas aman.'],
        ['title' => 'Komplikasi Diabetes', 'image_placeholder' => asset('images/gambar11.png'), 'description' => 'Kenali dan cegah potensi komplikasi jangka panjang.'],
    ];
@endphp
                @foreach($popularTopics as $topic)
                <div class="premium-card flex flex-col reveal-on-scroll">
                    <a href="#" class="block overflow-hidden rounded-t-xl group"> {{-- Link to category page later --}}
                        <img src="{{ $topic['image_placeholder'] }}" alt="{{ $topic['title'] }}" class="w-full h-40 object-cover transform group-hover:scale-105 transition-transform duration-300">
                    </a>
                    <div class="p-5 flex flex-col flex-grow">
                        <h3 class="text-lg font-semibold text-brand-navy mb-2 font-display leading-tight">
                            <a href="#" class="hover:text-brand-primary-DEFAULT transition-colors">{{ $topic['title'] }}</a>
                        </h3>
                        <p class="text-xs text-brand-gray-600 leading-relaxed mb-3 flex-grow">
                            {{ $topic['description'] }}
                        </p>
                        <div class="mt-auto">
                            <a href="#" class="font-semibold text-brand-primary-DEFAULT hover:text-brand-primary-dark text-xs inline-flex items-center group/link">
                                Selengkapnya <i class="ri-arrow-right-s-line ml-1 group-hover/link:translate-x-1 transition-transform"></i>
                            </a>
                        </div>
                    </div>
                </div>
                @endforeach
            </div>
        </div>
    </section>

{{-- Beragam Fitur Menarik Section --}}
<section id="beragam-fitur" class="py-16 lg:py-24 bg-white">
    <div class="container mx-auto px-4">
        <div class="text-center mb-12 md:mb-16 aos-init aos-animate" data-aos="fade-up" data-aos-delay="600">
            <h3 class="text-3xl md:text-4xl font-bold text-brand-navy mb-4 font-display">Beragam Fitur Menarik</h3>
            <p class="text-brand-gray-600 max-w-xl mx-auto text-base md:text-lg">Anda akan dipermudah dengan fitur-fitur andalan DiabetaCare.</p>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6 aos-init aos-animate" data-aos="fade-up" data-aos-delay="200">
            @php
                // Array $siteFeatures hanya memerlukan title (untuk alt text) dan image_placeholder
                $siteFeatures = [
                    [
                        'title' => 'Contoh Fitur Visual 1', // Digunakan untuk alt text gambar
                        'image_placeholder' => 'https://placehold.co/300x200/A7F3D0/047857?text=Fitur+1'
                    ],
                    [
                        'title' => 'Contoh Fitur Visual 2', // Digunakan untuk alt text gambar
                        'image_placeholder' => 'https://placehold.co/300x200/BAE6FD/0369A1?text=Fitur+2'
                    ],
                    [
                        'title' => 'Contoh Fitur Visual 3', // Digunakan untuk alt text gambar
                        'image_placeholder' => 'https://placehold.co/300x200/FDE68A/92400E?text=Fitur+3'
                    ],
                    [
                        'title' => 'Contoh Fitur Visual 4', // Digunakan untuk alt text gambar
                        'image_placeholder' => 'https://placehold.co/300x200/DDD6FE/5B21B6?text=Fitur+4'
                    ],
                ];
            @endphp
            @foreach($siteFeatures as $feature)
            <div class="premium-card reveal-on-scroll overflow-hidden"> {{-- Kartu hanya berisi gambar. overflow-hidden agar gambar mengikuti lengkungan kartu --}}
                <img src="{{ $feature['image_placeholder'] }}" 
                     alt="{{ $feature['title'] }}" 
                     class="w-full h-80 object-cover"> {{-- Menghilangkan transform class karena tidak ada grup hover link --}}
            </div>
            @endforeach
        </div>
    </div>
</section>

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

    /* Additional styling for premium cards if needed */
    .premium-card {
        background-color: #fff;
        border-radius: 0.75rem; /* 12px */
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }
    .premium-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
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
                    // Mengambil delay dari style.animationDelay atau data-delay atau default ke 0s
                    const delay = entry.target.style.animationDelay || entry.target.dataset.delay || '0s';
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