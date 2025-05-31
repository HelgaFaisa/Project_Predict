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
    
    // Jika berupa Map dengan format {'$oid': 'id_string'}
    if (idField is Map) {
      String? extractedId;
      
      if (idField.containsKey('\$oid')) {
        extractedId = idField['\$oid'] as String?;
      } else if (idField.containsKey('oid')) {
        extractedId = idField['oid'] as String?;
      } else if (idField.containsKey('_id')) {
        extractedId = idField['_id'] as String?;
      } else {
        // Ambil value pertama yang bukan null
        extractedId = idField.values.firstWhere(
          (v) => v != null && v.toString().isNotEmpty,
          orElse: () => null,
        )?.toString();
      }
      
      print('DEBUG Activity extracted ID from Map: $extractedId');
      
      if (extractedId != null && 
          extractedId.isNotEmpty && 
          extractedId != "null") {
        return extractedId.trim();
      }
    }
    
    // Jika sudah berupa string langsung
    if (idField is String && idField.isNotEmpty && idField != "null") {
      return idField.trim();
    }
    
    print('WARNING: Could not extract valid ID from: $idField');
    return null;
  }

  // Fungsi untuk mengekstrak habitId (bisa berupa string langsung atau ObjectId)
  static String _extractHabitId(dynamic habitIdField) {
    if (habitIdField == null) return '';
    
    print('DEBUG Activity _extractHabitId: $habitIdField (${habitIdField.runtimeType})');
    
    // Jika berupa Map dengan format {'$oid': 'id_string'}
    if (habitIdField is Map) {
      String extractedHabitId = '';
      
      if (habitIdField.containsKey('\$oid')) {
        extractedHabitId = habitIdField['\$oid'] as String? ?? '';
      } else if (habitIdField.containsKey('oid')) {
        extractedHabitId = habitIdField['oid'] as String? ?? '';
      } else if (habitIdField.containsKey('_id')) {
        extractedHabitId = habitIdField['_id'] as String? ?? '';
      } else {
        extractedHabitId = habitIdField.values.firstWhere(
          (v) => v != null && v.toString().isNotEmpty,
          orElse: () => '',
        ).toString();
      }
      
      print('DEBUG Activity extracted habitId from Map: $extractedHabitId');
      return extractedHabitId.trim();
    }
    
    // Jika sudah berupa string langsung
    if (habitIdField is String) {
      return habitIdField.trim();
    }
    
    String convertedHabitId = habitIdField.toString().trim();
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
      'habitId': habitId.trim(), // Pastikan habitId tidak ada whitespace
      'date': DateFormat('yyyy-MM-dd').format(date),
      'isCompleted': isCompleted,
    };
  }

  // Method untuk validasi ID sebelum operasi
  bool get hasValidId {
    return id != null && 
           id!.isNotEmpty && 
           id != 'null' && 
           id!.trim().isNotEmpty;
  }

  // Method untuk mendapatkan ID yang safe untuk API calls
  String? get safeId {
    if (!hasValidId) return null;
    return id!.trim();
  }

  // Method untuk validasi habitId
  bool get hasValidHabitId {
    return habitId.isNotEmpty && 
           habitId != 'null' && 
           habitId.trim().isNotEmpty;
  }

  // Method untuk mendapatkan habitId yang safe
  String get safeHabitId {
    return habitId.trim();
  }

  // Method untuk membuat copy dengan perubahan tertentu
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