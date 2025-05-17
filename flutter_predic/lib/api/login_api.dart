import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginApi {
  static const baseUrl = 'http://localhost:8000/api'; // Pastikan URL sesuai dengan server Anda

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'), // Fokus pada endpoint /api/login
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print('HTTP Status (Login API): ${response.statusCode}');
      print('Response body (Login API): ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return await _processLoginData(data);
      } else if (response.statusCode == 401) {
        throw Exception('Email atau password salah');
      } else {
        throw Exception('Gagal login: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during login (Login API): $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> _processLoginData(Map<String, dynamic> data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = data['access_token'];
    Map<String, dynamic>? userData = data['user'] as Map<String, dynamic>?;
    String? patientId;

    print('Seluruh userData dari respons login: $userData');

    if (token != null) {
      await prefs.setString('token', token);
      print('Berhasil menyimpan token: ${token.substring(0, token.length > 10 ? 10 : token.length)}...');
    }

    if (userData != null && userData.containsKey('id')) {
      patientId = userData['id'].toString();
      await prefs.setString('patient_id', patientId);
      print('Berhasil menyimpan patient_id: $patientId');
    } else {
      print('PERINGATAN: Field "id" tidak ditemukan di userData.');
    }

    return {
      'token': token,
      'user': userData ?? {}
    };
  }

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<String?> getPatientId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final patientId = prefs.getString('patient_id');
    print('patient_id diambil dari SharedPreferences (LoginApi.getPatientId()): $patientId');
    return patientId;
  }
}