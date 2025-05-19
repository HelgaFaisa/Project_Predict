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

  if (userData != null) {
    // Simpan patient_id jika ada
    if (userData.containsKey('id')) {
      patientId = userData['id'].toString();
      await prefs.setString('patient_id', patientId);
      print('Berhasil menyimpan patient_id: $patientId');
    } else if (userData.containsKey('patient_id')) {
      patientId = userData['patient_id'].toString();
      await prefs.setString('patient_id', patientId);
      print('Berhasil menyimpan patient_id dari field patient_id: $patientId');
    } else {
      print('PERINGATAN: Field "id"/"patient_id" tidak ditemukan di userData.');
    }

    // ✅ Simpan nama user ke SharedPreferences
    if (userData.containsKey('name')) {
      await prefs.setString('user_name', userData['name']);
      print('Berhasil menyimpan user_name: ${userData['name']}');
    }
  }

  return {
    'token': token,
    'user': userData ?? {}
  };
}

  // --- METODE getPatientId DITAMBAHKAN DI SINI ---
  static Future<String?> getPatientId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Ambil patient_id yang sudah disimpan di _processLoginData
    return prefs.getString('patient_id');
  }
  // ---------------------------------------------

  // Anda juga bisa menambahkan metode untuk mengambil nama pengguna jika diperlukan di tempat lain
  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }
}
