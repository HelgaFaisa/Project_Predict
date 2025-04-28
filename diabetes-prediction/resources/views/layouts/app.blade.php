<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | Platform Diabetes</title>
    <link rel="stylesheet" href="{{ asset('css/style.css') }}">
    <script src="https://unpkg.com/@phosphor-icons/web"></script> <!-- Icon -->
    <link href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" rel="stylesheet">
</head>
<body>

    <div class="container">
        <!-- Sidebar -->
        <aside class="sidebar" id="sidebar">
        <div class="logo" id="logo">
            <img src="/path-ke-logomu.png" alt="Logo" class="logo-img">
            <span class="logo-text">DiabetaCare</span>
        </div>

            <ul class="menu">
                <li><a href="{{ url('dashboard') }}"><i class="ri-home-heart-fill"></i><span>Dashboard</span></a></li>
                <li><a href="#"><i class="ph ph-user"></i> <span>Profile</span></a></li>
                <li><a href="{{ url('predict') }}"><i class="ri-heart-pulse-fill"></i><span>Prediksi</span></a></li>
                <li><a href="{{ url('/kelola-gejala') }}"><i class="ri-list-check-2"></i> <span>Kelola Gejala</span></a></li>
                <li><a href="#"><i class="ph ph-gear"></i> <span>Settings</span></a></li>
            </ul>
        </aside>

        <!-- Main Content -->
        <main class="main">
           <!-- Topbar -->
        <div class="topbar">
            <button id="toggleSidebar" class="btn">☰</button>
            <button id="toggleDarkMode" class="btn">🌙</button>
        </div>

            <!-- Content -->
            <div class="content">
                @yield('content')
            </div>
        </main>
    </div>

    <script src="{{ asset('js/script.js') }}"></script>

</body>
</html>
