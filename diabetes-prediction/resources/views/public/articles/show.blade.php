@extends('layouts.public_layout')

{{-- Judul halaman akan diambil dari judul artikel --}}
@section('title', $article->title . ' - DiabetaCare')
{{-- Meta description akan diambil dari meta_description artikel atau potongan konten --}}
@section('meta_description', Str::limit(strip_tags($article->meta_description ?? $article->content), 160))
{{-- Meta keywords bisa diambil dari field meta_keywords artikel --}}
@section('meta_keywords', $article->meta_keywords ?? 'diabetes, ' . $article->category ?? '' . ', kesehatan')
{{-- Gambar Open Graph akan diambil dari gambar utama artikel --}}
@section('og_image', $article->main_image_url ?? asset('images/diabetacare_og_blue_default.jpg'))


@section('content')
<div class="container mx-auto py-12 sm:py-16">
    <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 px-4">

        {{-- Kolom Konten Utama Artikel --}}
        <article class="lg:col-span-8 bg-white p-6 sm:p-8 rounded-xl shadow-soft border border-brand-gray-200">
            {{-- Judul Artikel --}}
            <h1 class="text-3xl sm:text-4xl font-bold text-brand-navy mb-3 font-display leading-tight">
                {{ $article->title }}
            </h1>

            {{-- Meta Info Artikel --}}
            <div class="mb-6 text-sm text-brand-gray-500 flex flex-wrap items-center gap-x-4 gap-y-1">
                @if($article->category)
                <span class="inline-flex items-center">
                    <i class="ri-price-tag-3-line mr-1.5 text-brand-accent"></i> Kategori:
                    <a href="{{ route('public.articles.index', ['category' => $article->category]) }}" class="ml-1 font-medium text-brand-primary-DEFAULT hover:text-brand-primary-dark">{{ $article->category }}</a>
                </span>
                @endif
                <span class="inline-flex items-center">
                    <i class="ri-calendar-event-line mr-1.5 text-brand-accent"></i> Dipublikasikan:
                    <span class="ml-1 font-medium text-brand-gray-700">{{ $article->published_at ? $article->published_at->translatedFormat('d F Y') : 'N/A' }}</span>
                </span>
                @if($article->author_name)
                <span class="inline-flex items-center">
                    <i class="ri-user-line mr-1.5 text-brand-accent"></i> Penulis:
                    <span class="ml-1 font-medium text-brand-gray-700">{{ $article->author_name }}</span>
                </span>
                @endif
            </div>

            {{-- Gambar Utama Artikel --}}
            @if($article->main_image_path)
                <div class="mb-8 rounded-lg overflow-hidden shadow-md">
                    <img src="{{ $article->main_image_url }}" alt="Gambar utama untuk {{ $article->title }}" class="w-full h-auto object-cover max-h-[500px]">
                </div>
            @endif

            {{-- Konten Artikel --}}
            {{-- Kelas 'prose' dari Tailwind Typography akan mengatur styling dasar konten --}}
            <div class="prose prose-lg max-w-none text-brand-gray-700 leading-relaxed">
                {!! $article->content !!} {{-- Menggunakan {!! !!} jika konten adalah HTML. Pastikan konten aman! --}}
            </div>

            {{-- Tombol Share (Opsional) --}}
            <div class="mt-10 pt-6 border-t border-brand-gray-200">
                <h3 class="text-md font-semibold text-brand-gray-700 mb-3">Bagikan Artikel Ini:</h3>
                <div class="flex space-x-3">
                    <a href="https://www.facebook.com/sharer/sharer.php?u={{ urlencode(url()->current()) }}" target="_blank" rel="noopener noreferrer"
                       class="inline-flex items-center justify-center w-10 h-10 rounded-full bg-blue-600 text-white hover:bg-blue-700 transition-colors" title="Bagikan ke Facebook">
                        <i class="ri-facebook-fill text-xl"></i>
                    </a>
                    <a href="https://twitter.com/intent/tweet?url={{ urlencode(url()->current()) }}&text={{ urlencode($article->title) }}" target="_blank" rel="noopener noreferrer"
                       class="inline-flex items-center justify-center w-10 h-10 rounded-full bg-sky-500 text-white hover:bg-sky-600 transition-colors" title="Bagikan ke X (Twitter)">
                        <i class="ri-twitter-x-line text-xl"></i>
                    </a>
                    <a href="https://api.whatsapp.com/send?text={{ urlencode($article->title . ' - ' . url()->current()) }}" target="_blank" rel="noopener noreferrer"
                       class="inline-flex items-center justify-center w-10 h-10 rounded-full bg-green-500 text-white hover:bg-green-600 transition-colors" title="Bagikan ke WhatsApp">
                        <i class="ri-whatsapp-line text-xl"></i>
                    </a>
                    <a href="mailto:?subject={{ urlencode($article->title) }}&body={{ urlencode('Saya menemukan artikel menarik ini: ' . url()->current()) }}"
                       class="inline-flex items-center justify-center w-10 h-10 rounded-full bg-brand-gray-500 text-white hover:bg-brand-gray-600 transition-colors" title="Bagikan via Email">
                        <i class="ri-mail-line text-xl"></i>
                    </a>
                </div>
            </div>
        </article>

        {{-- Kolom Sidebar (Artikel Terkait/Terbaru) --}}
        <aside class="lg:col-span-4 space-y-8">
            {{-- Pencarian (Opsional di halaman detail) --}}
            {{-- <div class="bg-white p-6 rounded-xl shadow-soft border border-brand-gray-200">
                <h3 class="text-lg font-semibold text-brand-navy mb-3 font-display">Cari Artikel</h3>
                <form action="{{ route('public.articles.index') }}" method="GET">
                    <div class="relative">
                        <input type="text" name="search" placeholder="Kata kunci..."
                               class="w-full pl-10 pr-4 py-2.5 border border-brand-gray-300 rounded-lg focus:ring-brand-primary-DEFAULT focus:border-brand-primary-DEFAULT text-sm">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                            <i class="ri-search-line text-brand-gray-400"></i>
                        </span>
                    </div>
                    <button type="submit" class="mt-3 w-full btn-primary text-sm py-2.5 justify-center">Cari</button>
                </form>
            </div> --}}

            @if(isset($relatedArticles) && $relatedArticles->count() > 0)
            <div class="bg-white p-6 rounded-xl shadow-soft border border-brand-gray-200">
                <h3 class="text-lg font-semibold text-brand-navy mb-4 font-display">Artikel Terkait Lainnya</h3>
                <div class="space-y-5">
                    @foreach($relatedArticles as $related)
                    <div class="flex items-start space-x-3 group">
                        <a href="{{ route('public.articles.show', $related->slug) }}" class="flex-shrink-0">
                            <img src="{{ $related->main_image_url }}" alt="{{ $related->title }}" class="w-20 h-16 object-cover rounded-md border border-brand-gray-200 group-hover:opacity-80 transition-opacity">
                        </a>
                        <div>
                            <h4 class="text-sm font-semibold text-brand-gray-800 leading-tight mb-1">
                                <a href="{{ route('public.articles.show', $related->slug) }}" class="group-hover:text-brand-primary-DEFAULT transition-colors">
                                    {{ Str::limit($related->title, 50) }}
                                </a>
                            </h4>
                            <p class="text-xs text-brand-gray-500">
                                <i class="ri-calendar-line mr-1"></i>
                                {{ $related->published_at ? $related->published_at->translatedFormat('d M Y') : '' }}
                            </p>
                        </div>
                    </div>
                    @endforeach
                </div>
            </div>
            @endif

            {{-- Kategori (Opsional) --}}
            @if(isset($categories) && $categories->count() > 0) {{-- Anda perlu mengirimkan $categories dari controller jika ingin menampilkan ini --}}
            <div class="bg-white p-6 rounded-xl shadow-soft border border-brand-gray-200">
                <h3 class="text-lg font-semibold text-brand-navy mb-4 font-display">Kategori Artikel</h3>
                <ul class="space-y-2">
                    @foreach($categories as $cat)
                    <li>
                        <a href="{{ route('public.articles.index', ['category' => $cat]) }}"
                           class="flex justify-between items-center text-sm text-brand-gray-600 hover:text-brand-primary-DEFAULT hover:bg-brand-blue-50 p-2 rounded-md transition-colors">
                            <span>{{ $cat }}</span>
                            <i class="ri-arrow-right-s-line text-brand-gray-400"></i>
                        </a>
                    </li>
                    @endforeach
                </ul>
            </div>
            @endif

        </aside>
    </div>
</div>
@endsection

@push('styles')
{{-- Jika Anda menggunakan Tailwind Typography plugin, pastikan sudah di-load di layout utama atau di sini --}}
{{-- <link href="https://cdn.jsdelivr.net/npm/@tailwindcss/typography@0.5.x/dist/typography.min.css" rel="stylesheet"> --}}
@endpush
