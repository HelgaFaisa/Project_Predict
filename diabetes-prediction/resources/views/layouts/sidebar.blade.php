{{-- resources/views/layouts/sidebar.blade.php --}}
<aside id="sidebar" class="sidebar-transition fixed lg:relative z-20 h-screen bg-sidebar-purple transform -translate-x-full lg:translate-x-0 flex flex-col overflow-hidden duration-300 shadow-xl"
        :class="{ 'w-64': sidebarExpanded, 'w-20': !sidebarExpanded }">

    {{-- Header with Logo and Toggle Button --}}
    <div class="flex items-center justify-between p-4">
        {{-- Logo Section - Shows full logo when expanded --}}
        <div class="flex items-center space-x-3" :class="{ 'justify-center w-full': !sidebarExpanded }">
            <div class="flex-shrink-0 w-10 h-10 bg-white/20 rounded-full flex items-center justify-center">
                <i class="ri-heart-pulse-line text-white text-xl"></i>
            </div>
            <h1 class="text-white font-semibold text-lg transition-opacity duration-200"
                :class="{ 'opacity-0 w-0': !sidebarExpanded, 'opacity-100': sidebarExpanded }">
                DiabetaCare
            </h1>
        </div>

        {{-- Toggle Button (Only shown on desktop) --}}
        <button id="toggleExpandSidebar"
                class="hidden lg:flex items-center justify-center w-8 h-8 rounded-md bg-white/10 text-white hover:bg-white/20 transition-colors"
                :class="{ 'ml-auto': sidebarExpanded, 'w-full mt-5': !sidebarExpanded }">
            <i class="ri-arrow-left-s-line transition-transform duration-200"
               :class="{ 'rotate-180': !sidebarExpanded }"></i>
        </button>
    </div>

    {{-- Divider --}}
    <div class="w-full h-px bg-white/10 my-2"></div>

    {{-- Navigation Menu --}}
    <nav class="flex-1 overflow-y-auto py-4 px-3">
        <ul class="space-y-2">
            {{-- Dashboard Link --}}
            <li>
                <a href="{{ route('admin.dashboard') }}"
                   class="menu-item group flex items-center p-2 rounded-lg text-white/80 hover:bg-white/10 hover:text-white transition-all duration-200">
                    <div class="flex items-center justify-center w-10 h-10">
                        <i class="ri-home-heart-line text-xl group-hover:scale-110 transition-transform"></i>
                    </div>
                    <span class="ml-3 whitespace-nowrap transition-opacity duration-200"
                          :class="{ 'opacity-0': !sidebarExpanded, 'opacity-100': sidebarExpanded }">
                        Dashboard
                    </span>
                    <span class="absolute left-full ml-1 px-2 py-1 bg-gray-900 text-xs text-white rounded-md opacity-0 -translate-x-3 pointer-events-none transition-opacity group-hover:opacity-100 shadow-lg"
                          x-show="!sidebarExpanded">
                        Dashboard
                    </span>
                </a>
            </li>

            {{-- Patients Link --}}
            <li>
                <a href="{{ route('admin.pasien.index') }}"
                   class="menu-item group flex items-center p-2 rounded-lg text-white/80 hover:bg-white/10 hover:text-white transition-all duration-200">
                    <div class="flex items-center justify-center w-10 h-10">
                        <i class="ri-group-line text-xl group-hover:scale-110 transition-transform"></i>
                    </div>
                    <span class="ml-3 whitespace-nowrap transition-opacity duration-200"
                          :class="{ 'opacity-0': !sidebarExpanded, 'opacity-100': sidebarExpanded }">
                        Kelola Pasien
                    </span>
                    <span class="absolute left-full ml-1 px-2 py-1 bg-gray-900 text-xs text-white rounded-md opacity-0 -translate-x-3 pointer-events-none transition-opacity group-hover:opacity-100 shadow-lg"
                          x-show="!sidebarExpanded">
                        Kelola Pasien
                    </span>
                </a>
            </li>

            {{-- Prediction Link --}}
            <li>
                <a href="{{ route('admin.prediksi.index') }}"
                   class="menu-item group flex items-center p-2 rounded-lg text-white/80 hover:bg-white/10 hover:text-white transition-all duration-200">
                    <div class="flex items-center justify-center w-10 h-10">
                        <i class="ri-flask-line text-xl group-hover:scale-110 transition-transform"></i>
                    </div>
                    <span class="ml-3 whitespace-nowrap transition-opacity duration-200"
                          :class="{ 'opacity-0': !sidebarExpanded, 'opacity-100': sidebarExpanded }">
                        Prediksi Diabetes
                    </span>
                    <span class="absolute left-full ml-1 px-2 py-1 bg-gray-900 text-xs text-white rounded-md opacity-0 -translate-x-3 pointer-events-none transition-opacity group-hover:opacity-100 shadow-lg"
                          x-show="!sidebarExpanded">
                        Prediksi Diabetes
                    </span>
                </a>
            </li>
            {{-- Prediction History Link --}}
            <li>
                <a href="{{ route('admin.prediction_history.index') }}"
                   class="menu-item group flex items-center p-2 rounded-lg text-white/80 hover:bg-white/10 hover:text-white transition-all duration-200">
                    <div class="flex items-center justify-center w-10 h-10">
                        <i class="ri-history-line text-xl group-hover:scale-110 transition-transform"></i>
                    </div>
                    <span class="ml-3 whitespace-nowrap transition-opacity duration-200"
                          :class="{ 'opacity-0': !sidebarExpanded, 'opacity-100': sidebarExpanded }">
                        Riwayat Prediksi
                    </span>
                    <span class="absolute left-full ml-1 px-2 py-1 bg-gray-900 text-xs text-white rounded-md opacity-0 -translate-x-3 pointer-events-none transition-opacity group-hover:opacity-100 shadow-lg"
                          x-show="!sidebarExpanded">
                        Riwayat Prediksi
                    </span>
                </a>
            </li>
             {{-- Patient Accounts Link --}}
            <li>
                <a href="{{ route('admin.patient-accounts.index') }}"
                   class="menu-item group flex items-center p-2 rounded-lg text-white/80 hover:bg-white/10 hover:text-white transition-all duration-200">
                    <div class="flex items-center justify-center w-10 h-10">
                        <i class="ri-account-pin-box-line text-xl group-hover:scale-110 transition-transform"></i>
                    </div>
                    <span class="ml-3 whitespace-nowrap transition-opacity duration-200"
                          :class="{ 'opacity-0': !sidebarExpanded, 'opacity-100': sidebarExpanded }">
                        Akun Pasien
                    </span>
                    <span class="absolute left-full ml-1 px-2 py-1 bg-gray-900 text-xs text-white rounded-md opacity-0 -translate-x-3 pointer-events-none transition-opacity group-hover:opacity-100 shadow-lg"
                          x-show="!sidebarExpanded">
                        Akun Pasien
                    </span>
                </a>
            </li>
            {{-- Symptoms Link --}}
            <li>
                <a href="{{ route('admin.gejala.index') }}"
                   class="menu-item group flex items-center p-2 rounded-lg text-white/80 hover:bg-white/10 hover:text-white transition-all duration-200">
                    <div class="flex items-center justify-center w-10 h-10">
                        <i class="ri-list-check-2 text-xl group-hover:scale-110 transition-transform"></i>
                    </div>
                    <span class="ml-3 whitespace-nowrap transition-opacity duration-200"
                          :class="{ 'opacity-0': !sidebarExpanded, 'opacity-100': sidebarExpanded }">
                        Kelola Gejala
                    </span>
                    <span class="absolute left-full ml-1 px-2 py-1 bg-gray-900 text-xs text-white rounded-md opacity-0 -translate-x-3 pointer-events-none transition-opacity group-hover:opacity-100 shadow-lg"
                          x-show="!sidebarExpanded">
                        Kelola Gejala
                    </span>
                </a>
            </li>
            {{-- Education Articles Link --}}
            <li>
                <a href="{{ route('admin.education.index') }}"
                   class="menu-item group flex items-center p-2 rounded-lg text-white/80 hover:bg-white/10 hover:text-white transition-all duration-200">
                    <div class="flex items-center justify-center w-10 h-10">
                        <i class="ri-book-open-line text-xl group-hover:scale-110 transition-transform"></i>
                    </div>
                    <span class="ml-3 whitespace-nowrap transition-opacity duration-200"
                          :class="{ 'opacity-0': !sidebarExpanded, 'opacity-100': sidebarExpanded }">
                        Artikel Edukasi
                    </span>
                    <span class="absolute left-full ml-1 px-2 py-1 bg-gray-900 text-xs text-white rounded-md opacity-0 -translate-x-3 pointer-events-none transition-opacity group-hover:opacity-100 shadow-lg"
                          x-show="!sidebarExpanded">
                        Artikel Edukasi
                    </span>
                </a>
            </li>

        </ul>
    </nav>

    {{-- Preview Web Section (at the bottom, replacing Logout) --}}
    <div class="p-3 mt-auto">
        {{-- Ganti {{ route('home') }} dengan route yang sesuai untuk preview web Anda --}}
        {{-- Anda mungkin juga perlu mengganti ikonnya (ri-eye-line atau ri-global-line bisa jadi pilihan) --}}
        <a href="{{ route('public.home') }}" target="_blank" {{-- Tambahkan target="_blank" agar membuka di tab baru --}}
           class="menu-item group flex items-center w-full p-2 rounded-lg text-white/80 hover:bg-blue-500/30 hover:text-white transition-all duration-200">
            <div class="flex items-center justify-center w-10 h-10">
                <i class="ri-external-link-line text-xl group-hover:scale-110 transition-transform"></i> {{-- Menggunakan ikon external-link --}}
            </div>
            <span class="ml-3 whitespace-nowrap transition-opacity duration-200"
                  :class="{ 'opacity-0': !sidebarExpanded, 'opacity-100': sidebarExpanded }">
                Preview Web
            </span>
            <span class="absolute left-full ml-1 px-2 py-1 bg-gray-900 text-xs text-white rounded-md opacity-0 -translate-x-3 pointer-events-none transition-opacity group-hover:opacity-100 shadow-lg"
                  x-show="!sidebarExpanded">
                Preview Web
            </span>
        </a>
    </div>
</aside>

{{-- Alpine.js for Toggling Sidebar - To be included in your main layout if not already --}}
<script>
    // Add this script to your main layout or include as a separate JS file
    document.addEventListener('alpine:init', () => {
        Alpine.store('sidebar', {
            expanded: localStorage.getItem('sidebar-expanded') === 'true' || window.innerWidth >= 1024,
            toggle() {
                this.expanded = !this.expanded;
                localStorage.setItem('sidebar-expanded', this.expanded.toString());
            }
        });
    });
</script>

{{-- Javascript to add to your existing script section --}}
<script>
    // This needs to be integrated with your existing JavaScript
    document.addEventListener('DOMContentLoaded', function() {
        // Initialize sidebar expanded state
        // Gunakan Alpine store jika sudah ada, atau tetap gunakan window.sidebarExpanded jika belum migrasi penuh
        let sidebarExpanded = Alpine.store('sidebar') ? Alpine.store('sidebar').expanded : (localStorage.getItem('sidebar-expanded') === 'true' || window.innerWidth >= 1024);
        
        const sidebar = document.getElementById('sidebar');
        
        // Function to update sidebar state based on Alpine store or window.sidebarExpanded
        function updateSidebarVisualState() {
            const isExpanded = Alpine.store('sidebar') ? Alpine.store('sidebar').expanded : window.sidebarExpanded;

            if (isExpanded) {
                sidebar.classList.remove('w-20');
                sidebar.classList.add('w-64');
            } else {
                sidebar.classList.remove('w-64');
                sidebar.classList.add('w-20');
            }
            
            // Update text visibility
            const texts = sidebar.querySelectorAll('nav a span:first-of-type, .p-3 a span:not([x-show])'); // Disesuaikan querySelector untuk Preview Web
            texts.forEach(text => {
                if (isExpanded) {
                    text.classList.remove('opacity-0');
                    text.classList.add('opacity-100');
                } else {
                    text.classList.remove('opacity-100');
                    text.classList.add('opacity-0');
                }
            });
            
            // Update arrow icon
            const toggleExpandBtn = document.getElementById('toggleExpandSidebar');
            if (toggleExpandBtn) {
                const arrowIcon = toggleExpandBtn.querySelector('i');
                if (arrowIcon) {
                    if (isExpanded) {
                        arrowIcon.classList.remove('rotate-180');
                    } else {
                        arrowIcon.classList.add('rotate-180');
                    }
                }
            }
            
            // Show/hide tooltips based on expanded state
            const tooltips = sidebar.querySelectorAll('nav a span[x-show], .p-3 a span[x-show]'); // Disesuaikan querySelector untuk Preview Web
            tooltips.forEach(tooltip => {
                // x-show akan menangani ini jika Alpine digunakan, tapi untuk konsistensi
                tooltip.style.display = isExpanded ? 'none' : ''; 
            });
        }

        updateSidebarVisualState(); // Panggil saat load awal

        // Toggle button functionality
        const toggleExpandBtn = document.getElementById('toggleExpandSidebar');
        if (toggleExpandBtn) {
            toggleExpandBtn.addEventListener('click', function() {
                if (Alpine.store('sidebar')) {
                    Alpine.store('sidebar').toggle();
                } else {
                    window.sidebarExpanded = !window.sidebarExpanded;
                    localStorage.setItem('sidebar-expanded', window.sidebarExpanded.toString());
                }
                updateSidebarVisualState(); // Panggil setelah toggle
            });
        }
        
        // Jika menggunakan Alpine, watch perubahan pada store
        if (Alpine.store('sidebar')) {
            Alpine.effect(() => {
                const isExpanded = Alpine.store('sidebar').expanded;
                // Update visual state berdasarkan Alpine store
                if (isExpanded) {
                    sidebar.classList.remove('w-20');
                    sidebar.classList.add('w-64');
                    sidebar.classList.remove('-translate-x-full'); // Jika mobile dan terbuka
                    sidebar.classList.add('translate-x-0');
                } else {
                    sidebar.classList.remove('w-64');
                    sidebar.classList.add('w-20');
                    // Jangan otomatis sembunyikan di desktop jika hanya diciutkan
                    if (window.innerWidth < 1024) {
                         sidebar.classList.add('-translate-x-full');
                         sidebar.classList.remove('translate-x-0');
                    }
                }
                 // Update text dan tooltip visibility
                const texts = sidebar.querySelectorAll('nav a span:not([x-show]), .p-3 a span:not([x-show])');
                texts.forEach(text => {
                    text.style.opacity = isExpanded ? '1' : '0';
                    if(!isExpanded && text.closest('a.menu-item')) { // Sembunyikan teks jika tidak expanded
                        text.classList.add('opacity-0')
                    } else {
                        text.classList.remove('opacity-0')
                    }
                });

                const tooltips = sidebar.querySelectorAll('span[x-show]');
                tooltips.forEach(tooltip => {
                     // Biarkan Alpine menangani visibility via x-show="!sidebarExpanded" atau x-show="!Alpine.store('sidebar').expanded"
                });


                // Update arrow icon pada tombol toggle
                const arrowIcon = toggleExpandBtn ? toggleExpandBtn.querySelector('i') : null;
                if (arrowIcon) {
                    if (isExpanded) {
                        arrowIcon.classList.remove('rotate-180');
                    } else {
                        arrowIcon.classList.add('rotate-180');
                    }
                }
            });
        }


        // Handle active menu items
        const currentPath = window.location.pathname;
        const menuLinks = sidebar.querySelectorAll('nav a.menu-item, .p-3 a.menu-item'); // Termasuk link Preview Web
        
        menuLinks.forEach(link => {
            const linkUrl = new URL(link.href, window.location.origin);
            // Hapus pengecekan isLogout karena sudah tidak ada form logout
            let isActive = false;
            
            if (linkUrl.pathname === currentPath) {
                isActive = true;
            // Kasus khusus untuk dashboard admin, agar aktif jika path berawal dengan /admin/dashboard
            } else if (linkUrl.pathname.endsWith('/admin/dashboard') && currentPath.startsWith('/admin/dashboard')) {
                 isActive = true;
            // Kondisi umum untuk path lain, aktif jika path saat ini berawal dengan path link
            // dan path link bukan hanya '/' (homepage) kecuali path saat ini juga '/'
            } else if (linkUrl.pathname !== '/' && currentPath.startsWith(linkUrl.pathname) && linkUrl.pathname.length > 1) {
                isActive = true;
            }
            
            // Apply active styles
            if (isActive) {
                // Tidak perlu lagi membedakan style logout
                link.classList.add('bg-white/20', 'text-white');
                link.classList.remove('text-white/80', 'hover:bg-white/10', 'hover:bg-blue-500/30'); // Hapus hover spesifik preview web jika aktif
                
                const icon = link.querySelector('i');
                if (icon && icon.className.includes('-line')) {
                    icon.className = icon.className.replace('-line', '-fill');
                }
            }
        });
    });
</script>