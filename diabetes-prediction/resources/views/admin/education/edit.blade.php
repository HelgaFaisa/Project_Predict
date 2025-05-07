@extends('layouts.app')

@section('title', 'Edit Artikel Edukasi')
@section('page-title', 'Formulir Edit Artikel Edukasi')

@section('content')
<div class="bg-white rounded-xl shadow p-6 md:p-8 border border-gray-200">
    <h2 class="text-xl font-semibold text-gray-800 mb-6">Edit Artikel: {{ $educationArticle->title }}</h2>

    @if ($errors->any())
        <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6 rounded-md" role="alert">
            <p class="font-bold">Harap perbaiki input berikut:</p>
            <ul class="mt-2 list-disc list-inside text-sm">
                @foreach ($errors->all() as $error)
                    <li>{{ $error }}</li>
                @endforeach
            </ul>
        </div>
    @endif

    <form action="{{ route('admin.education.update', $educationArticle) }}" method="POST" enctype="multipart/form-data">
        @method('PUT')
        @include('admin.education._form', ['article' => $educationArticle])
    </form>
</div>
@endsection
