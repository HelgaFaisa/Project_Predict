// lib/model/activity.dart
import 'package:intl/intl.dart';

class Activity {
  String? id;
  String habitId;
  DateTime date;
  bool isCompleted;
  DateTime? createdAt;
  DateTime? updatedAt;

  Activity({
    this.id,
    required this.habitId,
    required this.date,
    required this.isCompleted,
    this.createdAt,
    this.updatedAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: _extractId(json['_id']),
      habitId: _extractHabitId(json['habitId']),
      date: DateTime.parse(json['date']),
      isCompleted: json['isCompleted'] ?? false,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
  }

  static String? _extractId(dynamic idField) {
    if (idField == null) return null;
    if (idField is String) return idField;
    if (idField is Map) {
      if (idField.containsKey('\$oid')) {
        return idField['\$oid'];
      }
    }
    return idField.toString();
  }

  static String _extractHabitId(dynamic habitIdField) {
    if (habitIdField == null) return '';
    if (habitIdField is String) return habitIdField;
    if (habitIdField is Map) {
      if (habitIdField.containsKey('\$oid')) {
        return habitIdField['\$oid'];
      }
    }
    return habitIdField.toString();
  }

  static DateTime? _parseDate(dynamic dateField) {
    if (dateField == null) return null;
    
    try {
      if (dateField is String) {
        return DateTime.parse(dateField);
      }
      if (dateField is Map && dateField.containsKey('\$date')) {
        return DateTime.parse(dateField['\$date']);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['habitId'] = habitId;
    data['date'] = DateFormat('yyyy-MM-dd').format(date);
    data['isCompleted'] = isCompleted;
    return data;
  }

  Activity copyWith({
    String? id,
    String? habitId,
    DateTime? date,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Activity(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Activity{id: $id, habitId: $habitId, date: $date, isCompleted: $isCompleted}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Activity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          habitId == other.habitId &&
          date == other.date &&
          isCompleted == other.isCompleted;

  @override
  int get hashCode =>
      id.hashCode ^
      habitId.hashCode ^
      date.hashCode ^
      isCompleted.hashCode;
}