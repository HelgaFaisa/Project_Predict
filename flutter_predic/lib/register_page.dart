import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  String errorText = '';

  void register() {
    // String name = nameController.text.trim();
    String username = usernameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    // Validasi form
    if ( username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        errorText = 'Semua field harus diisi!';
      });
      return;
    }

    // Validasi format email
    bool emailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    if (!emailValid) {
      setState(() {
        errorText = 'Format email tidak valid!';
      });
      return;
    }

    // Validasi password dan konfirmasi password
    if (password != confirmPassword) {
      setState(() {
        errorText = 'Password dan konfirmasi password tidak sama!';
      });
      return;
    }

    // Jika semua validasi berhasil, arahkan ke halaman biodata
    // Disini kita bisa menyimpan data registrasi ke database atau shared preferences
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registrasi berhasil! Silakan lengkapi biodata.'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Navigasi ke halaman biodata
    Navigator.pushReplacementNamed(context, '/biodata');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrasi'),
        backgroundColor: Color(0xFF1976D2),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1976D2),
              Color(0xFF42A5F5),
              Color(0xFF90CAF9),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Buat Akun Baru',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 3),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Form Registrasi
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 10),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Nama Lengkap
                          // TextField(
                          //   controller: nameController,
                          //   decoration: InputDecoration(
                          //     labelText: 'Nama Lengkap',
                          //     prefixIcon: Icon(Icons.person),
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(15),
                          //     ),
                          //     filled: true,
                          //     fillColor: Colors.white,
                          //   ),
                          // ),
                          // SizedBox(height: 15),
                          
                          // Username
                          TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.account_circle),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          SizedBox(height: 15),
                          
                          // Email
                          TextField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          SizedBox(height: 15),
                          
                          // Password
                          TextField(
                            controller: passwordController,
                            obscureText: !isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isPasswordVisible 
                                      ? Icons.visibility_off 
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          SizedBox(height: 15),
                          
                          // Konfirmasi Password
                          TextField(
                            controller: confirmPasswordController,
                            obscureText: !isConfirmPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Konfirmasi Password',
                              prefixIcon: Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  isConfirmPasswordVisible 
                                      ? Icons.visibility_off 
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    isConfirmPasswordVisible = !isConfirmPasswordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),

                          // Register Button
                          Container(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                'Daftar',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          
                          SizedBox(height: 15),
                          
                          // Kembali ke Login
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Sudah punya akun? Login',
                              style: TextStyle(
                                color: Colors.blue[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          
                          if (errorText.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Text(
                                errorText,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
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