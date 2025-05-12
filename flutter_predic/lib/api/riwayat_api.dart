import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/pemeriksaan_model.dart'; // Ganti dengan path yang benar

class RiwayatApi {
  static const String baseUrl = 'http://localhost:8000/api';

  Future<List<Pemeriksaan>> getRiwayat(int idPasien) async {
    final url = Uri.parse('$baseUrl/riwayat/$idPasien');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> rawData = jsonDecode(response.body);
        // Konversi setiap item JSON menjadi objek Pemeriksaan
        final List<Pemeriksaan> riwayat = rawData.map((json) => Pemeriksaan.fromJson(json)).toList();
        return riwayat;
      } else {
        print('Gagal mengambil riwayat. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Terjadi kesalahan saat menghubungi API: $e');
      return [];
    }
  }
}