<?php

return [

    /* ----------------------------------------------------
     | Default guard & password reset
     | --------------------------------------------------*/
    'defaults' => [
        'guard'     => 'web',      // admin-web pakai session
        'passwords' => 'users',
    ],

    /* ----------------------------------------------------
     | Guards
     | --------------------------------------------------*/
    'guards' => [

        // 1)  Admin-web  (session)
        'web' => [
            'driver'   => 'session',
            'provider' => 'users',
        ],

        // 2)  Pasien-mobile  (JWT)
        'api' => [
            'driver'   => 'jwt',
            'provider' => 'patients',
        ],
    ],

    /* ----------------------------------------------------
     | User Providers
     | --------------------------------------------------*/
    'providers' => [

        // tabel/collection admin
        'users' => [
            'driver' => 'eloquent',
            'model'  => App\Models\User::class,
        ],

        // collection patient_accounts
        'patients' => [
            'driver' => 'eloquent',
            'model'  => App\Models\PatientAccount::class,
        ],
    ],

    /* ----------------------------------------------------
     | Password reset (optional)
     | --------------------------------------------------*/
    'passwords' => [
        'patients' => [
            'provider' => 'patients',
            'table'    => 'password_reset_tokens',
            'expire'   => 60,
        ],
    ],

    'password_timeout' => 10800,
];
