// File: gejala_api.dart
// Service untuk mengambil data Gejala dari API

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/gejala.dart';

class GejalaApi {
  // URL API yang dapat diubah melalui konfigurasi
  // Pastikan URL sesuai dengan Laravel yang berjalan
  static const String baseUrl = 'http://localhost:8000/api';
  static const String endpoint = '/gejala';

  // Singleton pattern untuk memastikan hanya ada satu instance
  static final GejalaApi _instance = GejalaApi._internal();
  factory GejalaApi() => _instance;
  GejalaApi._internal();

  // Mendapatkan semua gejala aktif
  Future<List<Gejala>> getAllGejala() async {
    try {
      // Tambahkan logging untuk debug
      print('Fetching data from: $baseUrl$endpoint');

      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Accept': 'application/json'},
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Gejala.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil data: Status ${response.statusCode}, Response: ${response.body}');
      }
    } catch (e) {
      print('Error dalam getAllGejala: $e');
      throw Exception('Error: $e');
    }
  }

  // Mendapatkan gejala berdasarkan ID
  Future<Gejala> getGejalaById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint/$id'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Gejala.fromJson(data);
      } else {
        throw Exception('Gagal mengambil data gejala: Status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Mendapatkan hanya gejala yang aktif
  Future<List<Gejala>> getActiveGejala() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint/aktif'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Gejala.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil data gejala aktif: Status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Method untuk menyegarkan data (refresh) - berguna untuk memperbarui data setelah perubahan di web
  Future<List<Gejala>> refreshGejala() async {
    return await getAllGejala();
  }

  // Metode tambahan untuk pengembangan lebih lanjut:

  // Untuk mendapatkan gejala berdasarkan halaman (pagination)
  Future<List<Gejala>> getGejalaByPage(int page, int perPage) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint?page=$page&per_page=$perPage'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Gejala.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil data: Status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Mencari gejala berdasarkan kata kunci
  Future<List<Gejala>> searchGejala(String keyword) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint?search=$keyword'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Gejala.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mencari data: Status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}