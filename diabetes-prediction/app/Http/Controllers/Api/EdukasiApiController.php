<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\EducationArticle;
use Exception;
use Illuminate\Http\Request;

class EdukasiApiController extends Controller
{
    /**
     * Debug endpoint untuk melihat semua artikel
     */
    public function debug()
    {
        try {
            $debugInfo = EducationArticle::debugArticles();
            
            return response()->json([
                'success' => true,
                'message' => 'Debug information',
                'data' => $debugInfo
            ], 200);
            
        } catch (Exception $e) {
            \Log::error('Error in debug: ' . $e->getMessage());
            
            return response()->json([
                'success' => false,
                'message' => 'Debug failed',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Test endpoint untuk memastikan API berfungsi
     */
    public function test()
    {
        return response()->json([
            'success' => true,
            'message' => 'API is working',
            'timestamp' => now(),
            'database_connection' => 'OK'
        ], 200);
    }

    /**
     * Mendapatkan semua artikel edukasi yang dipublikasikan
     */
    public function index(Request $request)
    {
        try {
            // Debug log
            \Log::info('=== API INDEX REQUEST ===');
            \Log::info('Request parameters: ', $request->all());
            
            $query = EducationArticle::published()
                    ->latest('published_at');

            // Debug: cek jumlah artikel published
            $publishedCount = EducationArticle::published()->count();
            $totalCount = EducationArticle::count();
            
            \Log::info("Total articles in DB: $totalCount");
            \Log::info("Published articles: $publishedCount");

            // Filter berdasarkan kategori jika ada
            if ($request->has('category') && $request->category != '') {
                $query->where('category', $request->category);
                \Log::info('Filtering by category: ' . $request->category);
            }

            // Pencarian berdasarkan judul jika ada
            if ($request->has('search') && $request->search != '') {
                $query->where('title', 'like', '%' . $request->search . '%');
                \Log::info('Searching for: ' . $request->search);
            }

            // Pagination
            $perPage = $request->get('per_page', 10);
            $articles = $query->paginate($perPage);
            
            \Log::info("Articles after query: " . $articles->count());

            // Transform data untuk memastikan URL gambar benar
            $transformedData = $articles->getCollection()->map(function ($article) {
                \Log::info("Processing article: {$article->title}");
                
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

            $response = [
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
                ],
                'debug_info' => [
                    'total_in_db' => $totalCount,
                    'published_count' => $publishedCount,
                    'returned_count' => $articles->count(),
                ]
            ];
            
            \Log::info('API Response prepared successfully');
            
            return response()->json($response, 200);

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
            \Log::info("Getting article by ID: $id");
            
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