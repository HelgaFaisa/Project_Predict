<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrasi Admin | DiabetaCare</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.2.0/fonts/remixicon.css" rel="stylesheet" />
    <style>
        body { font-family: 'Poppins', sans-serif; }
    </style>
</head>
<body class="bg-gradient-to-br from-indigo-100 via-purple-50 to-blue-100 flex items-center justify-center min-h-screen py-12">
    <div class="bg-white p-8 md:p-12 rounded-xl shadow-xl w-full max-w-md">
        <div class="text-center mb-8">
             <div class="inline-flex items-center justify-center w-16 h-16 bg-sidebar-purple rounded-full mb-4 shadow-md">
                <i class="ri-user-add-line text-white text-4xl"></i>
            </div>
            <h1 class="text-2xl font-bold text-gray-800">Registrasi Akun Admin</h1>
            <p class="text-gray-500 text-sm mt-1">Buat akun baru untuk mengakses dashboard.</p>
        </div>

        {{-- Menampilkan error validasi --}}
        @if ($errors->any())
            <div class="bg-red-100 border border-red-300 text-red-700 px-4 py-3 rounded-lg relative mb-6 text-sm" role="alert">
                <strong class="font-semibold">Oops!</strong>
                <ul class="mt-1 list-disc list-inside">
                    @foreach ($errors->all() as $error)
                        <li>{{ $error }}</li>
                    @endforeach
                </ul>
            </div>
        @endif

        <form method="POST" action="{{ route('register') }}" class="space-y-5">
            @csrf

            {{-- Nama Lengkap --}}
            <div>
                <label for="name" class="block text-sm font-medium text-gray-700 mb-1">Nama Lengkap</label>
                 <div class="relative">
                     <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                        <i class="ri-user-line text-gray-400"></i>
                    </span>
                    <input id="name" type="text" name="name" value="{{ old('name') }}" required autofocus autocomplete="name"
                           class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 transition duration-150 ease-in-out">
                 </div>
            </div>

            {{-- Email --}}
            <div>
                <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Alamat Email</label>
                <div class="relative">
                     <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                        <i class="ri-mail-line text-gray-400"></i>
                    </span>
                    <input id="email" type="email" name="email" value="{{ old('email') }}" required autocomplete="username"
                           class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 transition duration-150 ease-in-out">
                </div>
            </div>

            {{-- Password --}}
            <div>
                <label for="password" class="block text-sm font-medium text-gray-700 mb-1">Password</label>
                <div class="relative">
                     <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                        <i class="ri-lock-password-line text-gray-400"></i>
                    </span>
                    <input id="password" type="password" name="password" required autocomplete="new-password"
                           class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 transition duration-150 ease-in-out">
                 </div>
            </div>

            {{-- Konfirmasi Password --}}
            <div>
                <label for="password_confirmation" class="block text-sm font-medium text-gray-700 mb-1">Konfirmasi Password</label>
                <div class="relative">
                     <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                        <i class="ri-lock-password-line text-gray-400"></i>
                    </span>
                    <input id="password_confirmation" type="password" name="password_confirmation" required autocomplete="new-password"
                           class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 transition duration-150 ease-in-out">
                </div>
            </div>

            {{-- Tombol Registrasi --}}
            <div class="pt-2">
                <button type="submit" class="w-full inline-flex items-center justify-center px-4 py-2.5 bg-indigo-600 border border-transparent rounded-lg font-semibold text-sm text-white uppercase tracking-widest hover:bg-indigo-700 active:bg-indigo-800 focus:outline-none focus:border-indigo-900 focus:ring focus:ring-indigo-300 disabled:opacity-25 transition">
                    Daftar
                </button>
            </div>
        </form>

        {{-- Link Login --}}
        <div class="mt-6 text-center text-sm">
            <p class="text-gray-600">
                Sudah punya akun?
                <a href="{{ route('login') }}" class="font-medium text-indigo-600 hover:text-indigo-500">
                    Login di sini
                </a>
            </p>
        </div>
    </div>
</body>
</html>
