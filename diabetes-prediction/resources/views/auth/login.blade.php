<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Admin | DiabetaCare</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.2.0/fonts/remixicon.css" rel="stylesheet" />
    <style>
        body { font-family: 'Poppins', sans-serif; }
    </style>
</head>
<body class="bg-gradient-to-br from-indigo-100 via-purple-50 to-blue-100 flex items-center justify-center min-h-screen">
    <div class="bg-white p-8 md:p-12 rounded-xl shadow-xl w-full max-w-md">
        <div class="text-center mb-8">
             <div class="inline-flex items-center justify-center w-16 h-16 bg-sidebar-purple rounded-full mb-4 shadow-md">
                <i class="ri-heart-pulse-line text-white text-4xl"></i>
            </div>
            <h1 class="text-2xl font-bold text-gray-800">Login Admin DiabetaCare</h1>
            <p class="text-gray-500 text-sm mt-1">Masukkan kredensial Anda untuk melanjutkan.</p>
        </div>

        {{-- Menampilkan error login --}}
        @if ($errors->any())
            <div class="bg-red-100 border border-red-300 text-red-700 px-4 py-3 rounded-lg relative mb-6 text-sm" role="alert">
                <strong class="font-semibold">Oops!</strong>
                <ul class="mt-1 list-disc list-inside">
                    {{-- Menampilkan pesan error spesifik untuk email/auth.failed atau throttle --}}
                    @if ($errors->has('email'))
                         <li>{{ $errors->first('email') }}</li>
                    @else
                        {{-- Menampilkan error umum jika ada --}}
                        @foreach ($errors->all() as $error)
                            <li>{{ $error }}</li>
                        @endforeach
                    @endif
                </ul>
            </div>
        @endif
         @if (session('status'))
            <div class="bg-green-100 border border-green-300 text-green-700 px-4 py-3 rounded-lg relative mb-6 text-sm" role="alert">
                {{ session('status') }}
            </div>
        @endif

        <form method="POST" action="{{ route('login') }}" class="space-y-6">
            @csrf

            {{-- Email --}}
            <div>
                <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Alamat Email</label>
                <div class="relative">
                     <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                        <i class="ri-mail-line text-gray-400"></i>
                    </span>
                    <input id="email" type="email" name="email" value="{{ old('email') }}" required autofocus autocomplete="username"
                           class="w-full pl-10 pr-4 py-2 border {{ $errors->has('email') ? 'border-red-500' : 'border-gray-300' }} rounded-lg focus:ring-indigo-500 focus:border-indigo-500 transition duration-150 ease-in-out">
                </div>
            </div>

            {{-- Password --}}
            <div>
                <label for="password" class="block text-sm font-medium text-gray-700 mb-1">Password</label>
                 <div class="relative">
                     <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                        <i class="ri-lock-password-line text-gray-400"></i>
                    </span>
                    <input id="password" type="password" name="password" required autocomplete="current-password"
                           class="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-indigo-500 focus:border-indigo-500 transition duration-150 ease-in-out">
                 </div>
            </div>

            {{-- Remember Me --}}
            <div class="flex items-center justify-between text-sm">
                <label for="remember" class="inline-flex items-center"> {{-- ID dan name diubah menjadi 'remember' --}}
                    <input id="remember" type="checkbox" name="remember" class="rounded border-gray-300 text-indigo-600 shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50">
                    <span class="ml-2 text-gray-600">Ingat saya</span>
                </label>
            </div>

            {{-- Tombol Login --}}
            <div>
                <button type="submit" class="w-full inline-flex items-center justify-center px-4 py-2.5 bg-indigo-600 border border-transparent rounded-lg font-semibold text-sm text-white uppercase tracking-widest hover:bg-indigo-700 active:bg-indigo-800 focus:outline-none focus:border-indigo-900 focus:ring focus:ring-indigo-300 disabled:opacity-25 transition">
                    Login
                </button>
            </div>
        </form>

         {{-- Link Registrasi --}}
        <div class="mt-6 text-center text-sm">
            <p class="text-gray-600">
                Belum punya akun admin?
                <a href="{{ route('register') }}" class="font-medium text-indigo-600 hover:text-indigo-500">
                    Daftar di sini
                </a>
            </p>
        </div>
    </div>
</body>
</html>

