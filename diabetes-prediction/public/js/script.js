// Script untuk sidebar dan dark mode
document.addEventListener('DOMContentLoaded', function() {
    // Toggle sidebar collapsed mode
    const toggleBtn = document.getElementById('toggleSidebar');
    const sidebar = document.getElementById('sidebar');
    
    if (toggleBtn) {
        toggleBtn.addEventListener('click', function() {
            sidebar.classList.toggle('collapsed');
        });
    }
    
    // Toggle dark mode
    const toggleDarkMode = document.getElementById('toggleDarkMode');
    if (toggleDarkMode) {
        toggleDarkMode.addEventListener('click', function() {
            document.body.classList.toggle('dark-mode');
        });
    }
    
    // Responsive handling for small screens
    function handleResponsive() {
        if (window.innerWidth <= 768) {
            // Auto-collapse on small screens, but don't override if user has already toggled
            if (!sessionStorage.getItem('sidebarToggled')) {
                sidebar.classList.add('collapsed');
            }
        }
    }
    
    // Save toggle state to prevent auto-collapse from overriding user preference
    if (toggleBtn) {
        toggleBtn.addEventListener('click', function() {
            sessionStorage.setItem('sidebarToggled', 'true');
        });
    }
    
    // Check on page load
    handleResponsive();
    
    // Check on window resize
    window.addEventListener('resize', handleResponsive);
});