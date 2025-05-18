<?php

namespace App\Models;

use Illuminate\Support\Str;
use Illuminate\Database\Eloquent\Factories\HasFactory;
// Gunakan Authenticatable dari package MongoDB yang Anda pakai
use MongoDB\Laravel\Auth\User as Authenticatable; // Untuk mongodb/laravel-mongodb
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens; // Jika Anda berencana menggunakan API

class User extends Authenticatable // Pastikan extends dari Authenticatable MongoDB
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * Koneksi database yang digunakan model.
     * Opsional jika koneksi default Anda sudah 'mongodb'.
     */
    protected $connection = 'mongodb';

    /**
     * Nama collection MongoDB yang digunakan oleh model.
     * Defaultnya adalah 'users'.
     */
    protected $collection = 'users'; // Atau 'admins', 'doctors', sesuaikan

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'avatar_url',       // Tambahkan ini untuk foto profil
        'phone_number',     // Tambahkan ini untuk nomor telepon
        'role',             // Tambahkan ini jika Anda menggunakan role
        'specialization',   // Tambahkan ini untuk spesialisasi dokter
        'str_number',       // Tambahkan ini untuk nomor STR dokter
        'email_verified_at',// Meskipun dicast, baik jika bisa diisi saat tertentu (opsional)
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed', // Otomatis hash password saat diset/dibuat
        'created_at' => 'datetime', // MongoDB biasanya menangani ini sebagai ISODate secara otomatis
        'updated_at' => 'datetime', // MongoDB biasanya menangani ini sebagai ISODate secara otomatis
    ];

    /**
     * Mendapatkan URL avatar pengguna.
     *
     * @param string|null $value Nilai dari field 'avatar_url' di database.
     * @return string URL avatar.
     */
    public function getAvatarUrlAttribute($value)
    {
        if ($value) {
            // Jika nilai adalah URL lengkap (termasuk dari asset('storage/...'))
            // Controller kita sudah menyimpan URL lengkap dengan asset(), jadi ini akan cocok.
            if (Str::startsWith($value, 'http://') || Str::startsWith($value, 'https://')) {
                return $value;
            }
            // Baris di bawah ini biasanya tidak akan tercapai jika controller selalu menyimpan URL absolut.
            // Jika Anda memutuskan untuk menyimpan path relatif di DB, aktifkan ini:
            // return asset('storage/' . $value);
        }
        // Default jika tidak ada value atau value bukan URL yang valid
        return 'https://ui-avatars.com/api/?name=' . urlencode($this->name ?? 'Pengguna') . '&background=EBF4FF&color=6D5BD0&size=96';
    }

    // Jika Anda menggunakan timestamp dari Eloquent secara eksplisit di MongoDB
    // public function newEloquentBuilder($query)
    // {
    //     return new \MongoDB\Laravel\Eloquent\Builder($query);
    // }
}