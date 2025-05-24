import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginApi {
  // Pastikan URL sesuai dengan server Anda.
  // Ganti 'http://localhost:8000/api' berdasarkan lingkungan Anda:
  // - Untuk Android Emulator: 'http://10.0.2.2:8000/api'
  // - Untuk iOS Simulator / Web / Desktop: 'http://localhost:8000/api' atau 'http://127.0.0.1:8000/api'
  // - Untuk Perangkat Android Fisik: 'http://<IP_Lokal_Komputer_Anda>:8000/api'
  static const baseUrl = 'http://localhost:8000/api';

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
    String? token = data['access_token']; // Asumsi API mengembalikan 'access_token'
    Map<String, dynamic>? userData = data['user'] as Map<String, dynamic>?;
    String? patientId;

    print('Seluruh userData dari respons login: $userData');

    if (token != null) {
      await prefs.setString('token', token); // Menyimpan token dengan key 'token'
      print('Berhasil menyimpan token: ${token.substring(0, token.length > 10 ? 10 : token.length)}...');
    } else {
      print('PERINGATAN: Field "access_token" tidak ditemukan di respons login.');
    }

    if (userData != null) {
      // Simpan patient_id jika ada (prioritas 'id', lalu 'patient_id')
      if (userData.containsKey('id')) {
        patientId = userData['id'].toString();
        await prefs.setString('patient_id', patientId);
        print('Berhasil menyimpan patient_id: $patientId');
      } else if (userData.containsKey('patient_id')) {
        patientId = userData['patient_id'].toString();
        await prefs.setString('patient_id', patientId);
        print('Berhasil menyimpan patient_id dari field patient_id: $patientId');
      } else {
        print('PERINGATAN: Field "id" atau "patient_id" tidak ditemukan di userData.');
      }

      // Simpan nama user ke SharedPreferences
      if (userData.containsKey('name')) {
        await prefs.setString('user_name', userData['name']);
        print('Berhasil menyimpan user_name: ${userData['name']}');
      } else {
        print('PERINGATAN: Field "name" tidak ditemukan di userData.');
      }
    } else {
      print('PERINGATAN: Field "user" tidak ditemukan di respons login.');
    }

    return {
      'token': token,
      'user': userData ?? {}
    };
  }

  // --- METODE getPatientId ---
  // Digunakan untuk mengambil patient_id yang telah disimpan
  static Future<String?> getPatientId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('patient_id');
  }

  // --- METODE getUserName ---
  // Digunakan untuk mengambil user_name yang telah disimpan
  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  // --- METODE getToken ---
  // Digunakan untuk mengambil token autentikasi yang telah disimpan
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Mengambil token yang disimpan dengan key 'token'
  }

  // --- METODE logout ---
  // Digunakan untuk menghapus semua data sesi (token, patient_id, user_name) saat logout
  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('patient_id');
    await prefs.remove('user_name');
    print('Semua data sesi dihapus (token, patient_id, user_name).');
  }
}