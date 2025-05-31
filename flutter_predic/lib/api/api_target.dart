import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiTarget {
  // Base URL - sesuaikan dengan URL backend Anda
  static const String baseUrl = 'http://localhost:8000/api';
  
  // Get headers with auth token
  static Future<Map<String, String>> _getHeaders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  // Handle API response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }

  // ====================================================================
  // HABIT CRUD OPERATIONS
  // ====================================================================

  /// Get all habits
  static Future<List<Map<String, dynamic>>> getAllHabits() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/habits'),
        headers: headers,
      );

      final result = _handleResponse(response);
      
      if (result['status'] == 200 && result['data'] != null) {
        return List<Map<String, dynamic>>.from(result['data']);
      }
      return [];
    } catch (e) {
      print('Error getting all habits: $e');
      rethrow;
    }
  }

  /// Get habit by ID
  static Future<Map<String, dynamic>?> getHabitById(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/habits/$id'),
        headers: headers,
      );

      final result = _handleResponse(response);
      
      if (result['status'] == 200 && result['data'] != null) {
        return result['data'];
      }
      return null;
    } catch (e) {
      print('Error getting habit by ID: $e');
      rethrow;
    }
  }

  /// Create new habit
  static Future<Map<String, dynamic>?> createHabit({
    required String title,
    required String description,
    required String category,
    required String targetType, // daily, weekly, monthly, yearly
    required int targetValue,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = json.encode({
        'title': title,
        'description': description,
        'category': category,
        'target_type': targetType,
        'target_value': targetValue,
      });

      final response = await http.post(
        Uri.parse('$baseUrl/habits'),
        headers: headers,
        body: body,
      );

      final result = _handleResponse(response);
      
      if (result['status'] == 201 && result['data'] != null) {
        return result['data'];
      }
      return null;
    } catch (e) {
      print('Error creating habit: $e');
      rethrow;
    }
  }

  /// Update habit
  static Future<bool> updateHabit({
    required String id,
    String? title,
    String? description,
    String? category,
    String? targetType,
    int? targetValue,
  }) async {
    try {
      final headers = await _getHeaders();
      Map<String, dynamic> body = {};
      
      if (title != null) body['title'] = title;
      if (description != null) body['description'] = description;
      if (category != null) body['category'] = category;
      if (targetType != null) body['target_type'] = targetType;
      if (targetValue != null) body['target_value'] = targetValue;

      final response = await http.put(
        Uri.parse('$baseUrl/habits/$id'),
        headers: headers,
        body: json.encode(body),
      );

      final result = _handleResponse(response);
      return result['status'] == 200;
    } catch (e) {
      print('Error updating habit: $e');
      rethrow;
    }
  }

  /// Delete habit
  static Future<bool> deleteHabit(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/habits/$id'),
        headers: headers,
      );

      final result = _handleResponse(response);
      return result['status'] == 200;
    } catch (e) {
      print('Error deleting habit: $e');
      rethrow;
    }
  }

  // ====================================================================
  // HABIT PROGRESS & COMPLETION
  // ====================================================================

  /// Update progress (increment)
  static Future<Map<String, dynamic>?> updateProgress({
    required String id,
    int increment = 1,
  }) async {
    try {
      final headers = await _getHeaders();
      final body = json.encode({
        'increment': increment,
      });

      final response = await http.post(
        Uri.parse('$baseUrl/habits/$id/progress'),
        headers: headers,
        body: body,
      );

      final result = _handleResponse(response);
      
      if (result['status'] == 200 && result['data'] != null) {
        return result['data'];
      }
      return null;
    } catch (e) {
      print('Error updating progress: $e');
      rethrow;
    }
  }

  /// Mark habit as completed (checklist)
  static Future<bool> markAsCompleted(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/habits/$id/complete'),
        headers: headers,
      );

      final result = _handleResponse(response);
      return result['status'] == 200;
    } catch (e) {
      print('Error marking as completed: $e');
      rethrow;
    }
  }

  /// Unmark habit as completed
  static Future<bool> unmarkAsCompleted(String id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/habits/$id/uncomplete'),
        headers: headers,
      );

      final result = _handleResponse(response);
      return result['status'] == 200;
    } catch (e) {
      print('Error unmarking as completed: $e');
      rethrow;
    }
  }

  // ====================================================================
  // HABIT FILTERING & QUERIES
  // ====================================================================

  /// Get habits by category
  static Future<List<Map<String, dynamic>>> getHabitsByCategory(String category) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/habits/category/$category'),
        headers: headers,
      );

      final result = _handleResponse(response);
      
      if (result['status'] == 200 && result['data'] != null) {
        return List<Map<String, dynamic>>.from(result['data']);
      }
      return [];
    } catch (e) {
      print('Error getting habits by category: $e');
      rethrow;
    }
  }

  /// Get completed habits
  static Future<List<Map<String, dynamic>>> getCompletedHabits() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/habits/status/completed'),
        headers: headers,
      );

      final result = _handleResponse(response);
      
      if (result['status'] == 200 && result['data'] != null) {
        return List<Map<String, dynamic>>.from(result['data']);
      }
      return [];
    } catch (e) {
      print('Error getting completed habits: $e');
      rethrow;
    }
  }

  /// Get user-specific habits (if using user-specific routes)
  static Future<List<Map<String, dynamic>>> getUserHabits() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/user/habits'),
        headers: headers,
      );

      final result = _handleResponse(response);
      
      if (result['status'] == 200 && result['data'] != null) {
        return List<Map<String, dynamic>>.from(result['data']);
      }
      return [];
    } catch (e) {
      print('Error getting user habits: $e');
      rethrow;
    }
  }

  /// Get user's completed habits
  static Future<List<Map<String, dynamic>>> getUserCompletedHabits() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/user/habits/completed'),
        headers: headers,
      );

      final result = _handleResponse(response);
      
      if (result['status'] == 200 && result['data'] != null) {
        return List<Map<String, dynamic>>.from(result['data']);
      }
      return [];
    } catch (e) {
      print('Error getting user completed habits: $e');
      rethrow;
    }
  }

  /// Get user habits by category
  static Future<List<Map<String, dynamic>>> getUserHabitsByCategory(String category) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/user/habits/category/$category'),
        headers: headers,
      );

      final result = _handleResponse(response);
      
      if (result['status'] == 200 && result['data'] != null) {
        return List<Map<String, dynamic>>.from(result['data']);
      }
      return [];
    } catch (e) {
      print('Error getting user habits by category: $e');
      rethrow;
    }
  }

  // ====================================================================
  // UTILITY METHODS
  // ====================================================================

  /// Reset all habits (admin/testing purpose)
  static Future<bool> resetAllHabits() async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/habits/reset-all'),
        headers: headers,
      );

      final result = _handleResponse(response);
      return result['status'] == 200;
    } catch (e) {
      print('Error resetting all habits: $e');
      rethrow;
    }
  }

  /// Get habit statistics (if implemented in backend)
  static Future<Map<String, dynamic>?> getUserHabitStats() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/user/habits/stats'),
        headers: headers,
      );

      final result = _handleResponse(response);
      
      if (result['status'] == 200 && result['data'] != null) {
        return result['data'];
      }
      return null;
    } catch (e) {
      print('Error getting habit stats: $e');
      rethrow;
    }
  }

  // ====================================================================
  // HELPER METHODS FOR TARGET TYPES
  // ====================================================================

  /// Get habits by target type
  static Future<List<Map<String, dynamic>>> getHabitsByTargetType({
    String targetType = 'daily',
  }) async {
    try {
      final allHabits = await getAllHabits();
      return allHabits.where((habit) => 
        habit['target_type'] == targetType
      ).toList();
    } catch (e) {
      print('Error filtering habits by target type: $e');
      rethrow;
    }
  }

  /// Get today's habits (daily habits)
  static Future<List<Map<String, dynamic>>> getTodayHabits() async {
    return await getHabitsByTargetType(targetType: 'daily');
  }

  /// Get weekly habits
  static Future<List<Map<String, dynamic>>> getWeeklyHabits() async {
    return await getHabitsByTargetType(targetType: 'weekly');
  }

  /// Get monthly habits
  static Future<List<Map<String, dynamic>>> getMonthlyHabits() async {
    return await getHabitsByTargetType(targetType: 'monthly');
  }

  /// Get yearly habits
  static Future<List<Map<String, dynamic>>> getYearlyHabits() async {
    return await getHabitsByTargetType(targetType: 'yearly');
  }

  // ====================================================================
  // BATCH OPERATIONS
  // ====================================================================

  /// Create multiple habits at once
  static Future<List<Map<String, dynamic>>> createMultipleHabits(
    List<Map<String, dynamic>> habits
  ) async {
    List<Map<String, dynamic>> createdHabits = [];
    
    for (var habitData in habits) {
      try {
        final habit = await createHabit(
          title: habitData['title'],
          description: habitData['description'],
          category: habitData['category'],
          targetType: habitData['target_type'],
          targetValue: habitData['target_value'],
        );
        
        if (habit != null) {
          createdHabits.add(habit);
        }
      } catch (e) {
        print('Error creating habit: ${habitData['title']} - $e');
      }
    }
    
    return createdHabits;
  }

  /// Update multiple habits progress
  static Future<List<String>> updateMultipleProgress(
    List<String> habitIds, 
    {int increment = 1}
  ) async {
    List<String> updatedIds = [];
    
    for (String id in habitIds) {
      try {
        final result = await updateProgress(id: id, increment: increment);
        if (result != null) {
          updatedIds.add(id);
        }
      } catch (e) {
        print('Error updating progress for habit $id: $e');
      }
    }
    
    return updatedIds;
  }
}