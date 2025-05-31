import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../api/api_target.dart'; // Import your API service

class TargetHidupPage extends StatefulWidget {
  const TargetHidupPage({Key? key}) : super(key: key);

  @override
  State<TargetHidupPage> createState() => _TargetHidupPageState();
}

class _TargetHidupPageState extends State<TargetHidupPage>
    with TickerProviderStateMixin {
  List<Map<String, dynamic>> habits = [];
  List<Map<String, dynamic>> filteredHabits = [];
  bool isLoading = true;
  String selectedCategory = 'all';
  String selectedTargetType = 'all';
  late TabController _tabController;

  final List<String> categories = [
    'all',
    'health',
    'fitness',
    'learning',
    'productivity',
    'social',
    'financial',
    'spiritual',
    'hobby',
    'regular_habit'
  ];

  final List<String> targetTypes = [
    'all',
    'daily',
    'weekly',
    'monthly',
    'yearly'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    loadHabits();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> loadHabits() async {
    setState(() => isLoading = true);
    try {
      final data = await ApiTarget.getAllHabits();
      setState(() {
        habits = data;
        filteredHabits = data;
        isLoading = false;
      });
      filterHabits();
    } catch (e) {
      setState(() => isLoading = false);
      _showErrorSnackbar('Gagal memuat data: $e');
    }
  }

  void filterHabits() {
    setState(() {
      filteredHabits = habits.where((habit) {
        bool categoryMatch = selectedCategory == 'all' ||
            habit['category'] == selectedCategory;
        bool targetTypeMatch = selectedTargetType == 'all' ||
            habit['target_type'] == selectedTargetType;
        return categoryMatch && targetTypeMatch;
      }).toList();
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 100), // Added margin to avoid bottom nav
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 100), // Added margin to avoid bottom nav
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Target Hidup',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6366F1),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: loadHabits,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Aktif'),
            Tab(text: 'Selesai'),
            Tab(text: 'Statistik'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllHabitsTab(),
          _buildActiveHabitsTab(),
          _buildCompletedHabitsTab(),
          _buildStatsTab(),
        ],
      ),
      // Changed FloatingActionButton position and style
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 80), // Add margin to avoid bottom nav
        child: FloatingActionButton.extended(
          onPressed: () => _showCreateHabitDialog(),
          backgroundColor: const Color(0xFF6366F1),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            'Tambah Target',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Changed to center float
    );
  }

  Widget _buildAllHabitsTab() {
    return Column(
      children: [
        _buildFilterSection(),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : filteredHabits.isEmpty
                  ? _buildEmptyState()
                  : _buildHabitsList(filteredHabits),
        ),
      ],
    );
  }

  Widget _buildActiveHabitsTab() {
    final activeHabits = habits.where((h) => !h['is_completed']).toList();
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : activeHabits.isEmpty
            ? _buildEmptyState('Tidak ada target aktif')
            : _buildHabitsList(activeHabits);
  }

  Widget _buildCompletedHabitsTab() {
    final completedHabits = habits.where((h) => h['is_completed']).toList();
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : completedHabits.isEmpty
            ? _buildEmptyState('Belum ada target yang selesai')
            : _buildHabitsList(completedHabits);
  }

  Widget _buildStatsTab() {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    final totalHabits = habits.length;
    final completedHabits = habits.where((h) => h['is_completed']).length;
    final activeHabits = totalHabits - completedHabits;
    final completionRate = totalHabits > 0 ? (completedHabits / totalHabits) : 0.0;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Target',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Target',
                  totalHabits.toString(),
                  Icons.track_changes,
                  const Color(0xFF6366F1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Aktif',
                  activeHabits.toString(),
                  Icons.play_circle,
                  const Color(0xFF059669),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Selesai',
                  completedHabits.toString(),
                  Icons.check_circle,
                  const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Tingkat Selesai',
                  '${(completionRate * 100).toStringAsFixed(1)}%',
                  Icons.analytics,
                  const Color(0xFF8B5CF6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Progress Target',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: completionRate,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(_getCategoryDisplayName(category)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedCategory = value!);
                    filterHabits();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedTargetType,
                  decoration: InputDecoration(
                    labelText: 'Periode',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  items: targetTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(_getTargetTypeDisplayName(type)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedTargetType = value!);
                    filterHabits();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState([String? message]) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100), // Add padding to avoid floating button overlap
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flag,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              message ?? 'Belum ada target hidup',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Mulai dengan menambah target pertama Anda',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitsList(List<Map<String, dynamic>> habitsList) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100), // Added bottom padding to avoid floating button
      itemCount: habitsList.length,
      itemBuilder: (context, index) {
        final habit = habitsList[index];
        return _buildHabitCard(habit);
      },
    );
  }

  Widget _buildHabitCard(Map<String, dynamic> habit) {
    final progress = habit['current_progress'] ?? 0;
    final target = habit['target_value'] ?? 1;
    final progressPercentage = target > 0 ? (progress / target).clamp(0.0, 1.0) : 0.0;
    final isCompleted = habit['is_completed'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isCompleted
            ? Border.all(color: const Color(0xFF10B981), width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit['title'] ?? 'Tanpa Judul',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isCompleted
                            ? const Color(0xFF10B981)
                            : const Color(0xFF1F2937),
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    if (habit['description']?.isNotEmpty == true) ...[
                      const SizedBox(height: 4),
                      Text(
                        habit['description'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(value, habit),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 16),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Hapus', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildCategoryChip(habit['category'] ?? 'regular_habit'),
              const SizedBox(width: 8),
              _buildTargetTypeChip(habit['target_type'] ?? 'daily'),
              const Spacer(),
              if (isCompleted)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF10B981),
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress: $progress / $target',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          '${(progressPercentage * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: progressPercentage,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isCompleted
                            ? const Color(0xFF10B981)
                            : const Color(0xFF6366F1),
                      ),
                      minHeight: 6,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (!isCompleted) ...[
                IconButton(
                  onPressed: () => _updateProgress(habit['_id'], 1),
                  icon: const Icon(Icons.add_circle),
                  color: const Color(0xFF6366F1),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _markAsCompleted(habit['_id']),
                  icon: const Icon(Icons.check_circle_outline),
                  color: const Color(0xFF10B981),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ] else ...[
                IconButton(
                  onPressed: () => _unmarkAsCompleted(habit['_id']),
                  icon: const Icon(Icons.undo),
                  color: const Color(0xFF6B7280),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getCategoryDisplayName(category),
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF6366F1),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTargetTypeChip(String targetType) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF059669).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getTargetTypeDisplayName(targetType),
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF059669),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _handleMenuAction(String action, Map<String, dynamic> habit) {
    switch (action) {
      case 'edit':
        _showEditHabitDialog(habit);
        break;
      case 'delete':
        _showDeleteConfirmation(habit['_id']);
        break;
    }
  }

  void _showCreateHabitDialog() {
    _showHabitDialog();
  }

  void _showEditHabitDialog(Map<String, dynamic> habit) {
    _showHabitDialog(habit: habit);
  }

  void _showHabitDialog({Map<String, dynamic>? habit}) {
    final isEdit = habit != null;
    final titleController = TextEditingController(text: habit?['title'] ?? '');
    final descriptionController = TextEditingController(text: habit?['description'] ?? '');
    final targetValueController = TextEditingController(
      text: (habit?['target_value'] ?? 1).toString(),
    );
    
    String selectedCategory = habit?['category'] ?? 'regular_habit';
    String selectedTargetType = habit?['target_type'] ?? 'daily';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Edit Target' : 'Tambah Target Baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Target *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Kategori *',
                    border: OutlineInputBorder(),
                  ),
                  items: categories.skip(1).map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(_getCategoryDisplayName(category)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedCategory = value!);
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedTargetType,
                  decoration: const InputDecoration(
                    labelText: 'Periode Target *',
                    border: OutlineInputBorder(),
                  ),
                  items: targetTypes.skip(1).map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(_getTargetTypeDisplayName(type)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedTargetType = value!);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: targetValueController,
                  decoration: const InputDecoration(
                    labelText: 'Target Value *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => _saveHabit(
                context,
                isEdit,
                habit?['_id'],
                titleController.text,
                descriptionController.text,
                selectedCategory,
                selectedTargetType,
                int.tryParse(targetValueController.text) ?? 1,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
              ),
              child: Text(isEdit ? 'Update' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveHabit(
    BuildContext context,
    bool isEdit,
    String? id,
    String title,
    String description,
    String category,
    String targetType,
    int targetValue,
  ) async {
    if (title.trim().isEmpty) {
      _showErrorSnackbar('Judul target tidak boleh kosong');
      return;
    }

    try {
      if (isEdit && id != null) {
        await ApiTarget.updateHabit(
          id: id,
          title: title,
          description: description,
          category: category,
          targetType: targetType,
          targetValue: targetValue,
        );
        _showSuccessSnackbar('Target berhasil diupdate');
      } else {
        await ApiTarget.createHabit(
          title: title,
          description: description,
          category: category,
          targetType: targetType,
          targetValue: targetValue,
        );
        _showSuccessSnackbar('Target baru berhasil ditambahkan');
      }
      
      Navigator.pop(context);
      loadHabits();
    } catch (e) {
      _showErrorSnackbar('Gagal menyimpan target: $e');
    }
  }

  void _showDeleteConfirmation(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus target ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteHabit(id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteHabit(String id) async {
    try {
      await ApiTarget.deleteHabit(id);
      _showSuccessSnackbar('Target berhasil dihapus');
      loadHabits();
    } catch (e) {
      _showErrorSnackbar('Gagal menghapus target: $e');
    }
  }

  Future<void> _updateProgress(String id, int increment) async {
    try {
      await ApiTarget.updateProgress(id: id, increment: increment);
      _showSuccessSnackbar('Progress berhasil diupdate');
      loadHabits();
      HapticFeedback.lightImpact();
    } catch (e) {
      _showErrorSnackbar('Gagal mengupdate progress: $e');
    }
  }

  Future<void> _markAsCompleted(String id) async {
    try {
      await ApiTarget.markAsCompleted(id);
      _showSuccessSnackbar('Target berhasil diselesaikan!');
      loadHabits();
      HapticFeedback.mediumImpact();
    } catch (e) {
      _showErrorSnackbar('Gagal menyelesaikan target: $e');
    }
  }

  Future<void> _unmarkAsCompleted(String id) async {
    try {
      await ApiTarget.unmarkAsCompleted(id);
      _showSuccessSnackbar('Target dikembalikan ke status aktif');
      loadHabits();
    } catch (e) {
      _showErrorSnackbar('Gagal mengubah status target: $e');
    }
  }

  String _getCategoryDisplayName(String category) {
    const categoryNames = {
      'all': 'Semua Kategori',
      'health': 'Kesehatan',
      'fitness': 'Kebugaran',
      'learning': 'Pembelajaran',
      'productivity': 'Produktivitas',
      'social': 'Sosial',
      'financial': 'Keuangan',
      'spiritual': 'Spiritual',
      'hobby': 'Hobi',
      'regular_habit': 'Kebiasaan Rutin',
    };
    return categoryNames[category] ?? category;
  }

  String _getTargetTypeDisplayName(String targetType) {
    const targetTypeNames = {
      'all': 'Semua Periode',
      'daily': 'Harian',
      'weekly': 'Mingguan',
      'monthly': 'Bulanan',
      'yearly': 'Tahunan',
    };
    return targetTypeNames[targetType] ?? targetType;
  }
}