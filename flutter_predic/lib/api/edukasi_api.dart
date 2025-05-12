import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class EdukasiApi {
  // Ubah baseURL sesuai dengan alamat server Anda
  // 10.0.2.2 adalah alamat localhost dari emulator Android
  // Untuk iOS simulator, gunakan http://localhost:8000/api
static const String baseUrl = 'http://localhost:8000/api';
  static Future<List<dynamic>> getAllArticles() async {
    try {
      print('Mencoba akses API: $baseUrl/edukasi');

      // Tambahkan timeout untuk menghindari menunggu terlalu lama
      final response = await http.get(
        Uri.parse('$baseUrl/edukasi'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 15), onTimeout: () {
        throw SocketException('Koneksi timeout. Periksa koneksi internet Anda.');
      });

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Decode response JSON
        final decodedData = jsonDecode(response.body);

        // Handle berbagai format respons API
        if (decodedData is List) {
          // Jika respons langsung berupa array
          return decodedData;
        } else if (decodedData is Map) {
          // Jika respons dalam format {data: [...]}
          if (decodedData.containsKey('data')) {
            return decodedData['data'];
          }
          // Jika format lain yang berisi array (misalnya {items: [...]})
          // Anda bisa menambahkan kondisi lain di sini sesuai dengan struktur API Anda
          print('Format respons tidak dikenal: $decodedData');
          return [];
        } else {
          print('Format respons tidak dikenal: $decodedData');
          return [];
        }
      } else if (response.statusCode == 404) {
        throw Exception('Endpoint API tidak ditemukan. Periksa URL API Anda.');
      } else {
        throw Exception('Gagal memuat data edukasi. Status code: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      print('Socket Exception: $e');
      throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet Anda atau pastikan server berjalan.');
    } on FormatException catch (e) {
      print('Format Exception: $e');
      throw Exception('Format respons API tidak valid.');
    } catch (e) {
      print('General Exception: $e');
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  static Future<Map<String, dynamic>> getArticleDetail(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/edukasi/$id'),
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final dynamic decodedData = jsonDecode(response.body);

        if (decodedData is Map) {
          // Jika respons memiliki key 'data' yang berisi detail artikel
          if (decodedData.containsKey('data')) {
            if (decodedData['data'] is Map<String, dynamic>) {
              return decodedData['data'];
            } else {
              throw Exception('Format data detail artikel di dalam "data" tidak valid.');
            }
          }
          // Jika respons langsung berupa detail artikel (tanpa key 'data')
          if (decodedData is Map<String, dynamic>) {
            return decodedData;
          } else {
            throw Exception('Format respons detail artikel tidak sesuai dengan Map<String, dynamic>.');
          }
        } else {
          throw Exception('Format respons detail artikel tidak valid.');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Detail artikel tidak ditemukan.');
      } else {
        throw Exception('Gagal memuat detail artikel. Status code: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      throw Exception('Tidak dapat terhubung ke server saat mengambil detail artikel.');
    } on FormatException catch (e) {
      throw Exception('Format respons detail artikel dari server tidak valid.');
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil detail artikel: $e');
    }
  }
}