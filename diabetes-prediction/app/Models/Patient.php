<?php

namespace App\Models;

use MongoDB\Laravel\Eloquent\Model as Eloquent;
// Carbon tidak perlu di-use di sini jika hanya dipakai via $casts['...'] => 'datetime'
// use Carbon\Carbon;

class Patient extends Eloquent
{
    protected $connection = 'mongodb'; // pastikan koneksi sesuai config/database.php
    protected $collection = 'patients'; // nama koleksi di MongoDB

    /**
     * Atribut yang diizinkan untuk diisi secara massal.
     * Sesuaikan daftar ini dengan field di formulir dan database Anda.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'date_of_birth',
        'gender',
        'contact_number',
        'email',
        'address',
        // Tambahkan field lain dari form jika ada
    ];

    /**
     * Tentukan bagaimana atribut harus di-cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        // Cast 'date_of_birth' menjadi objek Carbon saat diakses,
        // dan simpan sebagai UTCDateTime di MongoDB
        'date_of_birth' => 'datetime',

        // Contoh lain jika perlu:
        // 'some_numeric_field' => 'integer',
        // 'is_active' => 'boolean',
        // 'options' => 'array',
    ];

    /**
     * Eloquent secara default mengelola timestamps 'created_at' dan 'updated_at'.
     * Jika Anda tidak menginginkannya, uncomment baris di bawah ini:
     * public $timestamps = false;
     */
}