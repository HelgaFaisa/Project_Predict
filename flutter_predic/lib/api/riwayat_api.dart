import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/riwayat_model.dart'; // Pastikan path ke model Riwayat benar

class RiwayatApi {
  static const baseUrl = 'http://localhost:8000/api'; // Pastikan URL sesuai dengan server Anda

  static Future<List<PrediksiRiwayat>> getCurrentUserHistory() async {
    final token = await _getToken();

    print('Token di getCurrentUserHistory (sebelum request): $token');

    if (token == null || token.isEmpty) {
      print('Error: Token tidak ditemukan.');
      return [];
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    // Hapus parameter patient_id dari URL
    final Uri uri = Uri.parse('$baseUrl/patient/prediction-history');

    print('Requesting riwayat dari: $uri');
    print('Authorization Header: $headers');

    try {
      final response = await http.get(uri, headers: headers);

      print('HTTP Status (Riwayat API): ${response.statusCode}');
      print('Response body (Riwayat API): ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['data'] != null) {
          List<PrediksiRiwayat> riwayatList = (responseData['data'] as List)
              .map((item) => PrediksiRiwayat.fromJson(item))
              .toList();
          return riwayatList;
        } else if (responseData['success'] == true && responseData['data'] == null) {
          return []; // Tidak ada riwayat
        } else {
          throw Exception('Gagal memuat riwayat: ${responseData['message'] ?? 'Terjadi kesalahan'}');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Tidak terautentikasi');
      } else if (response.statusCode == 404) {
        return []; // Riwayat tidak ditemukan (mungkin endpoint benar tapi data tidak ada)
      } else {
        throw Exception('Gagal memuat riwayat: Status ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching riwayat (Riwayat API): $e');
      return [];
    }
  }

  static Future<String?> _getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}