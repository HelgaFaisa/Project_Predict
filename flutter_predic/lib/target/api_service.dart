// lib/target/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../model/habit.dart';
import '../model/activity.dart';

class ApiService {
  // Ganti dengan URL API Laravel Anda
  static const String baseUrl = 'http://localhost:8000/api';
  
  // Headers default untuk semua request
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Generic method untuk handle response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final Map<String, dynamic> data = json.decode(response.body);
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Terjadi kesalahan pada server');
    }
  }

  // Get all habits
  static Future<List<Habit>> getHabits() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/habits'),
        headers: _headers,
      );

      final responseData = _handleResponse(response);
      
      if (responseData['success'] == true && responseData['data'] != null) {
        List<dynamic> habitsJson = responseData['data'];
        return habitsJson.map((json) => Habit.fromJson(json)).toList();
      } else {
        throw Exception('Gagal memuat data habits');
      }
    } catch (e) {
      throw Exception('Error fetching habits: $e');
    }
  }

  // Get habit by ID
  static Future<Habit> getHabitById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/habits/$id'),
        headers: _headers,
      );

      final responseData = _handleResponse(response);
      
      if (responseData['success'] == true && responseData['data'] != null) {
        return Habit.fromJson(responseData['data']);
      } else {
        throw Exception('Gagal memuat data habit');
      }
    } catch (e) {
      throw Exception('Error fetching habit: $e');
    }
  }

  // Create new habit
  static Future<Habit> createHabit(Habit habit) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/habits'),
        headers: _headers,
        body: json.encode(habit.toJson()),
      );

      final responseData = _handleResponse(response);
      
      if (responseData['success'] == true && responseData['data'] != null) {
        return Habit.fromJson(responseData['data']);
      } else {
        throw Exception('Gagal membuat habit baru');
      }
    } catch (e) {
      throw Exception('Error creating habit: $e');
    }
  }

  // Update existing habit
  static Future<Habit> updateHabit(Habit habit) async {
    try {
      if (habit.id == null) {
        throw Exception('Habit ID tidak boleh kosong');
      }

      final response = await http.put(
        Uri.parse('$baseUrl/habits/${habit.id}'),
        headers: _headers,
        body: json.encode(habit.toJson()),
      );

      final responseData = _handleResponse(response);
      
      if (responseData['success'] == true && responseData['data'] != null) {
        return Habit.fromJson(responseData['data']);
      } else {
        throw Exception('Gagal memperbarui habit');
      }
    } catch (e) {
      throw Exception('Error updating habit: $e');
    }
  }

  // Delete habit
  static Future<void> deleteHabit(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/habits/$id'),
        headers: _headers,
      );

      final responseData = _handleResponse(response);
      
      if (responseData['success'] != true) {
        throw Exception('Gagal menghapus habit');
      }
    } catch (e) {
      throw Exception('Error deleting habit: $e');
    }
  }

  // Get activities for specific date
  static Future<List<Activity>> getActivitiesForDate(DateTime date) async {
    try {
      final dateString = DateFormat('yyyy-MM-dd').format(date);
      final response = await http.get(
        Uri.parse('$baseUrl/activities/$dateString'),
        headers: _headers,
      );

      final responseData = _handleResponse(response);
      
      if (responseData['success'] == true && responseData['data'] != null) {
        List<dynamic> activitiesJson = responseData['data'];
        return activitiesJson.map((json) => Activity.fromJson(json)).toList();
      } else {
        // Return empty list if no activities found for the date
        return [];
      }
    } catch (e) {
      throw Exception('Error fetching activities: $e');
    }
  }

  // Create or update activity
  static Future<Activity> createOrUpdateActivity(Activity activity) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/activities'),
        headers: _headers,
        body: json.encode(activity.toJson()),
      );

      final responseData = _handleResponse(response);
      
      if (responseData['success'] == true && responseData['data'] != null) {
        return Activity.fromJson(responseData['data']);
      } else {
        throw Exception('Gagal menyimpan aktivitas');
      }
    } catch (e) {
      throw Exception('Error saving activity: $e');
    }
  }

  // Delete activity
  static Future<void> deleteActivity(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/activities/$id'),
        headers: _headers,
      );

      final responseData = _handleResponse(response);
      
      if (responseData['success'] != true) {
        throw Exception('Gagal menghapus aktivitas');
      }
    } catch (e) {
      throw Exception('Error deleting activity: $e');
    }
  }

  // Get habit statistics
  static Future<Map<String, dynamic>> getHabitStats(String habitId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/habits/$habitId/stats'),
        headers: _headers,
      );

      final responseData = _handleResponse(response);
      
      if (responseData['success'] == true && responseData['data'] != null) {
        return responseData['data'];
      } else {
        throw Exception('Gagal memuat statistik habit');
      }
    } catch (e) {
      throw Exception('Error fetching habit stats: $e');
    }
  }

  // Batch operations for better performance
  static Future<List<Activity>> getActivitiesForDateRange(DateTime startDate, DateTime endDate) async {
    try {
      final List<Activity> allActivities = [];
      final currentDate = DateTime(startDate.year, startDate.month, startDate.day);
      final end = DateTime(endDate.year, endDate.month, endDate.day);

      while (!currentDate.isAfter(end)) {
        final activities = await getActivitiesForDate(currentDate);
        allActivities.addAll(activities);
        currentDate.add(const Duration(days: 1));
      }

      return allActivities;
    } catch (e) {
      throw Exception('Error fetching activities for date range: $e');
    }
  }

  // Helper method to check if habit is completed for specific date
  static Future<bool> isHabitCompletedForDate(String habitId, DateTime date) async {
    try {
      final activities = await getActivitiesForDate(date);
      return activities.any((activity) => 
          activity.habitId == habitId && activity.isCompleted);
    } catch (e) {
      return false;
    }
  }

  // Get completion rate for a habit over a period
  static Future<double> getHabitCompletionRate(String habitId, int days) async {
    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: days));
      
      int completedDays = 0;
      int totalDays = 0;

      for (int i = 0; i < days; i++) {
        final checkDate = startDate.add(Duration(days: i));
        final isCompleted = await isHabitCompletedForDate(habitId, checkDate);
        
        if (isCompleted) {
          completedDays++;
        }
        totalDays++;
      }

      return totalDays > 0 ? (completedDays / totalDays) * 100 : 0.0;
    } catch (e) {
      throw Exception('Error calculating completion rate: $e');
    }
  }

  // Get current streak for a habit
  static Future<int> getCurrentStreak(String habitId) async {
    try {
      final stats = await getHabitStats(habitId);
      return stats['currentStreak'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Get longest streak for a habit
  static Future<int> getLongestStreak(String habitId) async {
    try {
      final stats = await getHabitStats(habitId);
      return stats['longestStreak'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // Bulk create/update activities (useful for importing data)
  static Future<List<Activity>> bulkCreateOrUpdateActivities(List<Activity> activities) async {
    try {
      final List<Activity> results = [];
      
      for (final activity in activities) {
        try {
          final result = await createOrUpdateActivity(activity);
          results.add(result);
        } catch (e) {
          // Continue with other activities even if one fails
          print('Failed to save activity: $e');
        }
      }
      
      return results;
    } catch (e) {
      throw Exception('Error bulk saving activities: $e');
    }
  }

  // Get summary data for dashboard
  static Future<Map<String, dynamic>> getDashboardSummary() async {
    try {
      final habits = await getHabits();
      final today = DateTime.now();
      final todayActivities = await getActivitiesForDate(today);
      
      final totalHabits = habits.length;
      final completedToday = todayActivities.where((a) => a.isCompleted).length;
      final completionRate = totalHabits > 0 ? (completedToday / totalHabits) * 100 : 0.0;
      
      // Calculate weekly completion rate
      double weeklyRate = 0.0;
      try {
        final weekStart = today.subtract(Duration(days: today.weekday - 1));
        int weeklyCompleted = 0;
        int weeklyTotal = 0;
        
        for (int i = 0; i < 7; i++) {
          final checkDate = weekStart.add(Duration(days: i));
          final dayActivities = await getActivitiesForDate(checkDate);
          weeklyCompleted += dayActivities.where((a) => a.isCompleted).length;
          weeklyTotal += totalHabits;
        }
        
        weeklyRate = weeklyTotal > 0 ? (weeklyCompleted / weeklyTotal) * 100 : 0.0;
      } catch (e) {
        print('Error calculating weekly rate: $e');
      }
      
      return {
        'totalHabits': totalHabits,
        'completedToday': completedToday,
        'todayCompletionRate': completionRate,
        'weeklyCompletionRate': weeklyRate,
        'habits': habits,
        'todayActivities': todayActivities,
      };
    } catch (e) {
      throw Exception('Error fetching dashboard summary: $e');
    }
  }
}