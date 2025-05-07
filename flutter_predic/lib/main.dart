import 'package:flutter/material.dart';
import 'splashscreen_page.dart'; // Import SplashScreen
import 'login_page.dart'; // Halaman welcome dengan tombol Login dan Register
import 'login.dart'; // Form Login terpisah
import 'register_page.dart'; // Import register page
import 'biodata.dart'; // Import biodata page
import 'home_page.dart'; // Halaman utama setelah login
import 'riwayat.dart'; // Import halaman Riwayat Pemeriksaan
import 'edukasi.dart';
import 'targethidup.dart';
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
        '/riwayat_pemeriksaan': (context) => RiwayatPemeriksaanPage(), // Menambahkan halaman Riwayat Pemeriksaan
        '/edukasi': (context) => EdukasiPage(),
        '/targethidup': (context) => TargetHidupSehatPage(),
        '/gejala': (context) => DiagnosisPage(),
      },
    );
  }
}
