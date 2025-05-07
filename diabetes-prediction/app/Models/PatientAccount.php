<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use MongoDB\Laravel\Auth\User as Authenticatable; // Gunakan Authenticatable dari MongoDB
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens; // Untuk API Token jika login mobile via Sanctum

class PatientAccount extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $connection = 'mongodb'; // Pastikan ini sesuai dengan koneksi MongoDB Anda
    protected $collection = 'patient_accounts'; // Pastikan nama collection ini benar

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'patient_id',       // Foreign key ke collection 'patients'
        'name',             // Nama akun, bisa sama dengan nama pasien
        'email',            // Email untuk login, harus unik
        'password',
        'phone_number',     // Opsional
        'status',           // Misal: active, inactive
        'last_login_at',
        'profile_photo_path', // Opsional
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
        'last_login_at' => 'datetime',
        'password' => 'hashed', // Otomatis hash saat diset
    ];

    /**
     * Mendefinisikan relasi belongsTo ke model Patient.
     * Satu akun pasien dimiliki oleh satu data pasien.
     */
    public function patient()
    {
        // Argumen kedua adalah foreign key di collection 'patient_accounts' (yaitu 'patient_id')
        // Argumen ketiga adalah owner key (primary key '_id') di collection 'patients'
        return $this->belongsTo(Patient::class, 'patient_id', '_id');
    }
}
