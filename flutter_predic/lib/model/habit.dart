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
    required this.category,
    this.createdAt,
    this.updatedAt,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: _extractId(json['_id']),
      title: json['title'] ?? '',
      description: json['description'],
      category: json['category'] ?? '',
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
    data['title'] = title;
    if (description != null && description!.isNotEmpty) {
      data['description'] = description;
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
