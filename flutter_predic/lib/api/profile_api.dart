import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileApi {
  static const baseUrl = 'http://localhost:8000/api';

  // Hapus parameter patientId karena tidak dibutuhkan
  static Future<Map<String, dynamic>> getProfile(String token) async {
    final url = '$baseUrl/patient/profile';

    try {
      print('Fetching profile from: $url');
      print('Using token: ${token.length > 10 ? token.substring(0, 10) + '...' : token}');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Profile API Response: $responseData');

        if (responseData is Map<String, dynamic>) {
          return responseData;
        } else {
          throw Exception('Format respons tidak sesuai yang diharapkan');
        }
      } else {
        print('Error response body: ${response.body}');
        try {
          final errorData = json.decode(response.body);
          final errorMsg = errorData['message'] ?? 'Unknown error';
          throw Exception('Gagal memuat profil: ${response.statusCode} - $errorMsg');
        } catch (e) {
          throw Exception('Gagal memuat profil: ${response.statusCode} - ${response.body}');
        }
      }
    } catch (e) {
      print('Exception detail: $e');
      throw Exception('Error jaringan: $e');
    }
  }

  // Test endpoint tanpa otentikasi → akan gagal jika pakai auth:api
  static Future<bool> testEndpoint() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/patient/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('Test API endpoint response: ${response.statusCode}');
      print('Test API response body: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('API test failed: $e');
      return false;
    }
  }
}
