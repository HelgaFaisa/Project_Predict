// lib/main.dart - VERSI DENGAN ROUTING DINAMIS + EDUCATION DETAIL

import 'package:flutter/material.dart';
import 'package:flutter_predic/model/ProfileEdit.dart';
import 'splashscreen_page.dart';
import 'home_page.dart';
import 'logindokter/login.dart';
import 'logindokter/lupapw.dart';
import 'logindokter/resetscreen.dart';
import 'logindokter/verifikasi.dart';
import 'riwayatpemeriksaan/riwayat.dart';
import 'api/riwayat_api.dart';
import 'api/login_api.dart';
import 'edukasi/edukasi.dart';
import 'edukasi/ArtikelDetailPage.dart';
// PERBAIKAN: Import EducationDetailScreen dan model
// import 'screens/education_detail_screen.dart';
import 'model/edukasiartikel.dart';
import 'api/edukasi_api.dart';
import 'api/gejala_api.dart';
import 'gejala/gejala_page.dart';
import 'model/gejala.dart';
import 'target/targethidup.dart';
import 'model/ProfileEdit.dart';
import 'model/ProfileHeader.dart';
import '../logindokter/profile.dart';
import 'package:intl/date_symbol_data_local.dart';
Future<void> main() async { // Tambahkan async
  // Pastikan Flutter bindings sudah siap sebelum menjalankan kode async apa pun
  WidgetsFlutterBinding.ensureInitialized(); 

  // Inisialisasi data lokalisasi untuk Bahasa Indonesia
  await initializeDateFormatting('id_ID', null); 

  runApp( MyApp()); // Ganti MyApp dengan nama class root aplikasi Anda
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DiabetaCare',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/verify-reset-code': (context) => const VerifyResetCodeScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
        '/home': (context) => HomePage(
          userName: 'Pengguna Default',
          patientId: 'default_patient_id',
          userRole: 'Peran Default',
        ),
        //'/edukasi': (context) => EducationListScreen(), // Jika EducationListScreen tidak butuh parameter
        //'/gejala': (context) => GejalaPage(),       // Jika GejalaPage tidak butuh parameter
        // '/gejala': (context) => GejalaPage(),
        // '/target': (context) => TargetHidupPage(),
      },
      // PERBAIKAN: Tambahkan route untuk education-detail dan lainnya
      onGenerateRoute: (settings) {
        switch (settings.name) {
          // ROUTE BARU: Education Detail
          case '/education-detail':
            final article = settings.arguments as EducationArticle?;
            return MaterialPageRoute(
              builder: (context) => EducationDetailScreen(article: article),
              settings: settings,
            );
          
          case '/profile':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => ProfilePage(
                userName: args?['userName'],
                userRole: args?['userRole'],
                patientId: args?['patientId'],
              ),
            );
          
          case '/edit-profile':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => ProfileEditPage(
                userName: args?['userName'] ?? 'Pengguna',
                userRole: args?['userRole'] ?? 'Pasien',
                patientId: args?['patientId'] ?? '',
              ),
            );
          
          case '/change-password':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => ChangePasswordPage(
                patientId: args?['patientId'] ?? '',
              ),
            );
          
          // ROUTE TAMBAHAN: Jika ada route artikel detail lain
          case '/artikel-detail':
            final args = settings.arguments as Map<String, dynamic>?;
            return MaterialPageRoute(
              builder: (context) => EducationDetailScreen(
                articleId: args?['articleId'],
                articleSlug: args?['articleSlug'],
              ),
            );
          
          default:
            return null;
        }
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text('Halaman Tidak Ditemukan'),
              backgroundColor: Colors.red[700],
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
                    SizedBox(height: 20),
                    Text(
                      'Halaman Tidak Ditemukan',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Route "${settings.name}" tidak dapat ditemukan',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pushReplacementNamed(context, '/'),
                      icon: Icon(Icons.home),
                      label: Text('Kembali ke Beranda'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Kembali ke Halaman Sebelumnya'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// PERBAIKAN: ProfileEditPage dengan data dinamis
class ProfileEditPage extends StatefulWidget {
  final String userName;
  final String userRole;
  final String patientId;

  const ProfileEditPage({
    Key? key,
    required this.userName,
    required this.userRole,
    required this.patientId,
  }) : super(key: key);

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profil'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue[100],
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.blue[700],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.blue[700],
                      child: Icon(
                        Icons.camera_alt,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            
            // Form Fields
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nama Lengkap',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 16),
            
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 16),
            
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Nomor Telepon',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            SizedBox(height: 16),
            
            // Patient ID (Read Only)
            TextField(
              enabled: false,
              decoration: InputDecoration(
                labelText: 'ID Pasien',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
                hintText: widget.patientId,
              ),
            ),
            SizedBox(height: 30),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Implement save profile logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Profil berhasil diperbarui'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  'Simpan Perubahan',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// PERBAIKAN: ChangePasswordPage dengan data dinamis
class ChangePasswordPage extends StatefulWidget {
  final String patientId;

  const ChangePasswordPage({
    Key? key,
    required this.patientId,
  }) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubah Password'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Current Password
              TextFormField(
                controller: _currentPasswordController,
                obscureText: _obscureCurrentPassword,
                decoration: InputDecoration(
                  labelText: 'Password Saat Ini',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureCurrentPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureCurrentPassword = !_obscureCurrentPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password saat ini harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // New Password
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                decoration: InputDecoration(
                  labelText: 'Password Baru',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureNewPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password baru harus diisi';
                  }
                  if (value.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Confirm Password
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password Baru',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi password harus diisi';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Password tidak cocok';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              
              // Change Password Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Implement change password logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Password berhasil diubah'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    'Ubah Password',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}