<?php

namespace App\Models;

use MongoDB\Laravel\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Gejala extends Model
{
    use HasFactory;

    protected $connection = 'mongodb'; // pastikan ini ada
    protected $collection = 'gejala';

    protected $fillable   = ['kode', 'nama', 'mb', 'md', 'aktif'];

    // default nilai
    protected $attributes = [
        'aktif' => true,
    ];

    // casting numerik
    protected $casts = [
        'mb'   => 'float',
        'md'   => 'float',
        'aktif'=> 'boolean',
    ];
}