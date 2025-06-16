<?php

namespace App\Models;

use Illuminate\Support\Str;
use MongoDB\Laravel\Eloquent\Model;
use Carbon\Carbon;

class EducationArticle extends Model
{
    /**
     * Nama collection MongoDB yang digunakan oleh model.
     */
    protected $collection = 'education_articles';

    /**
     * Atribut yang dapat diisi secara massal (mass assignable).
     */
    protected $fillable = [
        'title',
        'slug',
        'content',
        'category',
        'author_name',
        'main_image_path',
        'status',
        'published_at',
        'meta_description',
        'meta_keywords',
    ];

    /**
     * Atribut yang harus di-cast ke tipe data native.
     */
    protected $casts = [
        'published_at' => 'datetime',
    ];

    /**
     * Atribut yang ditambahkan ke output model.
     */
    protected $appends = [
        'main_image_url',
        'formatted_published_at'
    ];

    /**
     * Boot method untuk model.
     */
    protected static function boot()
    {
        parent::boot();

        static::creating(function ($article) {
            if (empty($article->slug)) {
                $article->slug = Str::slug($article->title);
            }
            if ($article->status === 'published' && empty($article->published_at)) {
                $article->published_at = now();
            }
        });

        static::updating(function ($article) {
            if ($article->isDirty('title')) {
                $article->slug = Str::slug($article->title);
            }

            if ($article->isDirty('status') && $article->status === 'published' && empty($article->published_at)) {
                $article->published_at = now();
            }
            if ($article->isDirty('status') && $article->status === 'draft') {
                $article->published_at = null;
            }
        });
    }

    /**
     * Accessor untuk mendapatkan URL gambar yang lengkap
     */
    public function getMainImageUrlAttribute()
    {
        if ($this->main_image_path) {
            // Pastikan path dimulai dengan storage/
            $imagePath = $this->main_image_path;
            if (!str_starts_with($imagePath, 'storage/')) {
                $imagePath = 'storage/' . ltrim($imagePath, '/');
            }
            
            // Gunakan config untuk base URL agar lebih fleksibel
            $baseUrl = config('app.url', 'http://localhost:8000');
            return $baseUrl . '/' . $imagePath;
        }
        
        // URL placeholder jika tidak ada gambar
        $baseUrl = config('app.url', 'http://localhost:8000');
        return $baseUrl . '/storage/placeholder/article-placeholder.jpg';
    }

    /**
     * Mendapatkan tanggal publikasi yang diformat.
     */
    public function getFormattedPublishedAtAttribute()
    {
        if ($this->published_at) {
            // Set locale ke Indonesia jika diperlukan
            return $this->published_at->format('d M Y, H:i');
        }
        return null;
    }

    /**
     * Scope untuk mengambil hanya artikel yang sudah dipublikasikan.
     * Diperbaiki untuk menghindari masalah dengan artikel yang tidak muncul
     */
    public function scopePublished($query)
    {
        return $query->where('status', 'published')
                    ->whereNotNull('published_at');
                    // Hapus kondisi <= now() untuk debugging
                    // ->where('published_at', '<=', now());
    }

    /**
     * Scope untuk debugging - menampilkan semua artikel termasuk draft
     */
    public function scopeWithStatus($query, $status = null)
    {
        if ($status) {
            return $query->where('status', $status);
        }
        return $query;
    }

    /**
     * Override toArray untuk memastikan URL gambar selalu ada
     */
    public function toArray()
    {
        $array = parent::toArray();
        
        // Pastikan main_image_url selalu ada dalam response
        $array['main_image_url'] = $this->main_image_url;
        $array['formatted_published_at'] = $this->formatted_published_at;
        
        return $array;
    }

    /**
     * Method untuk debugging - cek artikel yang ada
     */
    public static function debugArticles()
    {
        $allArticles = self::all();
        $publishedArticles = self::published()->get();
        
        \Log::info('=== DEBUGGING ARTICLES ===');
        \Log::info('Total articles in database: ' . $allArticles->count());
        \Log::info('Published articles: ' . $publishedArticles->count());
        
        foreach ($allArticles as $article) {
            \Log::info("Article: {$article->title} | Status: {$article->status} | Published At: " . 
                      ($article->published_at ? $article->published_at->format('Y-m-d H:i:s') : 'NULL'));
        }
        
        return [
            'total' => $allArticles->count(),
            'published' => $publishedArticles->count(),
            'articles' => $allArticles->map(function($article) {
                return [
                    'id' => $article->id,
                    'title' => $article->title,
                    'status' => $article->status,
                    'published_at' => $article->published_at ? $article->published_at->format('Y-m-d H:i:s') : null,
                ];
            })
        ];
    }
}