// lib/login.dart

import 'package:flutter/material.dart';
import '../api/login_api.dart';
import '../home_page.dart'; // Pastikan path ini sesuai dengan struktur foldermu

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

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
      final userData = response['user'];
      final String userName = userData?['name']?.toString() ?? 'Pengguna';
      
      // Ambil patientId
      // PASTIKAN `LoginApi.getPatientId()` mengembalikan String patientId yang valid
      final String? patientId = await LoginApi.getPatientId(); 

      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan dalam respons.');
      }
      if (userData == null) {
          print('Warning: Data user tidak ditemukan dalam respons, menggunakan nama default.');
      }
      
      // Anda harus memutuskan bagaimana menangani jika patientId null atau kosong.
      // Untuk saat ini, kita akan lemparkan Exception jika null/kosong.
      if (patientId == null || patientId.isEmpty) {
        throw Exception('ID pasien tidak ditemukan atau tidak tersimpan setelah login.');
      }

      if (!mounted) return; // Cegah setState jika widget sudah tidak aktif

      // --- NAVIGASI KE HOMEPAGE SAMBIL MELEWATKAN userName DAN patientId ---
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            userName: userName,
            patientId: patientId, // <--- Tambahkan ini
          ),
        ),
      );
      // ----------------------------------------------------

    } catch (e) {
      setState(() {
        _errorMessage = 'Login gagal: ${e.toString().replaceAll('Exception: ', '')}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Metode baru untuk navigasi ke halaman lupa password
  void _navigateToForgotPassword() {
    // Anda perlu mendefinisikan rute '/forgot-password' di MaterialApp Anda (di main.dart)
    // Contoh: routes: { '/forgot-password': (context) => ForgotPasswordPage(), }
    Navigator.pushNamed(context, '/forgot-password');
  }

  @override
  void dispose() {
    // Bersihkan controller saat widget dibuang
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.health_and_safety, size: 80, color: Colors.blue),
                  const SizedBox(height: 20),
                  const Text(
                    'Selamat Datang',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Silakan masuk untuk melanjutkan',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Masukkan email Anda',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Masukkan password Anda',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ),
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : loginUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Masuk', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Bagian "Lupa Password?" yang menggantikan "Belum punya akun? Daftar"
                  Center(
                    child: GestureDetector(
                      onTap: _navigateToForgotPassword,
                      child: const Text(
                        'Lupa Password?',
                        style: TextStyle(
                          color: Colors.blue, 
                          fontWeight: FontWeight.bold,
                          fontSize: 16, // Ukuran font disesuaikan agar lebih jelas
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}