<?php

namespace App\Http\Controllers;

use App\Models\EducationArticle; // Pastikan model ini sudah ada dan benar
use Illuminate\Http\Request;

class PublicPageController extends Controller
{
    /**
     * Menampilkan halaman Beranda.
     * Akan mengambil beberapa artikel terbaru untuk ditampilkan.
     */
    public function home()
    {
        $featuredArticles = EducationArticle::published() // Menggunakan scope 'published' dari model
                                           ->latest('published_at') // Urutkan berdasarkan terbaru
                                           ->take(3) // Ambil 3 artikel
                                           ->get();

        return view('public.home', compact('featuredArticles'));
    }

    /**
     * Menampilkan halaman daftar semua artikel edukasi.
     * Dengan fitur pencarian dan pagination.
     */
    public function articlesIndex(Request $request)
    {
        $search = $request->input('search');
        $category = $request->input('category'); // Jika Anda ingin filter berdasarkan kategori

        $query = EducationArticle::published()->latest('published_at');

        if ($search) {
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', '%' . $search . '%')
                  ->orWhere('content', 'like', '%' . $search . '%') // Pencarian di konten juga
                  ->orWhere('category', 'like', '%' . $search . '%');
            });
        }

        if ($category) {
            $query->where('category', $category);
        }

        $articles = $query->paginate(9); // Misal 9 artikel per halaman

        // Ambil daftar kategori unik untuk filter (opsional)
        $categories = EducationArticle::published()
                                      ->whereNotNull('category')
                                      ->where('category', '!=', '')
                                      ->distinct()
                                      ->orderBy('category', 'asc')
                                      ->pluck('category');


        return view('public.articles.index', compact('articles', 'categories', 'search', 'category'));
    }

    /**
     * Menampilkan halaman detail satu artikel edukasi berdasarkan slug.
     */
    public function articlesShow($slug)
    {
        $article = EducationArticle::where('slug', $slug)
                                   ->published() // Pastikan hanya artikel published yang bisa diakses
                                   ->firstOrFail(); // Akan menampilkan 404 jika tidak ditemukan

        // Ambil artikel terkait atau terbaru lainnya (opsional)
        $relatedArticles = EducationArticle::published()
                                           ->where('_id', '!=', $article->_id) // Jangan tampilkan artikel yang sama
                                           ->when($article->category, function ($query) use ($article) {
                                                return $query->where('category', $article->category); // Artikel dari kategori yang sama
                                           })
                                           ->inRandomOrder() // Atau latest('published_at')
                                           ->take(3)
                                           ->get();

        return view('public.articles.show', compact('article', 'relatedArticles'));
    }

    /**
     * Menampilkan halaman Tentang Kami.
     */
    public function about()
    {
        // Anda bisa mengambil data dari database jika halaman "Tentang Kami" dinamis,
        // atau langsung menampilkan view statis.
        return view('public.about');
    }
}
