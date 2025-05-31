// lib/model/habit_with_status.dart
class HabitWithStatus {
  final String habitId;
  final String title;
  final String? description;
  final String category;
  final bool isCompleted;

  HabitWithStatus({
    required this.habitId,
    required this.title,
    this.description,
    required this.category,
    required this.isCompleted,
  });

  @override
  String toString() {
    return 'HabitWithStatus{habitId: $habitId, title: $title, description: $description, category: $category, isCompleted: $isCompleted}';
  }
}