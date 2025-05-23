<?php

namespace App\Http\Controllers;

use App\Models\EducationArticle; // Pastikan model ini sudah ada dan benar
use Illuminate\Http\Request;
use MongoDB\BSON\ObjectId; // Diperlukan jika _id adalah ObjectId MongoDB
use Illuminate\Support\Collection; // Tambahkan ini untuk menggunakan collect() helper

class PublicPageController extends Controller
{
    // ... (metode home dan articlesIndex tetap sama seperti sebelumnya) ...
    public function home()
    {
        $featuredArticles = EducationArticle::published()
                                            ->latest('published_at')
                                            ->take(3)
                                            ->get();

        return view('public.home', compact('featuredArticles'));
    }

    public function articlesIndex(Request $request)
    {
        $search = $request->input('search');
        $category = $request->input('category');

        $query = EducationArticle::published()->latest('published_at');

        if ($search) {
            $query->where(function ($q) use ($search) {
                $q->where('title', 'like', '%' . $search . '%')
                  ->orWhere('content', 'like', '%' . $search . '%')
                  ->orWhere('category', 'like', '%' . $search . '%');
            });
        }

        if ($category) {
            $query->where('category', $category);
        }

        $articles = $query->paginate(9);

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
                                   ->published()
                                   ->firstOrFail();

        $pipeline = [
            ['$match' => [
                // PASTIKAN ANDA MENYESUAIKAN KONDISI STATUS PUBLISHED DI BAWAH INI
                // Contoh: 'status' => 'published', atau 'is_published' => true
                'status' => 'published', // GANTI INI SESUAI IMPLEMENTASI SCOPE published() ANDA
                '_id' => ['$ne' => new ObjectId($article->_id)],
            ]],
            ['$sample' => ['size' => 3]]
        ];

        if (!empty($article->category)) {
            $pipeline[0]['$match']['category'] = $article->category;
        }

        $relatedArticlesCursor = EducationArticle::raw(function($collection) use ($pipeline) {
            return $collection->aggregate($pipeline);
        });

        // Konversi hasil cursor ke array model EducationArticle
        $relatedModelsArray = [];
        foreach ($relatedArticlesCursor as $relatedDoc) {
            // Menggunakan hydrate untuk mengubah data mentah menjadi instance model Eloquent
            // Pastikan $relatedDoc adalah array atau objek yang atributnya bisa di-map ke model
            if (is_object($relatedDoc) && method_exists($relatedDoc, 'getArrayCopy')) { // Jika BSONDocument
                $relatedModelsArray[] = EducationArticle::hydrate([$relatedDoc->getArrayCopy()])->first();
            } elseif (is_array($relatedDoc)) { // Jika sudah array
                $relatedModelsArray[] = EducationArticle::hydrate([$relatedDoc])->first();
            } elseif (is_object($relatedDoc)) { // Jika objek standar
                 $relatedModelsArray[] = EducationArticle::hydrate([(array) $relatedDoc])->first();
            }
        }
        // Konversi array model menjadi Laravel Collection
        $relatedArticles = collect($relatedModelsArray);

        return view('public.articles.show', compact('article', 'relatedArticles'));
    }

    /**
     * Menampilkan halaman Tentang Kami.
     */
    public function about()
    {
        return view('public.about');
    }
}