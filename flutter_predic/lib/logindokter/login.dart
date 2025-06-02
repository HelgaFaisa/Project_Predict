// lib/login.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../api/login_api.dart'; // Pastikan path ini benar
import '../home_page.dart';  // Pastikan path ini benar dan HomePage membutuhkan userRole

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';
  bool _obscurePassword = true;
  
  // Animation controllers
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _particleController;
  late AnimationController _pulseController;
  
  // Animations
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _slideController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: Duration(milliseconds: 4000),
      vsync: this,
    )..repeat();
    
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    // Initialize animations
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_particleController);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(_pulseController);
    
    // Start animations
    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _particleController.dispose();
    _pulseController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Email dan password harus diisi.';
      });
      return;
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(email)) {
      setState(() {
        _errorMessage = 'Format email tidak valid.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await LoginApi.login(email, password);

      final token = response['token']?.toString();
      final userData = response['user'] as Map<String, dynamic>?; // Casting ke Map
      
      final String userName = userData?['name']?.toString() ?? 'Pengguna';
      // --- PERBAIKAN DI SINI ---
      // Ambil userRole dari respons API. Sesuaikan 'role' dengan key yang benar dari API Anda.
      final String userRole = userData?['role']?.toString() ?? 'Peran Default'; 
      // --- AKHIR PERBAIKAN ---
      
      // Ambil patientId
      final String? patientId = await LoginApi.getPatientId(); 

      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan dalam respons.');
      }
      if (userData == null) {
          print('Warning: Data user (termasuk nama dan role) tidak ditemukan dalam respons.');
      }
      
      if (patientId == null || patientId.isEmpty) {
        // Pertimbangkan apakah patientId wajib ada. Jika ya, throw Exception.
        // Jika tidak, berikan nilai default atau tangani secara berbeda.
        // Untuk contoh ini, kita anggap wajib.
        throw Exception('ID pasien tidak ditemukan atau tidak tersimpan setelah login.');
      }

      if (!mounted) return;

      print('Login Sukses: Username: $userName, PatientID: $patientId, UserRole: $userRole'); // Untuk Debug

      // Navigasi ke HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            userName: userName,
            patientId: patientId,
            userRole: userRole, // Sekarang variabel userRole sudah memiliki nilai
          ),
        ),
      );
    
    } catch (e) {
      String errorMessage = e.toString().replaceAll('Exception: ', '');
      // Periksa jika error adalah karena API (misalnya, mengandung kata 'API Error' atau kode status)
      if (e.toString().contains('API Error') || e.toString().contains('HttpException')) {
         // Anda mungkin ingin mem-parse pesan error dari API di sini jika formatnya JSON
         // Untuk sekarang, kita tampilkan pesan error yang lebih umum jika error dari API
         errorMessage = 'Terjadi kesalahan saat menghubungi server. Coba lagi.';
         // Jika e adalah instance dari class error API kustom Anda, Anda bisa ambil pesan spesifik.
         // contoh: if (e is ApiException) errorMessage = e.message;
      } else if (errorMessage.contains('Token tidak ditemukan') || errorMessage.contains('ID pasien tidak ditemukan')) {
        // Biarkan pesan spesifik ini
      } else {
        // Untuk error umum lainnya
        errorMessage = 'Login gagal. Periksa kembali email dan password Anda.';
      }
      setState(() {
        _errorMessage = errorMessage;
      });
      print('Login Error: $e'); // Cetak error lengkap di konsol untuk debugging
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToForgotPassword() {
    Navigator.pushNamed(context, '/forgot-password');
  }

  @override
  Widget build(BuildContext context) {
    // ... (Kode UI Anda untuk LoginPage tetap sama) ...
    // Saya tidak akan menyalin ulang seluruh UI di sini jika tidak ada perubahan.
    // Pastikan Anda mengacu pada kode UI LoginPage Anda yang sudah ada.
    // Kode di bawah ini adalah kerangka untuk memastikan fungsi loginUser dipanggil.

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [
              Color(0xFF1565C0), Color(0xFF1976D2), Color(0xFF42A5F5),
              Color(0xFF64B5F6), Color(0xFF90CAF9), Color(0xFFE3F2FD),
            ],
            stops: [0.0, 0.2, 0.4, 0.6, 0.8, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background particles (kode sama seperti sebelumnya)
            AnimatedBuilder( 
              animation: _particleAnimation,
              builder: (context, child) {
                // ... (implementasi partikel Anda)
                return SizedBox.shrink(); // Placeholder, ganti dengan implementasi partikel Anda
              }
            ),
            
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: AnimatedBuilder(
                      animation: Listenable.merge([_slideAnimation, _fadeAnimation]),
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _slideAnimation.value),
                          child: Opacity(
                            opacity: _fadeAnimation.value,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Logo (kode sama seperti sebelumnya)
                                AnimatedBuilder(
                                  animation: _pulseAnimation,
                                  builder: (context, child) {
                                      // ... (implementasi logo Anda)
                                      return Container( // Placeholder Logo
                                        width:100, height:100, 
                                        alignment: Alignment.center,
                                        child: Icon(Icons.health_and_safety, size: 80, color: Colors.white)
                                      );
                                  }
                                ),
                                const SizedBox(height: 30),
                                ShaderMask( // Welcome text (kode sama)
                                   shaderCallback: (bounds) => LinearGradient(
                                    colors: [Colors.white, Color(0xFFE3F2FD)],
                                  ).createShader(bounds),
                                  child: Text('Selamat Datang', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1.0)),
                                ),
                                const SizedBox(height: 12),
                                Text('Silakan masuk untuk melanjutkan', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w500)),
                                const SizedBox(height: 50),

                                // Email field (kode sama)
                                Container(
                                  decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5))]),
                                  child: TextField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(fontSize: 16, color: Color(0xFF1565C0), fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                      labelText: 'Email',
                                      // ... (sisa decoration email field Anda)
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.95),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                                      prefixIcon: Icon(Icons.email_outlined, color: Theme.of(context).primaryColorDark)
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Password field (kode sama)
                                Container(
                                   decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5))]),
                                   child: TextField(
                                    controller: passwordController,
                                    obscureText: _obscurePassword,
                                    style: TextStyle(fontSize: 16, color: Color(0xFF1565C0), fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                      labelText: 'Password',
                                      // ... (sisa decoration password field Anda)
                                      filled: true,
                                      fillColor: Colors.white.withOpacity(0.95),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                                      prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).primaryColorDark),
                                      suffixIcon: IconButton(
                                        icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: Color(0xFF1976D2)),
                                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                      ),
                                    ),
                                  ),
                                ),
                                
                                // Error message (kode sama)
                                if (_errorMessage.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Container(
                                      // ... (styling error message Anda)
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red.shade200)),
                                      child: Row(children: [Icon(Icons.error_outline, color: Colors.red.shade700, size: 20), SizedBox(width:8), Expanded(child: Text(_errorMessage, style: TextStyle(color: Colors.red.shade700, fontWeight:FontWeight.w500)))]),
                                    ),
                                  ),
                                const SizedBox(height: 30),

                                // Login button (kode sama)
                                Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    // ... (styling login button Anda)
                                    gradient: LinearGradient(colors: [Color(0xFF42A5F5), Color(0xFF1976D2), Color(0xFF0D47A1)]),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : loginUser,
                                    // ... (styling ElevatedButton Anda)
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                                    child: _isLoading
                                        ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                                        : Text('Masuk', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                
                                // Forgot password (kode sama)
                                Center(child: GestureDetector(
                                  onTap: _navigateToForgotPassword,
                                  // ... (styling forgot password Anda)
                                  child: Container(padding: EdgeInsets.symmetric(horizontal:20, vertical:12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(25)), child: Text('Lupa Password?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)))
                                )),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}