// lib/target/targethidup.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../model/habit.dart';
import '../model/activity.dart';
import '../target/api_service.dart';

class TargetHidupSehatPage extends StatefulWidget {
  const TargetHidupSehatPage({Key? key}) : super(key: key);

  @override
  State<TargetHidupSehatPage> createState() => _TargetHidupSehatPageState();
}

class _TargetHidupSehatPageState extends State<TargetHidupSehatPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  
  List<Habit> _habits = [];
  List<Activity> _todayActivities = [];
  bool _isLoading = false;
  bool _localeInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeLocale();
  }

  Future<void> _initializeLocale() async {
    try {
      await initializeDateFormatting('id_ID', null);
      setState(() {
        _localeInitialized = true;
      });
      _loadData();
    } catch (e) {
      setState(() {
        _localeInitialized = true;
      });
      _loadData();
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final habits = await ApiService.getHabits();
      final activities = await ApiService.getActivitiesForDate(_selectedDay);
      setState(() {
        _habits = habits;
        _todayActivities = activities;
      });
    } catch (e) {
      _showError('Gagal memuat data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadActivitiesForDate(DateTime date) async {
    setState(() => _isLoading = true);
    try {
      final activities = await ApiService.getActivitiesForDate(date);
      setState(() {
        _todayActivities = activities;
        _selectedDay = date;
        _focusedDay = date;
      });
    } catch (e) {
      _showError('Gagal memuat aktivitas untuk tanggal ini: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleActivity(String habitId, bool isCompleted) async {
    try {
      final activity = Activity(
        habitId: habitId,
        date: _selectedDay,
        isCompleted: isCompleted,
      );
      
      await ApiService.createOrUpdateActivity(activity);
      _showSuccess('Status aktivitas berhasil diperbarui');
      _loadActivitiesForDate(_selectedDay);
    } catch (e) {
      _showError('Gagal memperbarui aktivitas: $e');
    }
  }

  Future<void> _showAddHabitDialog() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Habit Baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Habit',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi (Opsional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Simpan'),
              onPressed: () async {
                if (titleController.text.trim().isEmpty) {
                  _showError('Judul habit tidak boleh kosong');
                  return;
                }
                
                try {
                  final newHabit = Habit(
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim().isEmpty 
                        ? null 
                        : descriptionController.text.trim(),
                    category: 'regular_habit',
                  );
                  
                  await ApiService.createHabit(newHabit);
                  Navigator.of(context).pop();
                  _showSuccess('Habit berhasil ditambahkan');
                  _loadData();
                } catch (e) {
                  _showError('Gagal menambah habit: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditHabitDialog(Habit habit) async {
    final titleController = TextEditingController(text: habit.title);
    final descriptionController = TextEditingController(text: habit.description ?? '');
    
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Habit'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Habit',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi (Opsional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hapus'),
              onPressed: () async {
                final confirm = await _showConfirmDialog('Hapus Habit', 'Apakah Anda yakin ingin menghapus habit ini?');
                if (confirm) {
                  try {
                    await ApiService.deleteHabit(habit.id!);
                    Navigator.of(context).pop();
                    _showSuccess('Habit berhasil dihapus');
                    _loadData();
                  } catch (e) {
                    _showError('Gagal menghapus habit: $e');
                  }
                }
              },
            ),
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Simpan'),
              onPressed: () async {
                if (titleController.text.trim().isEmpty) {
                  _showError('Judul habit tidak boleh kosong');
                  return;
                }
                
                try {
                  final updatedHabit = habit.copyWith(
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim().isEmpty 
                        ? null 
                        : descriptionController.text.trim(),
                  );
                  
                  await ApiService.updateHabit(updatedHabit);
                  Navigator.of(context).pop();
                  _showSuccess('Habit berhasil diperbarui');
                  _loadData();
                } catch (e) {
                  _showError('Gagal memperbarui habit: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showConfirmDialog(String title, String message) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              child: const Text('Ya'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ) ?? false;
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _showSuccess(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  bool _isActivityCompleted(String habitId) {
    return _todayActivities.any((activity) => 
        activity.habitId == habitId && activity.isCompleted);
  }

  @override
  Widget build(BuildContext context) {
    if (!_localeInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Target Hidup Sehat'),
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddHabitDialog,
            tooltip: 'Tambah Habit Baru',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildCalendar(),
                _buildSelectedDateInfo(),
                Expanded(child: _buildHabitsList()),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHabitDialog,
        backgroundColor: Colors.green[600],
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Tambah Habit Baru',
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TableCalendar<Activity>(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        locale: 'id_ID',
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          if (!isSameDay(_selectedDay, selectedDay)) {
            _loadActivitiesForDate(selectedDay);
          }
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            setState(() {
              _calendarFormat = format;
            });
          }
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.green[400],
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.green[600],
            shape: BoxShape.circle,
          ),
          weekendTextStyle: TextStyle(
            color: Colors.red[600],
          ),
        ),
        headerStyle: const HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          formatButtonShowsNext: false,
          formatButtonDecoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          formatButtonTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedDateInfo() {
    final dateFormat = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
    final completedCount = _todayActivities.where((a) => a.isCompleted).length;
    final totalHabits = _habits.length;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateFormat.format(_selectedDay),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Progress: $completedCount/$totalHabits habit selesai',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          CircularProgressIndicator(
            value: totalHabits > 0 ? completedCount / totalHabits : 0,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green[600]!),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitsList() {
    if (_habits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada habit yang ditambahkan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _showAddHabitDialog,
              icon: const Icon(Icons.add),
              label: const Text('Tambah Habit Pertama'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _habits.length,
      itemBuilder: (context, index) {
        final habit = _habits[index];
        final isCompleted = _isActivityCompleted(habit.id!);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isCompleted ? Colors.green : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Checkbox(
              value: isCompleted,
              onChanged: (bool? value) {
                _toggleActivity(habit.id!, value ?? false);
              },
              activeColor: Colors.green[600],
            ),
            title: Text(
              habit.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                color: isCompleted ? Colors.grey[600] : null,
              ),
            ),
            subtitle: habit.description != null && habit.description!.isNotEmpty
                ? Text(
                    habit.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  )
                : null,
            trailing: PopupMenuButton<String>(
              onSelected: (String value) {
                if (value == 'edit') {
                  _showEditHabitDialog(habit);
                } else if (value == 'delete') {
                  _showConfirmDialog('Hapus Habit', 'Apakah Anda yakin ingin menghapus habit "${habit.title}"?')
                      .then((confirmed) {
                    if (confirmed) {
                      ApiService.deleteHabit(habit.id!).then((_) {
                        _showSuccess('Habit berhasil dihapus');
                        _loadData();
                      }).catchError((e) {
                        _showError('Gagal menghapus habit: $e');
                      });
                    }
                  });
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Hapus', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}