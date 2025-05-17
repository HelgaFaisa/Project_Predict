// lib/main.dart
import 'package:flutter/material.dart';
import 'splashscreen_page.dart'; // Import SplashScreen
import 'home_page.dart'; // Halaman utama setelah login
import 'logindokter/login.dart'; // Import LoginPage
import '../riwayatpemeriksaan/riwayat.dart';
import '../api/riwayat_api.dart';
import 'api/login_api.dart';
import '../edukasi/edukasi.dart';
import '../edukasi/ArtikelDetailPage.dart';
import '../api/edukasi_api.dart';
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
      initialRoute: '/', // Awal: SplashScreen
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/riwayat': (context) => RiwayatPage(),
        '/edukasi': (context) => EdukasiPage(),
      },
    );
  }
}