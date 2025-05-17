import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfileApi {
  // Mengubah baseUrl untuk konsistensi dengan LoginApi
  static const baseUrl = 'http://localhost:8000/api';
  
  static Future<Map<String, dynamic>> getProfile(String patientId, String token) async {
    // Check if patientId is properly formatted
    if (patientId.isEmpty) {
      throw Exception('ID Pasien tidak valid');
    }
    
    // Mengubah endpoint URL sesuai dengan routes yang terdaftar di Laravel
    // Endpoint yang benar adalah "/patient/profile" bukan "/patients/{id}"
    final url = '$baseUrl/patient/profile';
    
    try {
      // Enhanced logging for debugging
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
      
      // Log response for debugging
      print('Response status code: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        
        // Debug the response
        print('Profile API Response: $responseData');
        
        // Verify response structure
        if (responseData is Map<String, dynamic>) {
          return responseData;
        } else {
          throw Exception('Format respons tidak sesuai yang diharapkan');
        }
      } else {
        // More detailed error information
        print('Error response body: ${response.body}');
        
        // Parse error message if possible
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
  
  // Fungsi tambahan untuk testing API
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