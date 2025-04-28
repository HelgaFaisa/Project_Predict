<?php

namespace App\Models;

use MongoDB\Laravel\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Gejala extends Model
{
    use HasFactory;

    protected $connection = 'mongodb'; // pastikan ini ada
    protected $collection = 'gejala';

    protected $fillable = ['name', 'weight', 'active'];

    protected $casts = [
        'active' => 'boolean',
        'weight' => 'float'
    ];
}
