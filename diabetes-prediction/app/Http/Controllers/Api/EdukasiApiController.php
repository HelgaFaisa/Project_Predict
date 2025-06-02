<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\EducationArticle;
use Exception;
use Illuminate\Http\Request;

class EdukasiApiController extends Controller
{
    /**
     * Mendapatkan semua artikel edukasi yang dipublikasikan
     */
    public function index(Request $request)
    {
        try {
            $query = EducationArticle::published()
                    ->latest('published_at');

            // Filter berdasarkan kategori jika ada
            if ($request->has('category') && $request->category != '') {
                $query->where('category', $request->category);
            }

            // Pencarian berdasarkan judul jika ada
            if ($request->has('search') && $request->search != '') {
                $query->where('title', 'like', '%' . $request->search . '%');
            }

            // Pagination
            $perPage = $request->get('per_page', 10);
            $articles = $query->paginate($perPage);

            // Transform data untuk memastikan URL gambar benar
            $transformedData = $articles->getCollection()->map(function ($article) {
                return [
                    'id' => $article->id,
                    'title' => $article->title,
                    'slug' => $article->slug,
                    'content' => $article->content,
                    'category' => $article->category,
                    'author_name' => $article->author_name,
                    'main_image_path' => $article->main_image_path,
                    'main_image_url' => $article->main_image_url, // URL lengkap
                    'status' => $article->status,
                    'published_at' => $article->published_at,
                    'formatted_published_at' => $article->formatted_published_at,
                    'meta_description' => $article->meta_description,
                    'meta_keywords' => $article->meta_keywords,
                    'created_at' => $article->created_at,
                    'updated_at' => $article->updated_at,
                ];
            });

            return response()->json([
                'success' => true,
                'message' => 'Data artikel berhasil dimuat',
                'data' => $transformedData,
                'pagination' => [
                    'current_page' => $articles->currentPage(),
                    'per_page' => $articles->perPage(),
                    'total' => $articles->total(),
                    'last_page' => $articles->lastPage(),
                    'from' => $articles->firstItem(),
                    'to' => $articles->lastItem(),
                ]
            ], 200);

        } catch (Exception $e) {
            \Log::error('Error in EdukasiApiController@index: ' . $e->getMessage());
            \Log::error('Stack trace: ' . $e->getTraceAsString());

            return response()->json([
                'success' => false,
                'message' => 'Gagal memuat data artikel edukasi',
                'error' => config('app.debug') ? $e->getMessage() : 'Internal server error'
            ], 500);
        }
    }

    /**
     * Mendapatkan artikel berdasarkan ID
     */
    public function show($id)
    {
        try {
            $article = EducationArticle::findOrFail($id);

            // Transform data untuk response
            $transformedArticle = [
                'id' => $article->id,
                'title' => $article->title,
                'slug' => $article->slug,
                'content' => $article->content,
                'category' => $article->category,
                'author_name' => $article->author_name,
                'main_image_path' => $article->main_image_path,
                'main_image_url' => $article->main_image_url, // URL lengkap
                'status' => $article->status,
                'published_at' => $article->published_at,
                'formatted_published_at' => $article->formatted_published_at,
                'meta_description' => $article->meta_description,
                'meta_keywords' => $article->meta_keywords,
                'created_at' => $article->created_at,
                'updated_at' => $article->updated_at,
            ];

            return response()->json([
                'success' => true,
                'message' => 'Data artikel berhasil dimuat',
                'data' => $transformedArticle
            ], 200);

        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Artikel tidak ditemukan',
            ], 404);

        } catch (Exception $e) {
            \Log::error('Error in EdukasiApiController@show: ' . $e->getMessage());
            \Log::error('Stack trace: ' . $e->getTraceAsString());

            return response()->json([
                'success' => false,
                'message' => 'Gagal memuat data artikel',
                'error' => config('app.debug') ? $e->getMessage() : 'Internal server error'
            ], 500);
        }
    }

    /**
     * Mendapatkan artikel berdasarkan slug
     */
    public function showBySlug($slug)
    {
        try {
            $article = EducationArticle::where('slug', $slug)
                                    ->where('status', 'published')
                                    ->firstOrFail();

            $transformedArticle = [
                'id' => $article->id,
                'title' => $article->title,
                'slug' => $article->slug,
                'content' => $article->content,
                'category' => $article->category,
                'author_name' => $article->author_name,
                'main_image_path' => $article->main_image_path,
                'main_image_url' => $article->main_image_url,
                'status' => $article->status,
                'published_at' => $article->published_at,
                'formatted_published_at' => $article->formatted_published_at,
                'meta_description' => $article->meta_description,
                'meta_keywords' => $article->meta_keywords,
                'created_at' => $article->created_at,
                'updated_at' => $article->updated_at,
            ];

            return response()->json([
                'success' => true,
                'message' => 'Data artikel berhasil dimuat',
                'data' => $transformedArticle
            ], 200);

        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return response()->json([
                'success' => false,
                'message' => 'Artikel tidak ditemukan',
            ], 404);

        } catch (Exception $e) {
            \Log::error('Error in EdukasiApiController@showBySlug: ' . $e->getMessage());

            return response()->json([
                'success' => false,
                'message' => 'Gagal memuat data artikel',
                'error' => config('app.debug') ? $e->getMessage() : 'Internal server error'
            ], 500);
        }
    }

    /**
     * Mendapatkan kategori yang tersedia
     */
    public function categories()
    {
        try {
            $categories = EducationArticle::published()
                        ->distinct('category')
                        ->pluck('category')
                        ->filter()
                        ->values();

            return response()->json([
                'success' => true,
                'message' => 'Data kategori berhasil dimuat',
                'data' => $categories
            ], 200);

        } catch (Exception $e) {
            \Log::error('Error in EdukasiApiController@categories: ' . $e->getMessage());

            return response()->json([
                'success' => false,
                'message' => 'Gagal memuat data kategori',
                'error' => config('app.debug') ? $e->getMessage() : 'Internal server error'
            ], 500);
        }
    }
}