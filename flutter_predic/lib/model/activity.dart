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
    print('DEBUG Activity.fromJson input: $json');
    
    Activity activity = Activity(
      id: _extractId(json['_id']),
      habitId: _extractHabitId(json['habitId']),
      date: DateTime.parse(json['date']),
      isCompleted: json['isCompleted'] ?? false,
      createdAt: _parseDate(json['created_at']),
      updatedAt: _parseDate(json['updated_at']),
    );
    
    print('DEBUG Activity.fromJson result: $activity');
    return activity;
  }

  // Fungsi untuk mengekstrak ID dari format MongoDB yang dikirim controller
  static String? _extractId(dynamic idField) {
    if (idField == null) return null;
    
    print('DEBUG Activity _extractId: $idField (${idField.runtimeType})');
    
    // Jika sudah berupa string langsung
    if (idField is String) return idField;
    
    // Jika berupa Map dengan format {'$oid': 'id_string'}
    if (idField is Map) {
      if (idField.containsKey('\$oid')) {
        String? extractedId = idField['\$oid'] as String?;
        print('DEBUG Activity extracted ID from \$oid: $extractedId');
        return extractedId;
      }
      // Fallback jika ada key lain
      return idField.values.first?.toString();
    }
    
    String convertedId = idField.toString();
    print('DEBUG Activity converted ID: $convertedId');
    return convertedId;
  }

  // Fungsi untuk mengekstrak habitId (bisa berupa string langsung atau ObjectId)
  static String _extractHabitId(dynamic habitIdField) {
    if (habitIdField == null) return '';
    
    print('DEBUG Activity _extractHabitId: $habitIdField (${habitIdField.runtimeType})');
    
    // Jika sudah berupa string langsung
    if (habitIdField is String) return habitIdField;
    
    // Jika berupa Map dengan format {'$oid': 'id_string'}
    if (habitIdField is Map) {
      if (habitIdField.containsKey('\$oid')) {
        String extractedHabitId = habitIdField['\$oid'] as String? ?? '';
        print('DEBUG Activity extracted habitId from \$oid: $extractedHabitId');
        return extractedHabitId;
      }
      return habitIdField.values.first?.toString() ?? '';
    }
    
    String convertedHabitId = habitIdField.toString();
    print('DEBUG Activity converted habitId: $convertedHabitId');
    return convertedHabitId;
  }

  // Fungsi untuk parsing tanggal dari format yang dikirim controller
  static DateTime? _parseDate(dynamic dateField) {
    if (dateField == null) return null;
    
    print('DEBUG Activity _parseDate: $dateField (${dateField.runtimeType})');
    
    try {
      // Jika berupa string ISO format
      if (dateField is String) {
        DateTime parsedDate = DateTime.parse(dateField);
        print('DEBUG Activity parsed date from string: $parsedDate');
        return parsedDate;
      }
      
      // Jika berupa Map dengan format {'$date': 'iso_string'}
      if (dateField is Map && dateField.containsKey('\$date')) {
        DateTime parsedDate = DateTime.parse(dateField['\$date']);
        print('DEBUG Activity parsed date from \$date: $parsedDate');
        return parsedDate;
      }
      
      return null;
    } catch (e) {
      print('ERROR Activity parsing date: $e, input: $dateField');
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

  // Method untuk konversi ke format yang diharapkan API
  Map<String, dynamic> toApiJson() {
    return {
      'habitId': habitId,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'isCompleted': isCompleted,
    };
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
    return 'Activity{id: $id, habitId: $habitId, date: ${DateFormat('yyyy-MM-dd').format(date)}, isCompleted: $isCompleted}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Activity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          habitId == other.habitId &&
          DateFormat('yyyy-MM-dd').format(date) == DateFormat('yyyy-MM-dd').format(other.date) &&
          isCompleted == other.isCompleted;

  @override
  int get hashCode =>
      id.hashCode ^
      habitId.hashCode ^
      date.hashCode ^
      isCompleted.hashCode;
}
