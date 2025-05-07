<?php

namespace App\Models;

// Sesuaikan dengan package MongoDB yang Anda gunakan:
use MongoDB\Laravel\Eloquent\Model; // Untuk mongodb/laravel-mongodb
// use Jenssegers\Mongodb\Eloquent\Model; // Jika menggunakan jenssegers/mongodb

class PredictionHistory extends Model
{
    protected $connection = 'mongodb'; // Atau koneksi default Anda
    protected $collection = 'prediction_histories'; // Pastikan nama collection ini benar

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'patient_id',
        'pregnancies',
        'glucose',
        'blood_pressure',
        'height',
        'weight',
        'bmi',
        'age',
        'result',
        'prediction_timestamp', // Ditambahkan di controller sebelum create()
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'prediction_timestamp' => 'datetime',
        'result' => 'integer', // atau 'boolean'
        'pregnancies' => 'integer',
        'glucose' => 'float',
        'blood_pressure' => 'float',
        'height' => 'float',
        'weight' => 'float',
        'bmi' => 'float',
        'age' => 'integer',
    ];

    /**
     * Relasi ke model Patient.
     */
    public function patient()
    {
        // Asumsi patient_id di sini merujuk ke _id di collection patients
        return $this->belongsTo(Patient::class, 'patient_id', '_id');
    }
}