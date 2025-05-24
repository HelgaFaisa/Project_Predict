// lib/api/health_data_api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/health_data.dart';
import 'login_api.dart'; // Import LoginApi untuk mengambil token autentikasi

class HealthDataApi {
  // ... (bagian baseUrl dan endpoint, tidak berubah)
  static const String baseUrl = 'http://localhost:8000/api'; // Pastikan ini sesuai
  static const String endpoint = '/patient_health_data'; 

  static final HealthDataApi _instance = HealthDataApi._internal();
  factory HealthDataApi() => _instance;
  HealthDataApi._internal();

  Future<List<HealthData>> fetchHealthData(String patientId) async {
    final String? token = await LoginApi.getToken();

    if (token == null || token.isEmpty) {
      print('Error: Token autentikasi tidak ditemukan. Mohon login kembali.');
      throw Exception('Autentikasi diperlukan: Token tidak ditemukan.');
    }

    try {
      final uri = Uri.parse('$baseUrl$endpoint?patient_id=$patientId');
      print('Fetching health data from: $uri with token.');

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status code for health data: ${response.statusCode}');
      print('Response body for health data: ${response.body}');

      if (response.statusCode == 200) {
        // --- PERUBAHAN UTAMA DI SINI ---
        final Map<String, dynamic> responseData = jsonDecode(response.body); // Sekarang decode sebagai Map

        // Asumsi array data kesehatan berada di dalam kunci 'predictions'
        if (responseData.containsKey('predictions') && responseData['predictions'] is List) {
          final List<dynamic> healthDataList = responseData['predictions'];
          return healthDataList.map((json) => HealthData.fromJson(json)).toList();
        } 
        // Jika API Anda mengembalikan di kunci 'data' seperti { "status": true, "data": [...] }
        else if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> healthDataList = responseData['data'];
          return healthDataList.map((json) => HealthData.fromJson(json)).toList();
        }
        // Jika tidak ada kunci yang sesuai, atau bukan List
        else {
          throw Exception('Format respons API tidak sesuai. Tidak ditemukan array data kesehatan di kunci "predictions" atau "data".');
        }
        // --- AKHIR PERUBAHAN UTAMA ---

      } else if (response.statusCode == 401) {
        throw Exception('Autentikasi gagal (Status 401): Token tidak valid atau kadaluarsa. Mohon login kembali.');
      } else {
        throw Exception('Gagal mengambil data kesehatan: Status ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('Error dalam fetchHealthData: $e');
      // Penting: Tangkap TypeError spesifik jika masih ada dan cetak detailnya
      if (e is TypeError) {
        print('Detail TypeError: ${e.runtimeType} ${e.toString()}');
      }
      throw Exception('Error: $e');
    }
  }
}