// lib/services/habit_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/habit.dart';
import '../model/activity.dart';

class HabitService {
  static const String baseUrl = 'http://localhost:8000/api'; // Ganti dengan URL API Anda
  
  // Headers default
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // GET: Ambil habits dengan status completion untuk tanggal tertentu
  static Future<List<HabitWithStatus>> getHabitsWithTodayStatus([String? date]) async {
    try {
      final targetDate = date ?? DateTime.now().toIso8601String().split('T')[0];
      print('DEBUG: Calling getHabitsWithTodayStatus($targetDate)');
      
      final response = await http.get(
        Uri.parse('$baseUrl/habits-with-status/$targetDate'),
        headers: headers,
      );
      
      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('DEBUG: Parsed JSON: $jsonData');
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> habitsList = jsonData['data'];
          print('DEBUG: Habits with status list length: ${habitsList.length}');
          
          List<HabitWithStatus> habits = habitsList.map((habitJson) {
            print('DEBUG: Processing habit with status JSON: $habitJson');
            return HabitWithStatus.fromJson(habitJson);
          }).toList();
          
          print('DEBUG: Converted habits with status: $habits');
          return habits;
        } else {
          print('ERROR: API response success=false or data=null');
          return []; // Return empty list jika tidak ada data
        }
      } else {
        print('ERROR: HTTP ${response.statusCode}: ${response.body}');
        throw Exception('Gagal mengambil data habits: ${response.statusCode}');
      }
    } catch (e) {
      print('ERROR: Exception in getHabitsWithTodayStatus: $e');
      rethrow;
    }
  }

  // GET: Ambil semua habits (tanpa status)
  static Future<List<Habit>> getAllHabits() async {
    try {
      print('DEBUG: Calling getAllHabits()');
      
      final response = await http.get(
        Uri.parse('$baseUrl/habits'),
        headers: headers,
      );
      
      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('DEBUG: Parsed JSON: $jsonData');
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> habitsList = jsonData['data'];
          print('DEBUG: Habits list length: ${habitsList.length}');
          
          List<Habit> habits = habitsList.map((habitJson) {
            print('DEBUG: Processing habit JSON: $habitJson');
            return Habit.fromJson(habitJson);
          }).toList();
          
          print('DEBUG: Converted habits: $habits');
          return habits;
        } else {
          print('ERROR: API response success=false or data=null');
          throw Exception('Data habits tidak ditemukan');
        }
      } else {
        print('ERROR: HTTP ${response.statusCode}: ${response.body}');
        throw Exception('Gagal mengambil data habits: ${response.statusCode}');
      }
    } catch (e) {
      print('ERROR: Exception in getAllHabits: $e');
      rethrow;
    }
  }

  // GET: Ambil activities berdasarkan tanggal
  static Future<List<Activity>> getActivitiesByDate(String date) async {
    try {
      print('DEBUG: Calling getActivitiesByDate($date)');
      
      final response = await http.get(
        Uri.parse('$baseUrl/activities/$date'),
        headers: headers,
      );
      
      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('DEBUG: Parsed JSON: $jsonData');
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          final List<dynamic> activitiesList = jsonData['data'];
          print('DEBUG: Activities list length: ${activitiesList.length}');
          
          List<Activity> activities = activitiesList.map((activityJson) {
            print('DEBUG: Processing activity JSON: $activityJson');
            return Activity.fromJson(activityJson);
          }).toList();
          
          print('DEBUG: Converted activities: $activities');
          return activities;
        } else {
          print('ERROR: API response success=false or data=null');
          return []; // Return empty list jika tidak ada data
        }
      } else {
        print('ERROR: HTTP ${response.statusCode}: ${response.body}');
        throw Exception('Gagal mengambil data activities: ${response.statusCode}');
      }
    } catch (e) {
      print('ERROR: Exception in getActivitiesByDate: $e');
      rethrow;
    }
  }

  // POST: Buat habit baru
  static Future<Habit> createHabit(Habit habit) async {
    try {
      print('DEBUG: Calling createHabit with: ${habit.toApiJson()}');
      
      final response = await http.post(
        Uri.parse('$baseUrl/habits'),
        headers: headers,
        body: json.encode(habit.toApiJson()),
      );
      
      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');
      
      if (response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        print('DEBUG: Parsed JSON: $jsonData');
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          Habit createdHabit = Habit.fromJson(jsonData['data']);
          print('DEBUG: Created habit: $createdHabit');
          return createdHabit;
        } else {
          print('ERROR: API response success=false or data=null');
          throw Exception('Gagal membuat habit');
        }
      } else {
        print('ERROR: HTTP ${response.statusCode}: ${response.body}');
        final jsonData = json.decode(response.body);
        throw Exception(jsonData['message'] ?? 'Gagal membuat habit');
      }
    } catch (e) {
      print('ERROR: Exception in createHabit: $e');
      rethrow;
    }
  }

  // PUT: Update habit
  static Future<Habit> updateHabit(String habitId, Habit habit) async {
    try {
      print('DEBUG: Calling updateHabit($habitId) with: ${habit.toApiJson()}');
      
      final response = await http.put(
        Uri.parse('$baseUrl/habits/$habitId'),
        headers: headers,
        body: json.encode(habit.toApiJson()),
      );
      
      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('DEBUG: Parsed JSON: $jsonData');
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          Habit updatedHabit = Habit.fromJson(jsonData['data']);
          print('DEBUG: Updated habit: $updatedHabit');
          return updatedHabit;
        } else {
          print('ERROR: API response success=false or data=null');
          throw Exception('Gagal memperbarui habit');
        }
      } else {
        print('ERROR: HTTP ${response.statusCode}: ${response.body}');
        final jsonData = json.decode(response.body);
        throw Exception(jsonData['message'] ?? 'Gagal memperbarui habit');
      }
    } catch (e) {
      print('ERROR: Exception in updateHabit: $e');
      rethrow;
    }
  }

  // DELETE: Hapus habit
  static Future<void> deleteHabit(String habitId) async {
    try {
      print('DEBUG: Calling deleteHabit($habitId)');
      
      final response = await http.delete(
        Uri.parse('$baseUrl/habits/$habitId'),
        headers: headers,
      );
      
      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('DEBUG: Parsed JSON: $jsonData');
        
        if (jsonData['success'] != true) {
          print('ERROR: API response success=false');
          throw Exception(jsonData['message'] ?? 'Gagal menghapus habit');
        }
      } else {
        print('ERROR: HTTP ${response.statusCode}: ${response.body}');
        final jsonData = json.decode(response.body);
        throw Exception(jsonData['message'] ?? 'Gagal menghapus habit');
      }
    } catch (e) {
      print('ERROR: Exception in deleteHabit: $e');
      rethrow;
    }
  }

  // POST: Buat atau update activity
  static Future<Activity> createOrUpdateActivity(Activity activity) async {
  try {
    final apiJson = activity.toApiJson();
    print('DEBUG: Calling createOrUpdateActivity with: $apiJson');
    
    // Validasi sebelum kirim
    if (apiJson['habitId'] == null || apiJson['habitId'].toString().isEmpty) {
      throw Exception('habitId is required but empty');
    }
    
    final response = await http.post(
      Uri.parse('$baseUrl/activities'),
      headers: headers,
      body: json.encode(apiJson),
    );
      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        print('DEBUG: Parsed JSON: $jsonData');
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          Activity resultActivity = Activity.fromJson(jsonData['data']);
          print('DEBUG: Result activity: $resultActivity');
          return resultActivity;
        } else {
          print('ERROR: API response success=false or data=null');
          throw Exception('Gagal menyimpan activity');
        }
      } else {
        print('ERROR: HTTP ${response.statusCode}: ${response.body}');
        final jsonData = json.decode(response.body);
        throw Exception(jsonData['message'] ?? 'Gagal menyimpan activity');
      }
    } catch (e) {
      print('ERROR: Exception in createOrUpdateActivity: $e');
      rethrow;
    }
  }

  // DELETE: Hapus activity
  static Future<void> deleteActivity(String activityId) async {
    try {
      print('DEBUG: Calling deleteActivity($activityId)');
      
      final response = await http.delete(
        Uri.parse('$baseUrl/activities/$activityId'),
        headers: headers,
      );
      
      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('DEBUG: Parsed JSON: $jsonData');
        
        if (jsonData['success'] != true) {
          print('ERROR: API response success=false');
          throw Exception(jsonData['message'] ?? 'Gagal menghapus activity');
        }
      } else {
        print('ERROR: HTTP ${response.statusCode}: ${response.body}');
        final jsonData = json.decode(response.body);
        throw Exception(jsonData['message'] ?? 'Gagal menghapus activity');
      }
    } catch (e) {
      print('ERROR: Exception in deleteActivity: $e');
      rethrow;
    }
  }

  // GET: Ambil statistik habit
  static Future<HabitStats> getHabitStats(String habitId) async {
    try {
      print('DEBUG: Calling getHabitStats($habitId)');
      
      final response = await http.get(
        Uri.parse('$baseUrl/habits/$habitId/stats'),
        headers: headers,
      );
      
      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('DEBUG: Parsed JSON: $jsonData');
        
        if (jsonData['success'] == true && jsonData['data'] != null) {
          HabitStats stats = HabitStats.fromJson(jsonData['data']);
          print('DEBUG: Habit stats: $stats');
          return stats;
        } else {
          print('ERROR: API response success=false or data=null');
          throw Exception('Gagal mengambil statistik habit');
        }
      } else {
        print('ERROR: HTTP ${response.statusCode}: ${response.body}');
        throw Exception('Gagal mengambil statistik habit: ${response.statusCode}');
      }
    } catch (e) {
      print('ERROR: Exception in getHabitStats: $e');
      rethrow;
    }
  }
}

// Model untuk Habit dengan Status
class HabitWithStatus {
  String id;
  String habitId;
  String title;
  String? description;
  String category;
  String date;
  bool isCompleted;
  String? activityId;
  DateTime? createdAt;
  DateTime? updatedAt;

  HabitWithStatus({
    required this.id,
    required this.habitId,
    required this.title,
    this.description,
    required this.category,
    required this.date,
    required this.isCompleted,
    this.activityId,
    this.createdAt,
    this.updatedAt,
  });

  factory HabitWithStatus.fromJson(Map<String, dynamic> json) {
  print('DEBUG: HabitWithStatus.fromJson input: $json');
  
  DateTime? parseDate(dynamic dateData) {
    try {
      if (dateData == null) return null;
      if (dateData is String) return DateTime.parse(dateData);
      if (dateData is Map && dateData['\$date'] != null) {
        return DateTime.parse(dateData['\$date']);
      }
      return null;
    } catch (e) {
      print('DEBUG: Error parsing date $dateData: $e');
      return null;
    }
  }
  
  String extractId(dynamic idData) {
    if (idData is String && idData.isNotEmpty) return idData;
    if (idData is Map && idData['\$oid'] != null && idData['\$oid'].isNotEmpty) {
      return idData['\$oid'];
    }
    return '';
  }
  
  // Perbaikan utama: pastikan habitId tidak kosong
  String id = extractId(json['_id']);
  String habitId = json['habitId']?.toString() ?? '';
  
  // Jika habitId kosong, gunakan id sebagai fallback
  if (habitId.isEmpty) {
    habitId = id;
  }
  
  print('DEBUG: Extracted id: $id, habitId: $habitId');
  
  return HabitWithStatus(
    id: id,
    habitId: habitId, // ← Sekarang sudah dipastikan tidak kosong
    title: json['title'] ?? '',
    description: json['description'],
    category: json['category'] ?? 'regular_habit',
    date: json['date'] ?? '',
    isCompleted: json['isCompleted'] ?? false,
    activityId: json['activityId'],
    createdAt: parseDate(json['created_at']),
    updatedAt: parseDate(json['updated_at']),
  );
}

  Map<String, dynamic> toApiJson() {
  // Validasi sebelum mengirim
  if (habitId.isEmpty) {
    print('ERROR: habitId is empty when creating API JSON');
    throw Exception('habitId cannot be empty');
  }
  
  return {
    'habitId': habitId,
    'date': date,
    'isCompleted': isCompleted,
  };
}

  @override
  String toString() {
    return 'HabitWithStatus{id: $id, habitId: $habitId, title: $title, date: $date, isCompleted: $isCompleted}';
  }
}

// Import HabitStats dari model
class HabitStats {
  String habitId;
  int totalActivities;
  int completedActivities;
  double completionRate;
  int currentStreak;
  int longestStreak;

  HabitStats({
    required this.habitId,
    required this.totalActivities,
    required this.completedActivities,
    required this.completionRate,
    required this.currentStreak,
    required this.longestStreak,
  });

  factory HabitStats.fromJson(Map<String, dynamic> json) {
    print('DEBUG: HabitStats.fromJson input: $json');
    return HabitStats(
      habitId: json['habitId'] ?? '',
      totalActivities: json['totalActivities'] ?? 0,
      completedActivities: json['completedActivities'] ?? 0,
      completionRate: (json['completionRate'] ?? 0.0).toDouble(),
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'HabitStats{habitId: $habitId, totalActivities: $totalActivities, completedActivities: $completedActivities, completionRate: $completionRate%, currentStreak: $currentStreak, longestStreak: $longestStreak}';
  }
}