@extends('layouts.app')

@section('title', 'Detail Artikel: ' . Str::limit($educationArticle->title, 30))
@section('page-title', 'Detail Artikel Edukasi')

@section('content')
<div class="bg-white rounded-xl shadow p-6 md:p-8 border border-gray-200">
    <div class="mb-6 pb-4 border-b border-gray-200">
        <div class="flex flex-col sm:flex-row justify-between items-start gap-4">
            <div>
                <h1 class="text-2xl lg:text-3xl font-bold text-gray-800 mb-2">{{ $educationArticle->title }}</h1>
                <div class="text-xs sm:text-sm text-gray-500 space-x-2">
                    <span>Kategori: <strong class="text-gray-700">{{ $educationArticle->category ?? 'Tidak ada kategori' }}</strong></span>
                    <span class="hidden sm:inline">|</span>
                    <span class="block sm:inline mt-1 sm:mt-0">Status:
                        <span class="{{ $educationArticle->status == 'published' ? 'text-green-600 font-semibold' : 'text-yellow-700 font-semibold' }}">
                            {{ $educationArticle->status == 'published' ? 'Diterbitkan' : 'Draft' }}
                        </span>
                    </span>
                    <span class="hidden sm:inline">|</span>
                    <span class="block sm:inline mt-1 sm:mt-0">Publikasi: <strong class="text-gray-700">{{ $educationArticle->published_at ? $educationArticle->published_at->translatedFormat('d M Y, H:i') : 'Belum dipublikasikan' }}</strong></span>
                    @if($educationArticle->author_name)
                        <span class="hidden sm:inline">|</span>
                        <span class="block sm:inline mt-1 sm:mt-0">Penulis: <strong class="text-gray-700">{{ $educationArticle->author_name }}</strong></span>
                    @endif
                </div>
            </div>
            <a href="{{ route('admin.education.edit', $educationArticle) }}" class="w-full sm:w-auto mt-2 sm:mt-0 shrink-0 inline-flex items-center justify-center px-4 py-2 bg-indigo-600 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-indigo-700">
                <i class="ri-pencil-line mr-2"></i>Edit Artikel
            </a>
        </div>
    </div>

    @if($educationArticle->main_image_path)
        <div class="mb-6">
            <img src="{{ $educationArticle->main_image_url }}" alt="Gambar Utama: {{ $educationArticle->title }}" class="w-full max-w-2xl mx-auto h-auto object-cover rounded-lg shadow">
        </div>
    @endif

    <div class="prose prose-sm sm:prose-base lg:prose-lg xl:prose-xl max-w-none text-gray-700 leading-relaxed">
        {!! $educationArticle->content !!}
    </div>

    @if($educationArticle->meta_description || $educationArticle->meta_keywords)
    <div class="mt-8 pt-6 border-t border-gray-200">
        <h3 class="text-md font-semibold text-gray-700 mb-2">Informasi SEO Tambahan</h3>
        @if($educationArticle->meta_description)
        <p class="text-sm text-gray-600"><strong>Meta Deskripsi:</strong><br>{{ $educationArticle->meta_description }}</p>
        @endif
        @if($educationArticle->meta_keywords)
        <p class="text-sm text-gray-600 mt-2"><strong>Meta Keywords:</strong><br>{{ $educationArticle->meta_keywords }}</p>
        @endif
    </div>
    @endif

    <div class="mt-8 pt-6 border-t border-gray-200">
        <a href="{{ route('admin.education.index') }}" class="inline-flex items-center px-4 py-2 bg-gray-200 border border-gray-300 rounded-md font-semibold text-xs text-gray-700 uppercase tracking-widest hover:bg-gray-300 transition">
            &larr; Kembali ke Daftar Artikel
        </a>
    </div>
</div>
@endsection

@push('styles')
    {{-- <link href="https://cdn.jsdelivr.net/npm/@tailwindcss/typography@0.5.x/dist/typography.min.css" rel="stylesheet"> --}}
@endpush
