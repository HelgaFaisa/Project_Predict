<?php

namespace App\Models;

// use Jenssegers\Mongodb\Eloquent\Model; // Ini untuk jenssegers/mongodb
use MongoDB\Laravel\Eloquent\Model; // <-- GUNAKAN INI

class PredictionHistory extends Model // <-- Pastikan extends dari Model yang benar
{
    // Nama koneksi (jika tidak menggunakan koneksi default 'mongodb')
    // protected $connection = 'mongodb'; // Sesuaikan jika perlu

    // Nama collection
    protected $collection = 'prediction_histories'; // Sesuaikan dengan nama collection Anda

    // Field yang bisa diisi secara massal (mass assignable)
    // Anda mungkin tidak memerlukannya jika data selalu dibuat dari controller
    // protected $fillable = [
    // 'patient_id',
    // 'pregnancies',
    // 'glucose',
    // 'blood_pressure',
    // 'bmi',
    // 'age',
    // 'result',
    // 'prediction_timestamp'
    // ];

    // Tipe data casting, sangat penting untuk tanggal dan numerik
    protected $casts = [
        'result' => 'integer', // atau 'boolean' jika Anda menyimpan 0/1
        'prediction_timestamp' => 'datetime', // Agar Carbon bisa memprosesnya
        'pregnancies' => 'integer',
        'glucose' => 'float', // atau 'integer', sesuaikan dengan data Anda
        'blood_pressure' => 'float', // atau 'integer'
        'bmi' => 'float',
        'age' => 'integer',
        // Pastikan field lain dari API Flask juga di-cast jika perlu disimpan
        // dan ingin tipe datanya konsisten.
    ];

    /**
     * Mendefinisikan relasi ke model Patient.
     * patient_id di collection ini merujuk ke _id di collection patients.
     */
    public function patient()
    {
        // Argumen kedua adalah foreign key di collection PredictionHistory
        // Argumen ketiga adalah local key (primary key) di collection Patient
        return $this->belongsTo(Patient::class, 'patient_id', '_id');
    }
}