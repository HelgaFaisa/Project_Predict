// services/education_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/edukasiartikel.dart';

class EducationService {
  static const String baseUrl = 'http://localhost:8000/api';
  static const String edukasiEndpoint = '$baseUrl/edukasi';

  // Headers default untuk API
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Mendapatkan semua artikel dengan pagination dan filter
  static Future<ApiResponse<List<EducationArticle>>> getArticles({
    int page = 1,
    int perPage = 10,
    String? category,
    String? search,
  }) async {
    try {
      // Build query parameters
      Map<String, String> queryParams = {
        'page': page.toString(),
        'per_page': perPage.toString(),
      };

      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }

      // Build URI dengan query parameters
      final uri = Uri.parse(edukasiEndpoint).replace(
        queryParameters: queryParams,
      );

      print('Making request to: $uri'); // Debug log

      final response = await http.get(uri, headers: headers).timeout(
        const Duration(seconds: 30),
      );

      print('Response status: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        return ApiResponse<List<EducationArticle>>(
          success: jsonData['success'] ?? false,
          message: jsonData['message'] ?? '',
          data: jsonData['data'] != null
              ? (jsonData['data'] as List)
                  .map((item) => EducationArticle.fromJson(item))
                  .toList()
              : [],
          pagination: jsonData['pagination'] != null
              ? PaginationInfo.fromJson(jsonData['pagination'])
              : null,
        );
      } else {
        final errorData = json.decode(response.body);
        return ApiResponse<List<EducationArticle>>(
          success: false,
          message: errorData['message'] ?? 'Gagal memuat data',
          error: errorData['error'],
        );
      }
    } on SocketException {
      return ApiResponse<List<EducationArticle>>(
        success: false,
        message: 'Tidak dapat terhubung ke server. Pastikan server Laravel berjalan di localhost:8000',
        error: 'Connection failed',
      );
    } on http.ClientException {
      return ApiResponse<List<EducationArticle>>(
        success: false,
        message: 'Gagal menghubungi server',
        error: 'Client error',
      );
    } catch (e) {
      print('Error in getArticles: $e'); // Debug log
      return ApiResponse<List<EducationArticle>>(
        success: false,
        message: 'Terjadi kesalahan: ${e.toString()}',
        error: e.toString(),
      );
    }
  }

  // Mendapatkan artikel berdasarkan ID
  static Future<ApiResponse<EducationArticle>> getArticleById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$edukasiEndpoint/$id'),
        headers: headers,
      ).timeout(const Duration(seconds: 30));

      print('Get article by ID response: ${response.statusCode}'); // Debug log

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        return ApiResponse<EducationArticle>(
          success: jsonData['success'] ?? false,
          message: jsonData['message'] ?? '',
          data: jsonData['data'] != null
              ? EducationArticle.fromJson(jsonData['data'])
              : null,
        );
      } else if (response.statusCode == 404) {
        return ApiResponse<EducationArticle>(
          success: false,
          message: 'Artikel tidak ditemukan',
        );
      } else {
        final errorData = json.decode(response.body);
        return ApiResponse<EducationArticle>(
          success: false,
          message: errorData['message'] ?? 'Gagal memuat artikel',
          error: errorData['error'],
        );
      }
    } catch (e) {
      print('Error in getArticleById: $e'); // Debug log
      return ApiResponse<EducationArticle>(
        success: false,
        message: 'Terjadi kesalahan: ${e.toString()}',
        error: e.toString(),
      );
    }
  }

  // Mendapatkan artikel berdasarkan slug
  static Future<ApiResponse<EducationArticle>> getArticleBySlug(String slug) async {
    try {
      final response = await http.get(
        Uri.parse('$edukasiEndpoint/slug/$slug'),
        headers: headers,
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        return ApiResponse<EducationArticle>(
          success: jsonData['success'] ?? false,
          message: jsonData['message'] ?? '',
          data: jsonData['data'] != null
              ? EducationArticle.fromJson(jsonData['data'])
              : null,
        );
      } else if (response.statusCode == 404) {
        return ApiResponse<EducationArticle>(
          success: false,
          message: 'Artikel tidak ditemukan',
        );
      } else {
        final errorData = json.decode(response.body);
        return ApiResponse<EducationArticle>(
          success: false,
          message: errorData['message'] ?? 'Gagal memuat artikel',
          error: errorData['error'],
        );
      }
    } catch (e) {
      return ApiResponse<EducationArticle>(
        success: false,
        message: 'Terjadi kesalahan: ${e.toString()}',
        error: e.toString(),
      );
    }
  }

  // Mendapatkan daftar kategori
  static Future<ApiResponse<List<String>>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$edukasiEndpoint/categories'),
        headers: headers,
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        return ApiResponse<List<String>>(
          success: jsonData['success'] ?? false,
          message: jsonData['message'] ?? '',
          data: jsonData['data'] != null
              ? List<String>.from(jsonData['data'])
              : [],
        );
      } else {
        final errorData = json.decode(response.body);
        return ApiResponse<List<String>>(
          success: false,
          message: errorData['message'] ?? 'Gagal memuat kategori',
          error: errorData['error'],
        );
      }
    } catch (e) {
      return ApiResponse<List<String>>(
        success: false,
        message: 'Terjadi kesalahan: ${e.toString()}',
        error: e.toString(),
      );
    }
  }
}