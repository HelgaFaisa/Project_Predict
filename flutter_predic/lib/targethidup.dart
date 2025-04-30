import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class TargetHidupSehatPage extends StatefulWidget {
  const TargetHidupSehatPage({Key? key}) : super(key: key);

  @override
  State<TargetHidupSehatPage> createState() => _TargetHidupSehatPageState();
}

class _TargetHidupSehatPageState extends State<TargetHidupSehatPage> {
  // Variabel untuk kalender
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  
  // Map untuk menyimpan aktivitas per tanggal
  final Map<DateTime, List<HealthActivity>> _activitiesByDate = {};
  
  // Controller untuk textfield
  final TextEditingController _activityController = TextEditingController();
  
  @override
  void dispose() {
    _activityController.dispose();
    super.dispose();
  }

  // Mendapatkan key tanggal untuk Map
  DateTime _getDateKey(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  // Mendapatkan aktivitas pada tanggal tertentu
  List<HealthActivity> _getActivitiesForDay(DateTime day) {
    final dateKey = _getDateKey(day);
    return _activitiesByDate[dateKey] ?? [];
  }

  // Menambah aktivitas baru
  void _addActivity(String activity) {
    if (activity.trim().isEmpty) return;
    
    final dateKey = _getDateKey(_selectedDay);
    if (_activitiesByDate[dateKey] == null) {
      _activitiesByDate[dateKey] = [];
    }
    
    setState(() {
      _activitiesByDate[dateKey]!.add(
        HealthActivity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: activity,
          isCompleted: false,
        ),
      );
      _activityController.clear();
    });
  }

  // Toggle status aktivitas (selesai/belum)
  void _toggleActivityStatus(String activityId) {
    final dateKey = _getDateKey(_selectedDay);
    final activities = _activitiesByDate[dateKey];
    
    if (activities != null) {
      setState(() {
        final activityIndex = activities.indexWhere((act) => act.id == activityId);
        if (activityIndex != -1) {
          activities[activityIndex] = activities[activityIndex].copyWith(
            isCompleted: !activities[activityIndex].isCompleted,
          );
        }
      });
    }
  }

  // Menghapus aktivitas
  void _deleteActivity(String activityId) {
    final dateKey = _getDateKey(_selectedDay);
    final activities = _activitiesByDate[dateKey];
    
    if (activities != null) {
      setState(() {
        _activitiesByDate[dateKey] = activities.where((act) => act.id != activityId).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedActivities = _getActivitiesForDay(_selectedDay);
    final completedCount = selectedActivities.where((act) => act.isCompleted).length;
    final totalActivities = selectedActivities.length;
    final progressPercentage = totalActivities > 0 ? completedCount / totalActivities : 0.0;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[900]!,
              Colors.blue[400]!,
              Colors.blue[100]!,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Target Hidup Sehat',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              
              // Calendar
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    calendarFormat: _calendarFormat,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: Colors.blue[900],
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.blue[400],
                        shape: BoxShape.circle,
                      ),
                      markersMaxCount: 3,
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: true,
                      titleCentered: true,
                      formatButtonShowsNext: false,
                      formatButtonDecoration: BoxDecoration(
                        color: Colors.blue[700],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      formatButtonTextStyle: const TextStyle(color: Colors.white),
                    ),
                    eventLoader: _getActivitiesForDay,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                  ),
                ),
              ),
              
              // Selected Date Display
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Kegiatan untuk ${DateFormat('dd MMMM yyyy').format(_selectedDay)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              
              // Progress Bar
              if (totalActivities > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Progress: $completedCount/$totalActivities',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${(progressPercentage * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progressPercentage,
                          backgroundColor: Colors.blue[100],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
                          minHeight: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Activity Input Field
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _activityController,
                        decoration: InputDecoration(
                          hintText: 'Tambahkan kegiatan baru...',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue[700]!, Colors.blue[900]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => _addActivity(_activityController.text),
                        icon: const Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Activities List
              Expanded(
                child: selectedActivities.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fact_check_outlined,
                              size: 60,
                              color: Colors.blue[100],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Belum ada kegiatan untuk hari ini',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tambahkan kegiatan untuk memulai',
                              style: TextStyle(
                                color: Colors.blue[100],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: selectedActivities.length,
                        itemBuilder: (context, index) {
                          final activity = selectedActivities[index];
                          return ActivityCard(
                            activity: activity,
                            onToggle: () => _toggleActivityStatus(activity.id),
                            onDelete: () => _deleteActivity(activity.id),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget untuk menampilkan kartu aktivitas
class ActivityCard extends StatelessWidget {
  final HealthActivity activity;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const ActivityCard({
    Key? key,
    required this.activity,
    required this.onToggle,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[900]!.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: InkWell(
          onTap: onToggle,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: activity.isCompleted ? Colors.blue[600] : Colors.white,
              border: Border.all(
                color: activity.isCompleted ? Colors.blue[600]! : Colors.blue[300]!,
                width: 2,
              ),
            ),
            child: activity.isCompleted
                ? const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
        title: Text(
          activity.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            decoration: activity.isCompleted ? TextDecoration.lineThrough : null,
            color: activity.isCompleted ? Colors.grey : Colors.black87,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: Colors.red[300]),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

// Model untuk aktivitas kesehatan
class HealthActivity {
  final String id;
  final String title;
  final bool isCompleted;

  HealthActivity({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  HealthActivity copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return HealthActivity(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}