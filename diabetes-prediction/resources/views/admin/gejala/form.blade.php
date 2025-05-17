@extends('layouts.app')
@section('title', isset($gejala) ? 'Edit Gejala' : 'Tambah Gejala')
@section('page-title', isset($gejala) ? 'Edit Gejala Diagnosis' : 'Tambah Gejala Diagnosis')

@section('content')
<div class="bg-white rounded-xl shadow p-6 border border-gray-200">
    <h2 class="text-xl font-semibold text-gray-800 mb-4">
        {{ isset($gejala) ? 'Edit Gejala: ' . $gejala->nama : 'Tambah Gejala Baru' }}
    </h2>

    @if ($errors->any())
        <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-4" role="alert">
            <p class="font-bold">Terjadi Kesalahan:</p>
            <ul>
                @foreach ($errors->all() as $error)
                    <li>{{ $error }}</li>
                @endforeach
            </ul>
        </div>
    @endif

    <form method="POST" action="{{ isset($gejala) ? route('admin.gejala.update', $gejala->_id) : route('admin.gejala.store') }}" class="space-y-4">
        @csrf
        @isset($gejala)
            @method('PUT')
        @endisset

        {{-- NAMA GEJALA --}}
        <div>
            <label for="nama" class="block text-sm font-medium text-gray-700 mb-1">Nama Gejala</label>
            <input type="text" name="nama" id="nama" placeholder="Masukkan nama gejala" required
                   value="{{ old('nama', $gejala->nama ?? '') }}"
                   class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('nama') border-red-500 @enderror">
            @error('nama')
                <p class="text-red-500 text-xs mt-1">{{ $message }}</p>
            @enderror
        </div>

        {{-- MB --}}
        <div>
            <label for="mb" class="block text-sm font-medium text-gray-700 mb-1">MB (0 – 1)</label>
            <input type="number" name="mb" id="mb" step="0.01" min="0" max="1" placeholder="Contoh: 0.80" required
                   value="{{ old('mb', $gejala->mb ?? '') }}"
                   class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('mb') border-red-500 @enderror">
            @error('mb')
                <p class="text-red-500 text-xs mt-1">{{ $message }}</p>
            @enderror
        </div>

        {{-- MD --}}
        <div>
            <label for="md" class="block text-sm font-medium text-gray-700 mb-1">MD (0 – 1)</label>
            <input type="number" name="md" id="md" step="0.01" min="0" max="1" placeholder="Contoh: 0.20" required
                   value="{{ old('md', $gejala->md ?? '') }}"
                   class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('md') border-red-500 @enderror">
            @error('md')
                <p class="text-red-500 text-xs mt-1">{{ $message }}</p>
            @enderror
        </div>

        {{-- STATUS AKTIF --}}
        <div class="form-check mb-4">
            <input class="form-check-input" type="checkbox" name="aktif" id="aktif"
                   {{ old('aktif', $gejala->aktif ?? true) ? 'checked' : '' }}>
            <label class="form-check-label" for="aktif">Aktif</label>
        </div>

        {{-- BUTTON --}}
        <div class="flex items-center space-x-4 pt-2">
            <button type="submit"
                    class="inline-flex items-center px-4 py-2 bg-indigo-600 border border-transparent rounded-md font-semibold text-xs text-white uppercase tracking-widest hover:bg-indigo-700 active:bg-indigo-800 focus:outline-none focus:border-indigo-900 focus:ring focus:ring-indigo-300 disabled:opacity-25 transition">
                <i class="{{ isset($gejala) ? 'ri-save-line' : 'ri-add-line' }} mr-2 -ml-1"></i>
                {{ isset($gejala) ? 'Simpan Perubahan' : 'Tambah Gejala' }}
            </button>

            <a href="{{ route('admin.gejala.index') }}"  
               class="inline-flex items-center px-4 py-2 bg-white border border-gray-300 rounded-md font-semibold text-xs text-gray-700 uppercase tracking-widest shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-25 transition">
                Batal
            </a>
        </div>
    </form>
</div>
@endsection