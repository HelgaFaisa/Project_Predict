// lib/model/habit.dart
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
    this.category = 'regular_habit',
    this.createdAt,
    this.updatedAt,
  });

  // FIXED: Enhanced fromJson with better empty ObjectId handling
  factory Habit.fromJson(Map<String, dynamic> json) {
    try {
      print('DEBUG Habit.fromJson input: $json');
      
      // Extract ID from various possible formats
      String? extractedId;
      
      // Check for 'id' field first (processed by service)
      if (json['id'] != null && json['id'].toString().isNotEmpty) {
        extractedId = json['id'].toString().trim();
        print('DEBUG: Found processed id: $extractedId');
      }
      // Check for '_id' field with MongoDB format
      else if (json['_id'] != null) {
        final idField = json['_id'];
        print('DEBUG: Processing _id field: $idField (${idField.runtimeType})');
        
        if (idField is Map) {
          // Handle MongoDB ObjectId format: {$oid: "actual_id"}
          if (idField.containsKey('\$oid')) {
            final oidValue = idField['\$oid'];
            print('DEBUG: Found \$oid value: "$oidValue" (${oidValue.runtimeType})');
            
            if (oidValue != null && 
                oidValue.toString().isNotEmpty && 
                oidValue.toString().trim() != '' &&
                oidValue.toString() != 'null') {
              extractedId = oidValue.toString().trim();
              print('DEBUG: Extracted from \$oid: $extractedId');
            } else {
              print('WARNING: \$oid is empty or null: "$oidValue"');
            }
          }
          // Alternative format: {oid: "actual_id"}
          else if (idField.containsKey('oid')) {
            final oidValue = idField['oid'];
            if (oidValue != null && oidValue.toString().isNotEmpty) {
              extractedId = oidValue.toString().trim();
              print('DEBUG: Extracted from oid: $extractedId');
            }
          }
          // If Map but no recognizable ObjectId pattern, try to get any valid value
          else {
            final values = idField.values.where((v) => 
              v != null && 
              v.toString().isNotEmpty && 
              v.toString().trim() != '' &&
              v.toString() != 'null'
            );
            if (values.isNotEmpty) {
              extractedId = values.first.toString().trim();
              print('DEBUG: Extracted from Map values: $extractedId');
            }
          }
        } 
        else if (idField is String && idField.isNotEmpty && idField.trim() != '') {
          extractedId = idField.trim();
          print('DEBUG: Direct string _id: $extractedId');
        } 
        else {
          final stringId = idField.toString().trim();
          if (stringId.isNotEmpty && stringId != 'null') {
            extractedId = stringId;
            print('DEBUG: Converted _id to string: $extractedId');
          }
        }
      }
      
      // Final validation
      if (extractedId == null || 
          extractedId.isEmpty || 
          extractedId == 'null' ||
          extractedId.trim().isEmpty) {
        print('WARNING: No valid ID found, using null');
        extractedId = null;
      } else {
        print('DEBUG: Final extracted ID: "$extractedId"');
      }
      
      // Parse dates safely
      DateTime? parseDate(dynamic dateField) {
        if (dateField == null) return null;
        
        try {
          if (dateField is Map && dateField.containsKey('\$date')) {
            // MongoDB date format: {"\$date": "2025-05-31T04:50:37.935Z"}
            final dateStr = dateField['\$date'];
            if (dateStr is String && dateStr.isNotEmpty) {
              return DateTime.parse(dateStr);
            }
          } else if (dateField is String && dateField.isNotEmpty) {
            return DateTime.parse(dateField);
          } else if (dateField is DateTime) {
            return dateField;
          }
        } catch (e) {
          print('WARNING: Failed to parse date: $dateField, error: $e');
        }
        return null;
      }
      
      final habit = Habit(
        id: extractedId,
        title: json['title']?.toString() ?? '',
        description: json['description']?.toString(),
        category: json['category']?.toString() ?? 'regular_habit',
        createdAt: parseDate(json['created_at']),
        updatedAt: parseDate(json['updated_at']),
      );
      
      print('DEBUG: Created habit: ${habit.id} - ${habit.title}');
      return habit;
      
    } catch (e, stackTrace) {
      print('ERROR in Habit.fromJson: $e');
      print('ERROR stackTrace: $stackTrace');
      print('ERROR problematic JSON: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  // For API calls (exclude id for create operations)
  Map<String, dynamic> toApiJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
    };
  }

  // Helper methods for validation
  bool get hasValidId {
    return id != null && 
           id!.isNotEmpty && 
           id != 'null' && 
           id!.trim().isNotEmpty;
  }

  String? get safeId {
    if (!hasValidId) return null;
    return id!.trim();
  }

  // Create a copy with a new ID (useful for backend sync)
  Habit copyWithId(String newId) {
    return Habit(
      id: newId,
      title: title,
      description: description,
      category: category,
      createdAt: createdAt,
      updatedAt: updatedAt,
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
          title == other.title;

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}