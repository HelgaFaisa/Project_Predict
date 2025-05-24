// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_predic/model/ProfileEdit.dart';
import 'splashscreen_page.dart'; // Import SplashScreen Anda
import 'home_page.dart'; // Halaman utama setelah login
import 'logindokter/login.dart'; // Import LoginPage
import '../logindokter/lupapw.dart';
import '../logindokter/resetscreen.dart';
import '../logindokter/verifikasi.dart';

// Import file-file lain yang dibutuhkan oleh halaman-halaman di rute
import '../riwayatpemeriksaan/riwayat.dart';
import '../api/riwayat_api.dart';
import 'api/login_api.dart';
import '../edukasi/edukasi.dart';
import '../edukasi/ArtikelDetailPage.dart'; // Pastikan path ini benar
import '../api/edukasi_api.dart';
import '../api/gejala_api.dart';
import '../gejala/gejala_page.dart';
import '../model/gejala.dart';
// Import ProfileHeader jika masih digunakan sebagai widget terpisah
// import '../model/ProfileHeader.dart'; // Sesuaikan path jika perlu

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DiabetaCare',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins', // Opsional: Gunakan font custom
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Mengatur SplashScreen sebagai halaman awal
      initialRoute: '/',
      routes: {
        // Rute untuk SplashScreen
        '/': (context) => SplashScreen(),
        // Rute untuk LoginPage
        '/login': (context) => LoginPage(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/verify-reset-code': (context) => const VerifyResetCodeScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
        '/home': (context) => HomePage(
          userName: 'Pengguna Default',
          patientId: 'default_patient_id', // <--- Tambahkan ini dengan ID placeholder
        ),
        // Rute untuk halaman-halaman lain
        '/riwayat': (context) => RiwayatPage(),
        '/edukasi': (context) => EdukasiPage(),
        // '/artikelDetail': (context) => ArtikelDetailPage(), // Tambahkan jika ini rute terpisah
        '/gejala': (context) => GejalaPage(),
        '/target': (context) => ProfileScreen(),
        // Tambahkan rute lain jika ada
      },
    );
  }
}

// Pastikan definisi widget SplashScreenPage ada di file splashscreen_page.dart
// Pastikan definisi widget LoginPage ada di file logindokter/login.dart
// Pastikan definisi widget HomePage (yang menerima userName dan patientId) ada di file home_page.dart
// Pastikan definisi widget RiwayatPage, EdukasiPage, GejalaPage, dll. ada di file masing-masing
// Pastikan kelas LoginApi, RiwayatApi, EdukasiApi, GejalaApi ada di file masing-masing
// Pastikan model Gejala ada di file model/gejala.dart