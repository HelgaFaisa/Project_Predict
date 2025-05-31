<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use MongoDB\Client;
use MongoDB\Database;

class MongoDBServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        $this->app->singleton(Database::class, function ($app) {
            // Ambil konfigurasi dari .env yang sudah ada
            $host = env('DB_HOST', '127.0.0.1');
            $port = env('DB_PORT', '27017');
            $database = env('DB_DATABASE', 'prediksi_diabetes');
            $username = env('DB_USERNAME', '');
            $password = env('DB_PASSWORD', '');
            
            // Buat connection string berdasarkan konfigurasi
            if ($username && $password) {
                $connectionString = "mongodb://{$username}:{$password}@{$host}:{$port}";
            } else {
                $connectionString = "mongodb://{$host}:{$port}";
            }
            
            $client = new Client($connectionString);
            return $client->selectDatabase($database);
        });
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        //
    }
}