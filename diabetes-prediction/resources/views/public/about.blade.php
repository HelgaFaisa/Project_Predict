@extends('layouts.public_layout')

@section('title', 'Tentang DiabetaCare - Misi Kami untuk Kesehatan Diabetes')
@section('meta_description', 'Pelajari lebih lanjut tentang DiabetaCare, tim kami, dan komitmen kami untuk menyediakan informasi serta dukungan terbaik bagi individu yang hidup dengan diabetes.')
@section('meta_keywords', 'tentang diabetacare, misi diabetacare, tim diabetacare, perawatan diabetes, informasi kesehatan')
{{-- @section('og_image', asset('images/diabetacare_og_about.jpg')) --}} {{-- Ganti dengan gambar spesifik jika ada --}}

@section('content')
<div class="bg-white">
    {{-- Section Hero Tentang Kami --}}
    <section class="py-16 md:py-24 bg-gradient-to-br from-brand-blue-500 to-brand-blue-700 text-Gray">
        <div class="container mx-auto text-center px-4">
            <h1 class="text-4xl sm:text-5xl font-bold mb-4 font-display">Tentang DiabetaCare</h1>
            <p class="text-lg sm:text-xl max-w-3xl mx-auto opacity-90">
                Memberdayakan Anda dengan pengetahuan dan dukungan untuk perjalanan manajemen diabetes yang lebih baik.
            </p>
        </div>
    </section>

    {{-- Section Misi Kami --}}
    <section class="py-16 md:py-20">
        <div class="container mx-auto px-4">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-12 items-center">
                <div class="order-2 md:order-1">
                    <span class="inline-block text-sm font-semibold text-brand-primary-DEFAULT uppercase tracking-wider mb-2">Misi Kami</span>
                    <h2 class="text-3xl md:text-4xl font-bold text-brand-navy mb-6 font-display">Dedikasi untuk Kesehatan Anda</h2>
                    <p class="text-brand-gray-700 leading-relaxed mb-4">
                        Di DiabetaCare, kami percaya bahwa setiap individu berhak mendapatkan akses ke informasi kesehatan yang akurat, mudah dipahami, dan terkini, terutama dalam menghadapi kondisi kronis seperti diabetes. Misi kami adalah menjadi mitra terpercaya Anda dalam perjalanan mengelola diabetes, dengan menyediakan platform edukasi komprehensif yang didukung oleh para ahli.
                    </p>
                    <p class="text-brand-gray-700 leading-relaxed mb-6">
                        Kami berkomitmen untuk terus berinovasi dalam menyajikan konten yang relevan, praktis, dan memberdayakan, sehingga Anda dapat membuat keputusan yang lebih baik untuk kesehatan Anda dan meningkatkan kualitas hidup Anda sehari-hari.
                    </p>
                    <a href="{{ route('public.articles.index') }}" class="btn-primary inline-flex items-center">
                        Jelajahi Artikel Kami <i class="ri-arrow-right-line ml-2"></i>
                    </a>
                </div>
                <div class="order-1 md:order-2">
                    <img src="https://placehold.co/600x500/E0EFFF/1E40AF?text=Tim+DiabetaCare" alt="Tim DiabetaCare sedang berdiskusi" class="rounded-xl shadow-elegant w-full">
                    {{-- Ganti dengan URL gambar tim Anda atau ilustrasi yang relevan --}}
                </div>
            </div>
        </div>
    </section>

    {{-- Section Nilai-Nilai Kami --}}
    <section class="py-16 md:py-20 bg-brand-blue-50">
        <div class="container mx-auto px-4">
            <div class="text-center mb-12">
                <span class="inline-block text-sm font-semibold text-brand-primary-DEFAULT uppercase tracking-wider mb-2">Fondasi Kami</span>
                <h2 class="text-3xl md:text-4xl font-bold text-brand-navy mb-4 font-display">Nilai-Nilai yang Kami Anut</h2>
                <p class="text-brand-gray-600 max-w-2xl mx-auto">
                    Prinsip-prinsip ini memandu setiap aspek pekerjaan kami di DiabetaCare.
                </p>
            </div>
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
                <div class="bg-white p-8 rounded-xl shadow-soft border border-brand-gray-200 text-center hover:shadow-elegant transition-shadow duration-300">
                    <div class="inline-flex items-center justify-center w-16 h-16 blue-gradient-bg text-white rounded-full mb-6 shadow-md">
                        <i class="ri-shield-check-line text-3xl"></i>
                    </div>
                    <h3 class="text-xl font-semibold text-brand-navy mb-2 font-display">Kepercayaan & Akurasi</h3>
                    <p class="text-sm text-brand-gray-600 leading-relaxed">
                        Kami menyajikan informasi yang diverifikasi dan bersumber dari penelitian serta pedoman medis terkini.
                    </p>
                </div>
                <div class="bg-white p-8 rounded-xl shadow-soft border border-brand-gray-200 text-center hover:shadow-elegant transition-shadow duration-300">
                    <div class="inline-flex items-center justify-center w-16 h-16 blue-gradient-bg text-white rounded-full mb-6 shadow-md">
                        <i class="ri-lightbulb-flash-line text-3xl"></i>
                    </div>
                    <h3 class="text-xl font-semibold text-brand-navy mb-2 font-display">Pemberdayaan & Edukasi</h3>
                    <p class="text-sm text-brand-gray-600 leading-relaxed">
                        Kami percaya pengetahuan adalah kunci. Kami bertujuan memberdayakan Anda untuk mengambil peran aktif dalam kesehatan Anda.
                    </p>
                </div>
                <div class="bg-white p-8 rounded-xl shadow-soft border border-brand-gray-200 text-center hover:shadow-elegant transition-shadow duration-300">
                    <div class="inline-flex items-center justify-center w-16 h-16 blue-gradient-bg text-white rounded-full mb-6 shadow-md">
                        <i class="ri-team-line text-3xl"></i>
                    </div>
                    <h3 class="text-xl font-semibold text-brand-navy mb-2 font-display">Dukungan & Komunitas</h3>
                    <p class="text-sm text-brand-gray-600 leading-relaxed">
                        Anda tidak sendirian. Kami berusaha membangun platform yang suportif dan informatif bagi semua.
                    </p>
                </div>
            </div>
        </div>
    </section>

    {{-- Section Tim Kami (Opsional Sederhana) --}}
    <section class="py-16 md:py-20">
        <div class="container mx-auto px-4">
            <div class="text-center mb-12">
                 <span class="inline-block text-sm font-semibold text-brand-primary-DEFAULT uppercase tracking-wider mb-2">Bertemu Tim</span>
                <h2 class="text-3xl md:text-4xl font-bold text-brand-navy mb-4 font-display">Figur di Balik DiabetaCare</h2>
                <p class="text-brand-gray-600 max-w-2xl mx-auto">
                    Kami adalah tim profesional yang berdedikasi untuk meningkatkan kualitas hidup penderita diabetes.
                </p>
            </div>
            {{-- Contoh Placeholder Tim --}}
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8 max-w-4xl mx-auto">
                <div class="text-center">
                    <img src="https://placehold.co/200x200/E0EFFF/1E40AF?text=Dr.%20A" alt="Foto Dr. Ahli Diabetes" class="w-32 h-32 rounded-full mx-auto mb-4 shadow-md border-4 border-white">
                    <h4 class="text-lg font-semibold text-brand-navy">Dr. Ahli Diabetes, Sp.PD-KEMD</h4>
                    <p class="text-sm text-brand-primary-DEFAULT">Kepala Penasihat Medis</p>
                </div>
                <div class="text-center">
                    <img src="https://placehold.co/200x200/E0EFFF/1E40AF?text=Nutrisionis%20B" alt="Foto Nutrisionis" class="w-32 h-32 rounded-full mx-auto mb-4 shadow-md border-4 border-white">
                    <h4 class="text-lg font-semibold text-brand-navy">Nutrisionis Cerdas, S.Gz</h4>
                    <p class="text-sm text-brand-primary-DEFAULT">Spesialis Gizi Diabetes</p>
                </div>
                <div class="text-center">
                    <img src="https://placehold.co/200x200/E0EFFF/1E40AF?text=Tech%20Lead" alt="Foto Pengembang Utama" class="w-32 h-32 rounded-full mx-auto mb-4 shadow-md border-4 border-white">
                    <h4 class="text-lg font-semibold text-brand-navy">Pengembang Inovatif, S.Kom</h4>
                    <p class="text-sm text-brand-primary-DEFAULT">Pengembang Utama Platform</p>
                </div>
            </div>
            {{-- Anda bisa menambahkan lebih banyak anggota tim atau detail jika diperlukan --}}
        </div>
    </section>

     {{-- Call to Action untuk Kontak --}}
    <section class="py-16 bg-brand-blue-50">
        <div class="container mx-auto text-center px-4">
            <h2 class="text-3xl font-bold text-brand-navy mb-6 font-display">Punya Pertanyaan atau Masukan?</h2>
            <p class="text-brand-gray-600 max-w-xl mx-auto mb-8">
                Kami senang mendengar dari Anda. Jangan ragu untuk menghubungi kami jika Anda memiliki pertanyaan, saran, atau ingin berkolaborasi.
            </p>
            <a href="mailto:info@diabetacare.id" class="btn-primary inline-flex items-center">
                <i class="ri-mail-send-line mr-2"></i> Hubungi Kami Sekarang
            </a>
            {{-- Atau jika Anda punya halaman kontak khusus:
            <a href="{{ route('public.contact') }}" class="btn-primary inline-flex items-center">
                <i class="ri-message-2-line mr-2"></i> Hubungi Kami
            </a>
            --}}
        </div>
    </section>

</div>
@endsection
