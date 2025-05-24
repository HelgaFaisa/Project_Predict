import 'package:flutter/material.dart';
import '../api/lupapw_api.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  String _email = '';
  String _tempToken = '';
  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _email = args['email'] ?? '';
      _tempToken = args['temp_token'] ?? '';
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await ForgotPasswordService.resetPassword(
        email: _email,
        tempToken: _tempToken,
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
      );

      if (response.success) {
        _showSuccessDialog();
      } else {
        _showErrorDialog(response.message);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Berhasil'),
        content: const Text('Password berhasil direset. Silakan login dengan password baru Anda.'),
        actions: [
          TextButton(
            onPressed: () {
              // Kembali ke halaman login
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Login Sekarang'),
          ),
        ],
      ),
    );
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password harus mengandung huruf besar, huruf kecil, dan angka';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != _passwordController.text) {
      return 'Konfirmasi password tidak cocok';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // Disable back button
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                
                // Icon
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.green[600],
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_reset,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Title
                Text(
                  'Buat Password Baru',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                // Subtitle
                Text(
                  'Masukkan password baru untuk akun Anda',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 40),
                
                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    labelText: 'Password Baru',
                    hintText: 'Masukkan password baru',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() => _showPassword = !_showPassword);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green[600]!),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  validator: _validatePassword,
                ),
                
                const SizedBox(height: 16),
                
                // Confirm password field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_showConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Password',
                    hintText: 'Ulangi password baru',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() => _showConfirmPassword = !_showConfirmPassword);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.green[600]!),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  validator: _validateConfirmPassword,
                ),
                
                const SizedBox(height: 24),
                
                // Password requirements
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Syarat Password:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[700],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildPasswordRequirement('Minimal 8 karakter'),
                      const SizedBox(height: 4),
                      _buildPasswordRequirement('Mengandung huruf besar (A-Z)'),
                      const SizedBox(height: 4),
                      _buildPasswordRequirement('Mengandung huruf kecil (a-z)'),
                      const SizedBox(height: 4),
                      _buildPasswordRequirement('Mengandung angka (0-9)'),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Reset button
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _resetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      disabledBackgroundColor: Colors.grey[300],
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Reset Password',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordRequirement(String text) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 16,
          color: Colors.blue[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.blue[700],
            ),
          ),
        ),
      ],
    );
  }
}