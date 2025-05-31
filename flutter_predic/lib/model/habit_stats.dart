// lib/model/habit_stats.dart
class HabitStats {
  final String habitId;
  final int totalActivities;
  final int completedActivities;
  final double completionRate;
  final int currentStreak;
  final int longestStreak;

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