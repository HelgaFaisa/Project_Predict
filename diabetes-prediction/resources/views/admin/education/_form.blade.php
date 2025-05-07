@csrf
<div class="grid grid-cols-1 md:grid-cols-3 gap-x-6 gap-y-4">
    <div class="md:col-span-2 space-y-4">
        <div>
            <label for="title" class="block text-sm font-medium text-gray-700 mb-1">Judul Artikel <span class="text-red-500">*</span></label>
            <input type="text" name="title" id="title" value="{{ old('title', $article->title ?? '') }}" required
                   class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('title') border-red-500 @enderror">
            @error('title') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
        </div>

        <div>
            <label for="content" class="block text-sm font-medium text-gray-700 mb-1">Konten Artikel <span class="text-red-500">*</span></label>
            <textarea name="content" id="content" rows="15" required
                      class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('content') border-red-500 @enderror">{{ old('content', $article->content ?? '') }}</textarea>
            @error('content') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
            <p class="text-xs text-gray-500 mt-1">Tips: Gunakan Markdown untuk format teks atau integrasikan editor WYSIWYG.</p>
        </div>
    </div>

    <div class="space-y-4">
        <div>
            <label for="status" class="block text-sm font-medium text-gray-700 mb-1">Status <span class="text-red-500">*</span></label>
            <select name="status" id="status" required
                    class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('status') border-red-500 @enderror">
                <option value="draft" {{ old('status', $article->status ?? 'draft') == 'draft' ? 'selected' : '' }}>Draft</option>
                <option value="published" {{ old('status', $article->status ?? '') == 'published' ? 'selected' : '' }}>Diterbitkan</option>
            </select>
            @error('status') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
        </div>

        <div>
            <label for="published_at" class="block text-sm font-medium text-gray-700 mb-1">Tanggal Publikasi</label>
            <input type="datetime-local" name="published_at" id="published_at"
                   value="{{ old('published_at', isset($article->published_at) ? ($article->published_at instanceof \Carbon\Carbon ? $article->published_at->format('Y-m-d\TH:i') : \Carbon\Carbon::parse($article->published_at)->format('Y-m-d\TH:i')) : '') }}"
                   class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('published_at') border-red-500 @enderror">
            @error('published_at') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
            <p class="text-xs text-gray-500 mt-1">Kosongkan jika status Draft atau ingin dipublikasikan otomatis.</p>
        </div>

        <div>
            <label for="category" class="block text-sm font-medium text-gray-700 mb-1">Kategori</label>
            <input type="text" name="category" id="category" value="{{ old('category', $article->category ?? '') }}"
                   class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('category') border-red-500 @enderror"
                   placeholder="Contoh: Diet, Olahraga">
            @error('category') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
        </div>

        <div>
            <label for="author_name" class="block text-sm font-medium text-gray-700 mb-1">Nama Penulis</label>
            <input type="text" name="author_name" id="author_name" value="{{ old('author_name', $article->author_name ?? auth()->user()->name ?? '') }}"
                   class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('author_name') border-red-500 @enderror">
            @error('author_name') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
        </div>

        <div>
            <label for="main_image" class="block text-sm font-medium text-gray-700 mb-1">Gambar Utama</label>
            @if(isset($article) && $article->main_image_path)
                <div class="mb-2">
                    <img src="{{ $article->main_image_url }}" alt="Gambar saat ini" class="max-h-32 rounded border border-gray-200">
                    <label for="remove_main_image" class="mt-1 inline-flex items-center text-xs">
                        <input type="checkbox" name="remove_main_image" id="remove_main_image" value="1" class="rounded border-gray-300 text-indigo-600 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50">
                        <span class="ml-2 text-gray-600">Hapus gambar saat ini</span>
                    </label>
                </div>
            @endif
            <input type="file" name="main_image" id="main_image" accept="image/*"
                   class="w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100 @error('main_image') border-red-500 @enderror">
            @error('main_image') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
        </div>

        <div class="border-t border-gray-200 pt-4 mt-4">
             <h3 class="text-md font-medium text-gray-700 mb-2">Pengaturan SEO (Opsional)</h3>
             <div>
                <label for="meta_description" class="block text-sm font-medium text-gray-700 mb-1">Meta Deskripsi</label>
                <textarea name="meta_description" id="meta_description" rows="3" maxlength="300"
                          class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('meta_description') border-red-500 @enderror"
                          placeholder="Deskripsi singkat artikel (maks 300 karakter).">{{ old('meta_description', $article->meta_description ?? '') }}</textarea>
                @error('meta_description') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
            </div>
             <div class="mt-3">
                <label for="meta_keywords" class="block text-sm font-medium text-gray-700 mb-1">Meta Keywords</label>
                <input type="text" name="meta_keywords" id="meta_keywords" value="{{ old('meta_keywords', $article->meta_keywords ?? '') }}"
                       class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 @error('meta_keywords') border-red-500 @enderror"
                       placeholder="Kata kunci dipisah koma">
                @error('meta_keywords') <p class="text-red-500 text-xs mt-1">{{ $message }}</p> @enderror
            </div>
        </div>
    </div>
</div>

<div class="flex items-center space-x-4 pt-6 border-t border-gray-200 mt-6">
    <button type="submit"
            class="inline-flex items-center px-6 py-2 bg-indigo-600 border border-transparent rounded-md font-semibold text-sm text-white uppercase tracking-widest hover:bg-indigo-700 active:bg-indigo-800 focus:outline-none focus:border-indigo-900 focus:ring focus:ring-indigo-300 disabled:opacity-25 transition">
        <i class="ri-save-line mr-2 -ml-1"></i>
        {{ isset($article) ? 'Simpan Perubahan' : 'Simpan Artikel' }}
    </button>
    <a href="{{ route('admin.education.index') }}"
       class="inline-flex items-center px-4 py-2 bg-white border border-gray-300 rounded-md font-semibold text-xs text-gray-700 uppercase tracking-widest shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-25 transition">
        Batal
    </a>
</div>

@push('scripts')
{{-- <script src="https://cdn.tiny.cloud/1/YOUR_TINYMCE_API_KEY/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script> --}}
{{-- <script>
    // document.addEventListener('DOMContentLoaded', function () {
    //     if (document.querySelector('textarea#content')) {
    //         tinymce.init({
    //             selector: 'textarea#content',
    //             plugins: 'advlist autolink lists link image charmap preview anchor searchreplace visualblocks code fullscreen insertdatetime media table help wordcount',
    //             toolbar: 'undo redo | formatselect | bold italic backcolor | \
    //                       alignleft aligncenter alignright alignjustify | \
    //                       bullist numlist outdent indent | removeformat | help',
    //             height: 400,
    //         });
    //     }
    // });
</script> --}}
@endpush
