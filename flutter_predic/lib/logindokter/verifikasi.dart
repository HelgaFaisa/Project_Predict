import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../api/lupapw_api.dart';

class VerifyResetCodeScreen extends StatefulWidget {
  const VerifyResetCodeScreen({Key? key}) : super(key: key);

  @override
  State<VerifyResetCodeScreen> createState() => _VerifyResetCodeScreenState();
}

class _VerifyResetCodeScreenState extends State<VerifyResetCodeScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  
  String _email = '';
  bool _isLoading = false;
  bool _canResend = false;
  int _resendCountdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _email = args['email'] ?? '';
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendCountdown = 60;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  String get _verificationCode {
    return _controllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyCode() async {
    final code = _verificationCode;
    if (code.length != 6) {
      _showErrorDialog('Mohon masukkan kode verifikasi lengkap');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await ForgotPasswordService.verifyResetCode(_email, code);

      if (response.success) {
        // Navigasi ke halaman reset password
        Navigator.pushReplacementNamed(
          context,
          '/reset-password',
          arguments: {
            'email': _email,
            'temp_token': response.tempToken,
          },
        );
      } else {
        _showErrorDialog(response.message);
        _clearCode();
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resendCode() async {
    if (!_canResend) return;

    setState(() => _isLoading = true);

    try {
      final response = await ForgotPasswordService.resendCode(_email);

      if (response.success) {
        _showSuccessDialog('Kode verifikasi baru telah dikirim');
        _clearCode();
        _startResendTimer();
      } else {
        if (response.waitSeconds != null) {
          _showErrorDialog('${response.message}\nSilakan tunggu ${response.waitSeconds} detik');
        } else {
          _showErrorDialog(response.message);
        }
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearCode() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes.first.requestFocus();
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

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Berhasil'),
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

  Widget _buildCodeInput(int index) {
    return Container(
      width: 55,
      height: 65,
      decoration: BoxDecoration(
        border: Border.all(
          color: _controllers[index].text.isNotEmpty 
              ? Colors.green[600]! 
              : Colors.grey[300]!,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
        color: _controllers[index].text.isNotEmpty 
            ? Colors.green[50] 
            : Colors.grey[50],
      ),
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          counterText: '',
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            // Move to next field
            if (index < 5) {
              _focusNodes[index + 1].requestFocus();
            } else {
              // All fields filled, verify automatically
              _focusNodes[index].unfocus();
              if (_verificationCode.length == 6) {
                _verifyCode();
              }
            }
          } else {
            // Move to previous field if current is empty
            if (index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
          }
          setState(() {});
        },
        onTap: () {
          // Clear field when tapped
          _controllers[index].clear();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi Kode'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              
              // Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.mark_email_read,
                  size: 60,
                  color: Colors.green[600],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Title
              Text(
                'Verifikasi Email',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Subtitle
              Text(
                'Masukkan 6 digit kode verifikasi yang telah dikirim ke:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              // Email
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Code input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) => _buildCodeInput(index)),
              ),
              
              const SizedBox(height: 40),
              
              // Verify button - UKURAN DIPERBESAR
              Container(
                height: 56, // Tinggi minimum untuk touch target
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18), // Padding diperbesar
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    shadowColor: Colors.green[300],
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Verifikasi Kode',
                          style: TextStyle(
                            fontSize: 18, // Font size diperbesar
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Resend code section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tidak menerima kode? ',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                      ),
                    ),
                    GestureDetector(
                      onTap: _canResend && !_isLoading ? _resendCode : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: _canResend ? Colors.green[50] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _canResend 
                              ? 'Kirim Ulang' 
                              : 'Kirim Ulang ($_resendCountdown)',
                          style: TextStyle(
                            color: _canResend ? Colors.green[700] : Colors.grey[400],
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Back button - UKURAN DIPERBESAR
              Container(
                height: 48, // Tinggi minimum untuk touch target
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Kembali',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontWeight: FontWeight.w500,
                      fontSize: 16, // Font size diperbesar
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}