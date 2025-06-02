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
     * Accessor untuk mendapatkan URL gambar yang lengkap dengan localhost:8000
     */
    public function getMainImageUrlAttribute()
    {
        if ($this->main_image_path) {
            // Pastikan path dimulai dengan storage/
            $imagePath = $this->main_image_path;
            if (!str_starts_with($imagePath, 'storage/')) {
                $imagePath = 'storage/' . ltrim($imagePath, '/');
            }
            
            // Return URL lengkap dengan localhost:8000
            return 'http://localhost:8000/' . $imagePath;
        }
        
        // URL placeholder jika tidak ada gambar
        return 'http://localhost:8000/storage/placeholder/article-placeholder.jpg';
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
     */
    public function scopePublished($query)
    {
        return $query->where('status', 'published')
                    ->where('published_at', '<=', now());
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
}