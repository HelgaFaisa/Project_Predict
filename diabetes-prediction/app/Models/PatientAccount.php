<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail; // Jika ingin verifikasi email
use Illuminate\Database\Eloquent\Factories\HasFactory;
use MongoDB\Laravel\Auth\User as Authenticatable; // Gunakan Authenticatable dari MongoDB
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens; // Untuk API Token jika login mobile via Sanctum

class PatientAccount extends Authenticatable // extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $connection = 'mongodb';
    protected $collection = 'patient_accounts';

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'patient_id', // Untuk relasi ke data pasien di collection 'patients'
        'name',       // Bisa diambil dari data pasien terkait
        'email',      // Digunakan untuk login, harus unik
        'password',
        'phone_number', // Opsional
        'status',     // Misal: active, inactive, suspended
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
     * Relasi ke data detail pasien.
     */
// Dalam app/Models/Patient.php
public function patientAccount()
{
    return $this->hasOne(PatientAccount::class, 'patient_id', '_id');
}
}
