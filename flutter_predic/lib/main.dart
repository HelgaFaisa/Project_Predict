import 'package:flutter/material.dart';
import 'splashscreen_page.dart'; // Import SplashScreen
import 'login/login_page.dart'; // Halaman welcome dengan tombol Login dan Register
import 'login/login.dart'; // Form Login terpisah
import 'login/register_page.dart'; // Import register page
import 'akun/biodata.dart'; // Import biodata page
import 'home_page.dart'; // Halaman utama setelah login
import 'riwayatpemeriksaan/riwayat.dart'; // Import halaman Riwayat Pemeriksaan
import 'edukasi/edukasi.dart';
import 'target/targethidup.dart';
import 'gejala_page.dart';
import '/model/gejala.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diabetes Chingu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Awal: SplashScreen
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(), // Halaman welcome dengan tombol Login dan Register
        '/login_form': (context) => LoginFormPage(), // Form Login terpisah
        '/register': (context) => RegisterPage(),
        '/biodata': (context) => BiodataFormPage(), // Halaman biodata setelah register
        '/home': (context) => HomePage(),
      '/riwayat_pemeriksaan': (context) {
  // Ambil pasienId dari argumen yang dikirim saat navigasi
  final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
  final int pasienId = args?['pasienId'] ?? 1; // Default ke 1 jika tidak ada
  return RiwayatScreen(pasienId: pasienId);
}, // Menambahkan halaman Riwayat Pemeriksaan
        '/edukasi': (context) => EdukasiPage(),
        '/targethidup': (context) => TargetHidupSehatPage(),
        '/gejala': (context) => DiagnosisPage(),
      },
    );
  }
}
