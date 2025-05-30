// lib/model/habit.dart
import 'package:intl/intl.dart';

class Habit {
  String? id;
  String title;
  String? description;
  String category;
  DateTime? createdAt;
  DateTime? updatedAt;

  Habit({
    this.id,
    required this.title,
    this.description,
    required this.category,
    this.createdAt,
    this.updatedAt,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    print('DEBUG Habit.fromJson input: $json');
    
    Habit habit = Habit(
      id: _extractId(json['_id']),
      title: json['title'] ?? '',
      description: json['description'],
      category: json['category'] ?? 'regular_habit', // default sesuai controller
      createdAt: _parseDate(json['created_at'] ?? json['createdAt']),
      updatedAt: _parseDate(json['updated_at'] ?? json['updatedAt']),
    );
    
    print('DEBUG Habit.fromJson result: $habit');
    return habit;
  }

  // Fungsi untuk mengekstrak ID dari format MongoDB yang dikirim controller
  static String? _extractId(dynamic idField) {
    if (idField == null) return null;
    
    print('DEBUG Habit _extractId: $idField (${idField.runtimeType})');
    
    // Jika berupa Map dengan format {'$oid': 'id_string'}
    if (idField is Map) {
      if (idField.containsKey('\$oid')) {
        String? extractedId = idField['\$oid'] as String?;
        print('DEBUG Habit extracted ID from \$oid: $extractedId');
        // Pastikan tidak kosong
        if (extractedId != null && extractedId.isNotEmpty) {
          return extractedId;
        }
      }
      // Fallback jika ada key lain
      var firstValue = idField.values.first?.toString();
      if (firstValue != null && firstValue.isNotEmpty) {
        return firstValue;
      }
    }
    
    // Jika sudah berupa string langsung
    if (idField is String && idField.isNotEmpty) {
      return idField;
    }
    
    // Konversi ke string sebagai fallback terakhir
    String convertedId = idField.toString();
    print('DEBUG Habit converted ID: $convertedId');
    
    // Pastikan bukan string kosong atau "null"
    if (convertedId.isNotEmpty && convertedId != "null") {
      return convertedId;
    }
    
    return null;
  }

  // Fungsi untuk parsing tanggal dari format yang dikirim controller
  static DateTime? _parseDate(dynamic dateField) {
    if (dateField == null) return null;
    
    print('DEBUG Habit _parseDate: $dateField (${dateField.runtimeType})');
    
    try {
      // Jika berupa string ISO format
      if (dateField is String) {
        DateTime parsedDate = DateTime.parse(dateField);
        print('DEBUG Habit parsed date from string: $parsedDate');
        return parsedDate;
      }
      
      // Jika berupa Map dengan format {'$date': 'iso_string'}
      if (dateField is Map && dateField.containsKey('\$date')) {
        DateTime parsedDate = DateTime.parse(dateField['\$date']);
        print('DEBUG Habit parsed date from \$date: $parsedDate');
        return parsedDate;
      }
      
      return null;
    } catch (e) {
      print('ERROR Habit parsing date: $e, input: $dateField');
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['title'] = title;
    if (description != null && description!.isNotEmpty) {
      data['description'] = description;
    }
    data['category'] = category;
    return data;
  }

  // Method untuk konversi ke format yang diharapkan API
  Map<String, dynamic> toApiJson() {
    final data = <String, dynamic>{};
    data['title'] = title.trim();
    if (description != null && description!.trim().isNotEmpty) {
      data['description'] = description!.trim();
    }
    data['category'] = category;
    return data;
  }

  Habit copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Habit{id: $id, title: $title, description: $description, category: $category}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Habit &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          description == other.description &&
          category == other.category;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      description.hashCode ^
      category.hashCode;
}

// lib/model/habit_stats.dart
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
    return HabitStats(
      habitId: json['habitId'] ?? '',
      totalActivities: json['totalActivities'] ?? 0,
      completedActivities: json['completedActivities'] ?? 0,
      completionRate: (json['completionRate'] ?? 0.0).toDouble(),
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'habitId': habitId,
      'totalActivities': totalActivities,
      'completedActivities': completedActivities,
      'completionRate': completionRate,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
    };
  }

  @override
  String toString() {
    return 'HabitStats{habitId: $habitId, totalActivities: $totalActivities, completedActivities: $completedActivities, completionRate: $completionRate%, currentStreak: $currentStreak, longestStreak: $longestStreak}';
  }
}