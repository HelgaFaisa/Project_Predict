<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\EducationArticle;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Storage;
use Illuminate\Validation\Rule;
use Carbon\Carbon;

class EducationArticleController extends Controller
{
    public function index(Request $request)
    {
        $search = $request->input('search');
        $query = EducationArticle::query()->latest('published_at'); // Urutkan berdasarkan tanggal publikasi terbaru

        if ($search) {
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', '%' . $search . '%')
                  ->orWhere('category', 'like', '%' . $search . '%');
            });
        }

        $articles = $query->paginate(10); // Paginasi 10 item per halaman
        return view('admin.education.index', compact('articles'));
    }

    public function create()
    {
        return view('admin.education.create');
    }

    public function store(Request $request)
    {
        $validatedData = $request->validate([
            'title' => 'required|string|max:255|unique:education_articles,title',
            'content' => 'required|string',
            'category' => 'nullable|string|max:100',
            'author_name' => 'nullable|string|max:150',
            'main_image' => 'nullable|image|mimes:jpeg,png,jpg,gif,webp|max:2048', // Maksimum 2MB
            'status' => 'required|string|in:draft,published',
            'published_at' => 'nullable|date_format:Y-m-d\TH:i', // Format untuk input datetime-local
            'meta_description' => 'nullable|string|max:300',
            'meta_keywords' => 'nullable|string|max:255',
        ]);

        $dataToStore = $validatedData;

        if ($request->hasFile('main_image')) {
            $path = $request->file('main_image')->store('education_images', 'public');
            $dataToStore['main_image_path'] = $path;
        } else {
            $dataToStore['main_image_path'] = null;
        }

        // Konversi published_at jika ada, jika tidak biarkan model yang menangani
        if (!empty($dataToStore['published_at'])) {
            $dataToStore['published_at'] = Carbon::parse($dataToStore['published_at']);
        } else {
            unset($dataToStore['published_at']); // Biarkan model yang menentukan berdasarkan status
        }

        EducationArticle::create($dataToStore);

        return redirect()->route('admin.education.index')->with('success', 'Artikel edukasi berhasil ditambahkan.');
    }

    public function show(EducationArticle $educationArticle)
    {
        return view('admin.education.show', compact('educationArticle'));
    }

    public function edit(EducationArticle $educationArticle)
    {
        return view('admin.education.edit', compact('educationArticle'));
    }

    public function update(Request $request, EducationArticle $educationArticle)
    {
        $validatedData = $request->validate([
            'title' => ['required', 'string', 'max:255', Rule::unique('education_articles', 'title')->ignore($educationArticle->_id, '_id')],
            'content' => 'required|string',
            'category' => 'nullable|string|max:100',
            'author_name' => 'nullable|string|max:150',
            'main_image' => 'nullable|image|mimes:jpeg,png,jpg,gif,webp|max:2048',
            'status' => 'required|string|in:draft,published',
            'published_at' => 'nullable|date_format:Y-m-d\TH:i',
            'meta_description' => 'nullable|string|max:300',
            'meta_keywords' => 'nullable|string|max:255',
        ]);

        $dataToUpdate = $validatedData;

        if ($request->hasFile('main_image')) {
            // Hapus gambar lama jika ada
            if ($educationArticle->main_image_path && Storage::disk('public')->exists($educationArticle->main_image_path)) {
                Storage::disk('public')->delete($educationArticle->main_image_path);
            }
            $path = $request->file('main_image')->store('education_images', 'public');
            $dataToUpdate['main_image_path'] = $path;
        } elseif ($request->boolean('remove_main_image')) { // Jika ada checkbox untuk menghapus gambar
             if ($educationArticle->main_image_path && Storage::disk('public')->exists($educationArticle->main_image_path)) {
                Storage::disk('public')->delete($educationArticle->main_image_path);
            }
            $dataToUpdate['main_image_path'] = null;
        }

        // Konversi published_at jika ada
        if (!empty($dataToUpdate['published_at'])) {
            $dataToUpdate['published_at'] = Carbon::parse($dataToUpdate['published_at']);
        } else {
            // Jika status draft, pastikan published_at null
            if ($dataToUpdate['status'] === 'draft') {
                 $dataToUpdate['published_at'] = null;
            } else {
                 // Jika published dan kosong, biarkan model yang menangani
                 unset($dataToUpdate['published_at']);
            }
        }

        $educationArticle->update($dataToUpdate);

        return redirect()->route('admin.education.index')->with('success', 'Artikel edukasi berhasil diperbarui.');
    }

    public function destroy(EducationArticle $educationArticle)
    {
        // Hapus gambar terkait dari storage jika ada
        if ($educationArticle->main_image_path && Storage::disk('public')->exists($educationArticle->main_image_path)) {
            Storage::disk('public')->delete($educationArticle->main_image_path);
        }

        $educationArticle->delete();
        return redirect()->route('admin.education.index')->with('success', 'Artikel edukasi berhasil dihapus.');
    }
}
