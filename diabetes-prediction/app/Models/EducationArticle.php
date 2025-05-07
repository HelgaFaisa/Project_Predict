<?php

namespace App\Models;

use Illuminate\Support\Str;
use MongoDB\Laravel\Eloquent\Model; // Menggunakan Model dari mongodb/laravel-mongodb
use Carbon\Carbon;

class EducationArticle extends Model
{
    /**
     * Koneksi database yang digunakan model.
     * Opsional jika koneksi default Anda sudah 'mongodb'.
     */
    // protected $connection = 'mongodb';

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
     * Boot method untuk model.
     * Digunakan untuk otomatis membuat slug dan mengatur tanggal publikasi.
     */
    protected static function boot()
    {
        parent::boot();

        static::creating(function ($article) {
            if (empty($article->slug)) {
                $article->slug = Str::slug($article->title);
            }
            // Jika status 'published' dan tanggal publikasi kosong, set ke sekarang
            if ($article->status === 'published' && empty($article->published_at)) {
                $article->published_at = now();
            }
        });

        static::updating(function ($article) {
            // Selalu update slug jika judul berubah, atau buat kondisi lain jika diperlukan
            if ($article->isDirty('title')) {
                 $article->slug = Str::slug($article->title);
            }

            // Jika status diubah ke 'published' dan tanggal publikasi kosong, set ke sekarang
            if ($article->isDirty('status') && $article->status === 'published' && empty($article->published_at)) {
                $article->published_at = now();
            }
            // Jika status diubah ke 'draft', hapus tanggal publikasi
            if ($article->isDirty('status') && $article->status === 'draft') {
                $article->published_at = null;
            }
        });
    }

    /**
     * Accessor untuk mendapatkan URL gambar yang lengkap.
     * Asumsi gambar disimpan di storage/app/public/education_images.
     * Pastikan menjalankan `php artisan storage:link`.
     */
    public function getMainImageUrlAttribute()
    {
        if ($this->main_image_path) {
            // Menggunakan asset() helper untuk URL publik dari storage link
            return asset('storage/' . $this->main_image_path);
        }
        // URL placeholder jika tidak ada gambar
        return 'https://placehold.co/600x400/EBF4FF/7F9CF5?text=Artikel+Edukasi';
    }

    /**
     * Mendapatkan tanggal publikasi yang diformat.
     *
     * @return string|null
     */
    public function getFormattedPublishedAtAttribute()
    {
        return $this->published_at ? $this->published_at->translatedFormat('l, d F Y H:i') : null;
    }

    /**
     * Scope untuk mengambil hanya artikel yang sudah dipublikasikan.
     *
     * @param  \MongoDB\Laravel\Eloquent\Builder  $query
     * @return \MongoDB\Laravel\Eloquent\Builder
     */
    public function scopePublished($query)
    {
        return $query->where('status', 'published')->where('published_at', '<=', now());
    }
}
