<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
// Gunakan Authenticatable dari package MongoDB yang Anda pakai
use MongoDB\Laravel\Auth\User as Authenticatable; // Untuk mongodb/laravel-mongodb
// use Jenssegers\Mongodb\Auth\User as Authenticatable; // Alternatif jika pakai jenssegers
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
        // Tambahkan field lain jika perlu, misal: 'role', 'specialization'
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
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];
}
