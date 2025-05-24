import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPasswordService {
  static const String baseUrl = 'http://localhost:8000/api'; // Sesuaikan dengan URL server Anda
  
  // Headers untuk request
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Kirim kode reset ke email
  static Future<ForgotPasswordResponse> sendResetCode(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/password/forgot'), // Sesuai dengan route Laravel
        headers: _headers,
        body: jsonEncode({'email': email}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ForgotPasswordResponse(
          success: true,
          message: data['message'],
          email: data['email'],
        );
      } else {
        return ForgotPasswordResponse(
          success: false,
          message: data['message'] ?? 'Terjadi kesalahan',
        );
      }
    } catch (e) {
      print('Error: $e');
      return ForgotPasswordResponse(
        success: false,
        message: 'Tidak dapat terhubung ke server: $e',
      );
    }
  }

  /// Verifikasi kode reset
  static Future<VerifyCodeResponse> verifyResetCode(String email, String code) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/password/verify-code'),
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'code': code,
        }),
      );

      print('Verify Response status: ${response.statusCode}');
      print('Verify Response body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return VerifyCodeResponse(
          success: true,
          message: data['message'],
          tempToken: data['temp_token'],
        );
      } else {
        return VerifyCodeResponse(
          success: false,
          message: data['message'] ?? 'Kode verifikasi tidak valid',
        );
      }
    } catch (e) {
      print('Verify Error: $e');
      return VerifyCodeResponse(
        success: false,
        message: 'Tidak dapat terhubung ke server: $e',
      );
    }
  }

  /// Reset password
  static Future<ResetPasswordResponse> resetPassword({
    required String email,
    required String tempToken,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/password/reset'),
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'temp_token': tempToken,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      print('Reset Response status: ${response.statusCode}');
      print('Reset Response body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ResetPasswordResponse(
          success: true,
          message: data['message'],
        );
      } else {
        return ResetPasswordResponse(
          success: false,
          message: data['message'] ?? 'Gagal mereset password',
        );
      }
    } catch (e) {
      print('Reset Error: $e');
      return ResetPasswordResponse(
        success: false,
        message: 'Tidak dapat terhubung ke server: $e',
      );
    }
  }

  /// Kirim ulang kode reset
  static Future<ForgotPasswordResponse> resendCode(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/password/resend-code'),
        headers: _headers,
        body: jsonEncode({'email': email}),
      );

      print('Resend Response status: ${response.statusCode}');
      print('Resend Response body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ForgotPasswordResponse(
          success: true,
          message: data['message'],
          email: email,
        );
      } else if (response.statusCode == 429) {
        return ForgotPasswordResponse(
          success: false,
          message: data['message'],
          waitSeconds: data['wait_seconds'],
        );
      } else {
        return ForgotPasswordResponse(
          success: false,
          message: data['message'] ?? 'Gagal mengirim ulang kode',
        );
      }
    } catch (e) {
      print('Resend Error: $e');
      return ForgotPasswordResponse(
        success: false,
        message: 'Tidak dapat terhubung ke server: $e',
      );
    }
  }
}

// Response Models
class ForgotPasswordResponse {
  final bool success;
  final String message;
  final String? email;
  final int? waitSeconds;

  ForgotPasswordResponse({
    required this.success,
    required this.message,
    this.email,
    this.waitSeconds,
  });
}

class VerifyCodeResponse {
  final bool success;
  final String message;
  final String? tempToken;

  VerifyCodeResponse({
    required this.success,
    required this.message,
    this.tempToken,
  });
}

class ResetPasswordResponse {
  final bool success;
  final String message;

  ResetPasswordResponse({
    required this.success,
    required this.message,
  });
}