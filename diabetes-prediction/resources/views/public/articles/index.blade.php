@extends('layouts.public_layout')

@section('title', 'Artikel Edukasi Diabetes - DiabetaCare')
@section('meta_description', 'Temukan kumpulan artikel edukasi, tips, dan panduan terbaru mengenai pencegahan, pengelolaan, dan hidup sehat dengan diabetes dari DiabetaCare.')
@section('meta_keywords', 'artikel diabetes, info diabetes, edukasi diabetes, tips diabetes, panduan diabetes, hidup sehat dengan diabetes')

@section('content')
<div class="container mx-auto py-12 sm:py-16">
    {{-- Header Halaman --}}
    <div class="text-center mb-12 px-4">
        <h1 class="text-4xl md:text-5xl font-bold text-brand-navy mb-4 font-display">Artikel Edukasi</h1>
        <p class="text-lg text-brand-gray-600 max-w-2xl mx-auto">
            Jelajahi koleksi artikel kami untuk mendapatkan wawasan mendalam dan tips praktis seputar diabetes.
        </p>
    </div>

    {{-- Filter dan Pencarian --}}
    <div class="mb-10 px-4">
        <form action="{{ route('public.articles.index') }}" method="GET" class="bg-white p-6 rounded-xl shadow-soft border border-brand-gray-200">
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 items-end">
                <div>
                    <label for="search" class="block text-sm font-medium text-brand-gray-700 mb-1">Cari Artikel</label>
                    <div class="relative">
                        <input type="text" name="search" id="search" value="{{ $search ?? '' }}" placeholder="Masukkan kata kunci..."
                               class="w-full pl-10 pr-4 py-2.5 border border-brand-gray-300 rounded-lg focus:ring-brand-primary-DEFAULT focus:border-brand-primary-DEFAULT transition duration-150 ease-in-out text-sm">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                            <i class="ri-search-line text-brand-gray-400"></i>
                        </span>
                    </div>
                </div>
                <div>
                    <label for="category" class="block text-sm font-medium text-brand-gray-700 mb-1">Filter Kategori</label>
                    <select name="category" id="category"
                            class="w-full px-4 py-2.5 border border-brand-gray-300 rounded-lg focus:ring-brand-primary-DEFAULT focus:border-brand-primary-DEFAULT transition duration-150 ease-in-out text-sm">
                        <option value="">Semua Kategori</option>
                        @if(isset($categories) && $categories->count() > 0)
                            @foreach ($categories as $cat)
                                <option value="{{ $cat }}" {{ ($category ?? '') == $cat ? 'selected' : '' }}>{{ $cat }}</option>
                            @endforeach
                        @endif
                    </select>
                </div>
                <div class="flex items-center space-x-2">
                    <button type="submit" class="btn-primary w-full md:w-auto text-sm py-2.5 justify-center">
                        <i class="ri-filter-3-line mr-2"></i>Terapkan Filter
                    </button>
                    @if(request()->has('search') || request()->has('category'))
                        <a href="{{ route('public.articles.index') }}" class="w-full md:w-auto inline-flex justify-center items-center px-4 py-2.5 border border-brand-gray-300 text-sm font-medium rounded-lg text-brand-gray-700 bg-white hover:bg-brand-gray-50 transition">
                            Reset
                        </a>
                    @endif
                </div>
            </div>
        </form>
    </div>

    {{-- Daftar Artikel --}}
    @if(isset($articles) && $articles->count() > 0)
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 px-4">
            @foreach ($articles as $article)
            <div class="premium-card flex flex-col"> {{-- Menggunakan kelas .premium-card dari layout --}}
                <a href="{{ route('public.articles.show', $article->slug) }}">
                    <img src="{{ $article->main_image_url }}" alt="{{ $article->title }}" class="w-full h-56 object-cover">
                </a>
                <div class="p-6 flex flex-col flex-grow">
                    @if($article->category)
                    <span class="inline-block bg-brand-blue-100 text-brand-blue-700 text-xs font-semibold px-3 py-1 rounded-full mb-3 self-start">{{ $article->category }}</span>
                    @endif
                    <h3 class="text-lg font-semibold text-brand-navy mb-2 font-display leading-tight">
                        <a href="{{ route('public.articles.show', $article->slug) }}" class="hover:text-brand-primary-DEFAULT transition-colors">
                            {{ Str::limit($article->title, 65) }}
                        </a>
                    </h3>
                    <p class="text-sm text-brand-gray-600 leading-relaxed mb-4 flex-grow">
                        {{ Str::limit(strip_tags($article->content), 110) }}
                    </p>
                    <div class="mt-auto pt-4 border-t border-brand-gray-200">
                         <div class="flex items-center justify-between text-xs text-brand-gray-500">
                            <span>
                                <i class="ri-calendar-line mr-1 text-brand-accent"></i>
                                {{ $article->published_at ? $article->published_at->translatedFormat('d M Y') : 'N/A' }}
                            </span>
                            <a href="{{ route('public.articles.show', $article->slug) }}" class="font-medium text-brand-primary-DEFAULT hover:text-brand-primary-dark inline-flex items-center">
                                Baca Selengkapnya <i class="ri-arrow-right-s-line ml-1"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
            @endforeach
        </div>

        {{-- Pagination Links --}}
        <div class="mt-12 px-4">
            {{ $articles->appends(request()->query())->links() }}
        </div>
    @else
        <div class="text-center py-12 px-4">
            <div class="mx-auto w-20 h-20 mb-6">
                <svg class="text-brand-gray-300" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm1-11a1 1 0 10-2 0v2H7a1 1 0 100 2h2v2a1 1 0 102 0v-2h2a1 1 0 100-2h-2V7z" clip-rule="evenodd"></path></svg>
            </div>
            <h3 class="text-xl font-semibold text-brand-gray-700 mb-2">Belum Ada Artikel</h3>
            <p class="text-brand-gray-500">
                @if(request()->has('search') || request()->has('category'))
                    Tidak ada artikel yang cocok dengan kriteria pencarian atau filter Anda. Coba kata kunci atau kategori lain.
                    <a href="{{ route('public.articles.index') }}" class="text-brand-primary-DEFAULT hover:underline mt-2 inline-block">Lihat Semua Artikel</a>
                @else
                    Saat ini belum ada artikel edukasi yang dipublikasikan. Silakan cek kembali nanti.
                @endif
            </p>
        </div>
    @endif
</div>
@endsection
