<?php

namespace App\Models;

use MongoDB\Laravel\Eloquent\Model;
use Carbon\Carbon;

class Patient extends Model
{
    // protected $connection = 'mongodb';
    protected $collection = 'patients';

    protected $fillable = [
        'name',
        'nik', // <-- Tambahkan NIK
        'date_of_birth',
        'gender',
        // 'email', // <-- Hapus
        // 'contact_number', // <-- Hapus
        'address',
    ];

    protected $casts = [
        'date_of_birth' => 'datetime',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    public function patientAccount()
    {
        return $this->hasOne(PatientAccount::class, 'patient_id', '_id');
    }

     public function predictionHistories()
    {
        return $this->hasMany(PredictionHistory::class, 'patient_id', '_id');
    }

    public function getAgeAttribute()
    {
        if ($this->date_of_birth) {
            // Pastikan date_of_birth adalah objek Carbon
            $birthDate = $this->date_of_birth instanceof Carbon ? $this->date_of_birth : Carbon::parse($this->date_of_birth);
            return $birthDate->age;
        }
        return null;
    }
}
