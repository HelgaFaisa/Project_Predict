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
                        {{-- Symptoms Link --}}
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
              {{-- Symptoms Link --}}
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
            {{-- Symptoms Link --}}
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
    
    {{-- Logout Section (at the bottom) --}}
    <div class="p-3 mt-auto">
        <form method="POST" action="{{ route('logout') }}">
            @csrf
            <button type="submit" 
                   class="menu-item logout-item group flex items-center w-full p-2 rounded-lg text-white/80 hover:bg-red-500/30 hover:text-white transition-all duration-200">
                <div class="flex items-center justify-center w-10 h-10">
                    <i class="ri-logout-box-r-line text-xl group-hover:scale-110 transition-transform"></i>
                </div>
                <span class="ml-3 whitespace-nowrap transition-opacity duration-200"
                      :class="{ 'opacity-0': !sidebarExpanded, 'opacity-100': sidebarExpanded }">
                    Logout
                </span>
                <span class="absolute left-full ml-1 px-2 py-1 bg-red-900 text-xs text-white rounded-md opacity-0 -translate-x-3 pointer-events-none transition-opacity group-hover:opacity-100 shadow-lg"
                      x-show="!sidebarExpanded">
                    Logout
                </span>
            </button>
        </form>
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
        window.sidebarExpanded = localStorage.getItem('sidebar-expanded') === 'true' || window.innerWidth >= 1024;
        
        // Set initial state
        const sidebar = document.getElementById('sidebar');
        updateSidebarState();
        
        // Toggle button functionality
        const toggleExpandBtn = document.getElementById('toggleExpandSidebar');
        if (toggleExpandBtn) {
            toggleExpandBtn.addEventListener('click', function() {
                window.sidebarExpanded = !window.sidebarExpanded;
                localStorage.setItem('sidebar-expanded', window.sidebarExpanded.toString());
                updateSidebarState();
            });
        }
        
        // Function to update sidebar state
        function updateSidebarState() {
            if (window.sidebarExpanded) {
                sidebar.classList.remove('w-20');
                sidebar.classList.add('w-64');
            } else {
                sidebar.classList.remove('w-64');
                sidebar.classList.add('w-20');
            }
            
            // Update text visibility
            const texts = sidebar.querySelectorAll('nav a span:first-of-type, .p-3 form button span');
            texts.forEach(text => {
                if (window.sidebarExpanded) {
                    text.classList.remove('opacity-0');
                    text.classList.add('opacity-100');
                } else {
                    text.classList.remove('opacity-100');
                    text.classList.add('opacity-0');
                }
            });
            
            // Update arrow icon
            const arrowIcon = toggleExpandBtn.querySelector('i');
            if (arrowIcon) {
                if (window.sidebarExpanded) {
                    arrowIcon.classList.remove('rotate-180');
                } else {
                    arrowIcon.classList.add('rotate-180');
                }
            }
            
            // Show/hide tooltips based on expanded state
            const tooltips = sidebar.querySelectorAll('nav a span:last-of-type, .p-3 form button span:last-of-type');
            tooltips.forEach(tooltip => {
                tooltip.style.display = window.sidebarExpanded ? 'none' : 'block';
            });
        }
        
        // Handle active menu items
        const currentPath = window.location.pathname;
        const menuLinks = sidebar.querySelectorAll('nav a.menu-item');
        
        menuLinks.forEach(link => {
            const linkUrl = new URL(link.href, window.location.origin);
            const isLogout = link.closest('form') && link.closest('form').action.includes('logout');
            let isActive = false;
            
            // Check if current path matches the link
            if (linkUrl.pathname === currentPath) {
                isActive = true;
            } else if (linkUrl.pathname.endsWith('/admin/dashboard') && currentPath.startsWith('/admin/dashboard')) {
                isActive = true;
            } else if (linkUrl.pathname !== '/' && currentPath.startsWith(linkUrl.pathname) && linkUrl.pathname.length > 1) {
                isActive = true;
            }
            
            // Apply active styles
            if (isActive) {
                if (!isLogout) {
                    link.classList.add('bg-white/20', 'text-white');
                    link.classList.remove('text-white/80', 'hover:bg-white/10');
                    
                    // Change icon to filled version if active
                    const icon = link.querySelector('i');
                    if (icon && icon.className.includes('-line')) {
                        icon.className = icon.className.replace('-line', '-fill');
                    }
                } else {
                    link.classList.add('bg-red-500/50', 'text-white');
                    link.classList.remove('text-white/80', 'hover:bg-red-500/30');
                }
            }
        });
    });
</script>