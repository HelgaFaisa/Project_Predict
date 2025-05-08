import 'dart:convert';
import 'package:http/http.dart' as http;

class EdukasiApi {
  static const String baseUrl = 'http://localhost:8000/api'; // aman karena kamu pakai Chrome

  static Future<List<dynamic>> getAllArticles() async {
    final response = await http.get(Uri.parse('$baseUrl/edukasi'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal memuat data edukasi');
    }
  }
}
