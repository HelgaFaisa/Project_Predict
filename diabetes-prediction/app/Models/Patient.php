<?php

namespace App\Models;

// Pastikan Anda menggunakan Model yang benar untuk MongoDB Anda
// Jika menggunakan mongodb/laravel-mongodb:
use MongoDB\Laravel\Eloquent\Model;
// Jika menggunakan jenssegers/mongodb:
// use Jenssegers\Mongodb\Eloquent\Model;
use Carbon\Carbon; // Jika Anda melakukan casting tanggal atau manipulasi

class Patient extends Model
{
    /**
     * Koneksi database yang digunakan model.
     * Opsional jika koneksi default Anda sudah 'mongodb'.
     */
    // protected $connection = 'mongodb';

    /**
     * Nama collection MongoDB yang digunakan oleh model.
     */
    protected $collection = 'patients'; // Sesuaikan jika nama collection berbeda

    /**
     * Atribut yang dapat diisi secara massal (mass assignable).
     */
    protected $fillable = [
        'name',
        'date_of_birth', // Pastikan ini ada jika digunakan untuk kalkulasi umur
        'gender',
        'contact_number', // Sesuaikan dengan field Anda
        'email',          // Email pasien (bukan email login akun)
        'address',
        // Tambahkan field lain yang relevan dari form kelola pasien Anda
    ];

    /**
     * Atribut yang harus di-cast ke tipe data native.
     */
    protected $casts = [
        'date_of_birth' => 'datetime',
        'created_at' => 'datetime', // Jika Anda menggunakan timestamp Eloquent
        'updated_at' => 'datetime',
    ];

    /**
     * Mendefinisikan relasi one-to-one ke model PatientAccount.
     * Satu pasien memiliki satu akun login.
     */
    public function patientAccount()
    {
        // Argumen kedua adalah foreign key di collection 'patient_accounts' (yaitu 'patient_id')
        // Argumen ketiga adalah local key (primary key '_id') di collection 'patients'
        return $this->hasOne(PatientAccount::class, 'patient_id', '_id');
    }

    /**
     * Accessor untuk menghitung umur pasien.
     *
     * @return int|null
     */
    public function getAgeAttribute()
    {
        if ($this->date_of_birth) {
            return Carbon::parse($this->date_of_birth)->age;
        }
        return null;
    }
}
