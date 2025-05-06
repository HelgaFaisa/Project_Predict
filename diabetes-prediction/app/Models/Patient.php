<?php

namespace App\Models;

use MongoDB\Laravel\Eloquent\Model as Eloquent;
use Carbon\Carbon;

class Patient extends Eloquent
{
    protected $connection = 'mongodb'; // pastikan koneksi sesuai config/database.php
    protected $collection = 'patients'; // nama koleksi di MongoDB
}
