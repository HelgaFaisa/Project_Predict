import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../api/api_target.dart'; // Pastikan path ini benar

// Import untuk EnhancedProfileHeader dan CardContainer
// Sesuaikan path jika file homepage.dart Anda memiliki nama atau lokasi berbeda
import '../home_page.dart'; 

class TargetHidupPage extends StatefulWidget {
  final String userName;
  const TargetHidupPage({Key? key, required this.userName}) : super(key: key);

  @override
  State<TargetHidupPage> createState() => _TargetHidupPageState();
}

class _TargetHidupPageState extends State<TargetHidupPage>
    with TickerProviderStateMixin {
  List<Map<String, dynamic>> habits = [];
  List<Map<String, dynamic>> filteredHabits = [];
  bool isLoading = true;
  String selectedCategoryFilter = 'all'; 
  String selectedTargetTypeFilter = 'all'; 
  late TabController _tabController;

  final List<String> availableCategories = [
    'all', 
    'health',
    'fitness',
    'learning',
    'productivity',
    'regular_habit'
  ];

  final List<String> availableTargetTypes = [
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
    if (!availableCategories.contains(selectedCategoryFilter)) {
      selectedCategoryFilter = availableCategories.isNotEmpty ? availableCategories.first : '';
    }
    if (!availableTargetTypes.contains(selectedTargetTypeFilter)) {
      selectedTargetTypeFilter = availableTargetTypes.isNotEmpty ? availableTargetTypes.first : '';
    }
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
      if (!mounted) return;
      setState(() {
        habits = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
      filterHabits();
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        _showErrorSnackbar('Gagal memuat data: $e');
      }
    }
  }

  void filterHabits() {
    setState(() {
      filteredHabits = habits.where((habit) {
        bool categoryMatch = selectedCategoryFilter == 'all' ||
            habit['category'] == selectedCategoryFilter;
        bool targetTypeMatch = selectedTargetTypeFilter == 'all' ||
            habit['target_type'] == selectedTargetTypeFilter;
        return categoryMatch && targetTypeMatch;
      }).toList();
    });
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(15, 5, 15, MediaQuery.of(context).viewInsets.bottom + 15 + (Scaffold.of(context).hasFloatingActionButton ? 60 : 15)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(15, 5, 15, MediaQuery.of(context).viewInsets.bottom + 15 + (Scaffold.of(context).hasFloatingActionButton ? 60 : 15)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EnhancedProfileHeader(
            userName: widget.userName,
            onAvatarTap: () {
              // Navigasi ke halaman profil jika ada
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Text(
              'Target Hidup Anda',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.blue.shade700,
              labelColor: Colors.blue.shade800,
              unselectedLabelColor: Colors.grey.shade600,
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              unselectedLabelStyle: GoogleFonts.poppins(),
              tabs: const [
                Tab(text: 'Semua'),
                Tab(text: 'Aktif'),
                Tab(text: 'Selesai'),
                Tab(text: 'Statistik'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllHabitsTab(),
                _buildActiveHabitsTab(),
                _buildCompletedHabitsTab(),
                _buildStatsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateHabitDialog(),
        backgroundColor: Colors.blue.shade600,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Tambah Target',
      ),
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
    final activeHabits = habits.where((h) => (h['is_completed'] as bool? ?? false) == false).toList();
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : activeHabits.isEmpty
            ? _buildEmptyState('Tidak ada target aktif')
            : _buildHabitsList(activeHabits);
  }

  Widget _buildCompletedHabitsTab() {
    final completedHabits = habits.where((h) => (h['is_completed'] as bool? ?? false) == true).toList();
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : completedHabits.isEmpty
            ? _buildEmptyState('Belum ada target yang selesai')
            : _buildHabitsList(completedHabits);
  }

  Widget _buildStatsTab() {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    final totalHabits = habits.length;
    final completedHabits = habits.where((h) => (h['is_completed'] as bool? ?? false) == true).length;
    final activeHabits = totalHabits - completedHabits;
    final completionRate = totalHabits > 0 ? (completedHabits / totalHabits) : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ringkasan Target', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: _buildStatCard('Total Target', totalHabits.toString(), Icons.track_changes_rounded, Colors.blue.shade700)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Aktif', activeHabits.toString(), Icons.directions_run_rounded, Colors.orange.shade700)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _buildStatCard('Selesai', completedHabits.toString(), Icons.check_circle_outline_rounded, Colors.green.shade700)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Tingkat Capaian', '${(completionRate * 100).toStringAsFixed(1)}%', Icons.show_chart_rounded, Colors.purple.shade700)),
          ]),
          const SizedBox(height: 24),
          Text('Progress Keseluruhan', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: completionRate,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return CardContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: color, size: 28),
            const Spacer(),
            Text(value, style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: color)),
          ]),
          const SizedBox(height: 8),
          Text(title, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
      child: Row(children: [
        Expanded(child: DropdownButtonFormField<String>(
          value: selectedCategoryFilter,
          decoration: InputDecoration(labelText: 'Kategori', labelStyle: GoogleFonts.poppins(), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14)),
          items: availableCategories.map((categoryValue) => DropdownMenuItem(value: categoryValue, child: Text(_getCategoryDisplayName(categoryValue), style: GoogleFonts.poppins()))).toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() => selectedCategoryFilter = value);
            filterHabits();
          },
        )),
        const SizedBox(width: 12),
        Expanded(child: DropdownButtonFormField<String>(
          value: selectedTargetTypeFilter,
          decoration: InputDecoration(labelText: 'Periode', labelStyle: GoogleFonts.poppins(), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14)),
          items: availableTargetTypes.map((typeValue) => DropdownMenuItem(value: typeValue, child: Text(_getTargetTypeDisplayName(typeValue), style: GoogleFonts.poppins()))).toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() => selectedTargetTypeFilter = value);
            filterHabits();
          },
        )),
      ]),
    );
  }

  Widget _buildEmptyState([String? message]) {
    return Center(child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.flag_outlined, size: 70, color: Colors.grey[300]),
        const SizedBox(height: 16),
        Text(message ?? 'Belum ada target hidup', style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.w500), textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text('Tekan tombol + di pojok kanan bawah untuk menambah target baru.', textAlign: TextAlign.center, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500])),
      ]),
    ));
  }

  Widget _buildHabitsList(List<Map<String, dynamic>> habitsList) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
      itemCount: habitsList.length,
      itemBuilder: (context, index) => _buildHabitCard(habitsList[index]),
    );
  }

  Widget _buildHabitCard(Map<String, dynamic> habit) {
    final progress = habit['current_progress'] as int? ?? 0;
    final target = habit['target_value'] as int? ?? 1;
    final progressPercentage = target > 0 ? (progress / target).clamp(0.0, 1.0) : 0.0;
    final isCompleted = habit['is_completed'] as bool? ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: CardContainer(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(
              habit['title'] as String? ?? 'Tanpa Judul',
              style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: isCompleted ? Colors.green.shade700 : Colors.black87, decoration: isCompleted ? TextDecoration.lineThrough : null),
            )),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
              onSelected: (value) => _handleMenuAction(value, habit),
              itemBuilder: (context) => [
                PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_outlined, size: 20, color: Colors.blue.shade700), const SizedBox(width: 8), Text('Edit', style: GoogleFonts.poppins())])),
                PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, size: 20, color: Colors.red.shade700), const SizedBox(width: 8), Text('Hapus', style: GoogleFonts.poppins(color: Colors.red.shade700))])),
              ],
            ),
          ]),
          if (habit['description'] != null && (habit['description'] as String).isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(habit['description'] as String, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700])),
          ],
          const SizedBox(height: 12),
          Row(children: [
            _buildCategoryChip(habit['category'] as String? ?? 'regular_habit'),
            const SizedBox(width: 8),
            _buildTargetTypeChip(habit['target_type'] as String? ?? 'daily'),
            const Spacer(),
            if (isCompleted) Icon(Icons.check_circle, color: Colors.green.shade600, size: 24),
          ]),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Progress: $progress / $target', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade700)),
                Text('${(progressPercentage * 100).toInt()}%', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue.shade700)),
              ]),
              const SizedBox(height: 6),
              LinearProgressIndicator(value: progressPercentage, backgroundColor: Colors.grey[300], valueColor: AlwaysStoppedAnimation<Color>(isCompleted ? Colors.green.shade600 : Colors.blue.shade600), minHeight: 8, borderRadius: BorderRadius.circular(4)),
            ])),
            if (!isCompleted) ...[
              const SizedBox(width: 16),
              InkWell(onTap: () => _updateProgress(habit['_id'] as String, 1), borderRadius: BorderRadius.circular(20), child: Icon(Icons.add_circle_outline_rounded, color: Colors.blue.shade600, size: 28)),
              const SizedBox(width: 10),
              InkWell(onTap: () => _markAsCompleted(habit['_id'] as String), borderRadius: BorderRadius.circular(20), child: Icon(Icons.check_circle_outline_rounded, color: Colors.green.shade600, size: 28)),
            ] else ...[
              const SizedBox(width: 16),
              InkWell(onTap: () => _unmarkAsCompleted(habit['_id'] as String), borderRadius: BorderRadius.circular(20), child: Icon(Icons.undo_rounded, color: Colors.grey.shade600, size: 28)),
            ]
          ]),
        ]),
      ),
    );
  }

  Widget _buildCategoryChip(String categoryKey) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.blue.shade200)),
      child: Text(_getCategoryDisplayName(categoryKey), style: GoogleFonts.poppins(fontSize: 11, color: Colors.blue.shade700, fontWeight: FontWeight.w500)),
    );
  }

  Widget _buildTargetTypeChip(String targetTypeKey) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.green.shade200)),
      child: Text(_getTargetTypeDisplayName(targetTypeKey), style: GoogleFonts.poppins(fontSize: 11, color: Colors.green.shade700, fontWeight: FontWeight.w500)),
    );
  }

  void _handleMenuAction(String action, Map<String, dynamic> habit) {
    switch (action) {
      case 'edit': _showEditHabitDialog(habit); break;
      case 'delete': _showDeleteConfirmation(habit['_id'] as String); break;
    }
  }

  void _showCreateHabitDialog() => _showHabitDialog();
  void _showEditHabitDialog(Map<String, dynamic> habit) => _showHabitDialog(habit: habit);

  void _showHabitDialog({Map<String, dynamic>? habit}) {
    final isEdit = habit != null;
    final titleController = TextEditingController(text: habit?['title'] as String? ?? '');
    final descriptionController = TextEditingController(text: habit?['description'] as String? ?? '');
    final initialTargetValue = habit?['target_value'];
    final targetValueController = TextEditingController(text: (initialTargetValue is int ? initialTargetValue : 1).toString());
    
    final List<String> dialogValidCategoryKeys = availableCategories.where((c) => c != 'all').toList();
    String currentSelectedCategoryInDialog = habit?['category'] as String? ?? (dialogValidCategoryKeys.isNotEmpty ? dialogValidCategoryKeys.first : '');
    if (!dialogValidCategoryKeys.contains(currentSelectedCategoryInDialog) && dialogValidCategoryKeys.isNotEmpty) {
      currentSelectedCategoryInDialog = dialogValidCategoryKeys.first;
    } else if (dialogValidCategoryKeys.isEmpty) {
      currentSelectedCategoryInDialog = '';
    }
    
    final List<String> dialogValidTargetTypeKeys = availableTargetTypes.where((t) => t != 'all').toList();
    String currentSelectedTargetTypeInDialog = habit?['target_type'] as String? ?? (dialogValidTargetTypeKeys.isNotEmpty ? dialogValidTargetTypeKeys.first : '');
    if (!dialogValidTargetTypeKeys.contains(currentSelectedTargetTypeInDialog) && dialogValidTargetTypeKeys.isNotEmpty) {
      currentSelectedTargetTypeInDialog = dialogValidTargetTypeKeys.first;
    } else if (dialogValidTargetTypeKeys.isEmpty) {
      currentSelectedTargetTypeInDialog = '';
    }

    print('Dialog initial category: $currentSelectedCategoryInDialog'); 

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEdit ? 'Edit Target' : 'Tambah Target Baru', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          content: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: 'Judul Target *', border: const OutlineInputBorder(), labelStyle: GoogleFonts.poppins()), style: GoogleFonts.poppins()),
            const SizedBox(height: 16),
            TextField(controller: descriptionController, decoration: InputDecoration(labelText: 'Deskripsi', border: const OutlineInputBorder(), labelStyle: GoogleFonts.poppins()), maxLines: 3, style: GoogleFonts.poppins()),
            const SizedBox(height: 16),
            if (dialogValidCategoryKeys.isNotEmpty)
              DropdownButtonFormField<String>(
                value: dialogValidCategoryKeys.contains(currentSelectedCategoryInDialog) ? currentSelectedCategoryInDialog : null,
                decoration: InputDecoration(labelText: 'Kategori *', border: const OutlineInputBorder(), labelStyle: GoogleFonts.poppins()),
                items: dialogValidCategoryKeys.map((categoryKey) => DropdownMenuItem(value: categoryKey, child: Text(_getCategoryDisplayName(categoryKey), style: GoogleFonts.poppins()))).toList(),
                onChanged: (value) { if (value != null) setDialogState(() => currentSelectedCategoryInDialog = value); },
                isExpanded: true,
              )
            else 
              Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Text("Tidak ada kategori tersedia.", style: GoogleFonts.poppins(color: Colors.red))),
            const SizedBox(height: 16),
             if (dialogValidTargetTypeKeys.isNotEmpty)
              DropdownButtonFormField<String>(
                value: dialogValidTargetTypeKeys.contains(currentSelectedTargetTypeInDialog) ? currentSelectedTargetTypeInDialog : null,
                decoration: InputDecoration(labelText: 'Periode Target *', border: const OutlineInputBorder(), labelStyle: GoogleFonts.poppins()),
                items: dialogValidTargetTypeKeys.map((typeKey) => DropdownMenuItem(value: typeKey, child: Text(_getTargetTypeDisplayName(typeKey), style: GoogleFonts.poppins()))).toList(),
                onChanged: (value) { if (value != null) setDialogState(() => currentSelectedTargetTypeInDialog = value); },
                isExpanded: true,
              )
            else
               Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Text("Tidak ada periode target tersedia.", style: GoogleFonts.poppins(color: Colors.red))),
            const SizedBox(height: 16),
            TextField(controller: targetValueController, decoration: InputDecoration(labelText: 'Target Value *', border: const OutlineInputBorder(), labelStyle: GoogleFonts.poppins()), keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], style: GoogleFonts.poppins()),
            const SizedBox(height: 16),
          ])),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('Batal', style: GoogleFonts.poppins(color: Colors.grey.shade700))),
            ElevatedButton(
              onPressed: () {
                if (currentSelectedCategoryInDialog.isEmpty || currentSelectedTargetTypeInDialog.isEmpty) {
                  _showErrorSnackbar("Kategori dan Periode Target harus dipilih.");
                  return;
                }
                _saveHabit(dialogContext, isEdit, habit?['_id'] as String?, titleController.text, descriptionController.text, currentSelectedCategoryInDialog, currentSelectedTargetTypeInDialog, int.tryParse(targetValueController.text) ?? 1);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              child: Text(isEdit ? 'Update' : 'Simpan', style: GoogleFonts.poppins()),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveHabit(BuildContext dialogContext, bool isEdit, String? id, String title, String description, String category, String targetType, int targetValue) async {
    if (title.trim().isEmpty) { _showErrorSnackbar('Judul target tidak boleh kosong'); return; }
    if (targetValue <= 0) { _showErrorSnackbar('Target value harus lebih dari 0'); return; }
    if (category.isEmpty) { _showErrorSnackbar('Kategori harus dipilih.'); return; }
    if (targetType.isEmpty) { _showErrorSnackbar('Periode target harus dipilih.'); return; }

    print('--- Preparing to Save Habit ---');
    print('Title: $title');
    print('Description: $description');
    print('Category being sent: "$category"');
    print('Target Type: "$targetType"');
    print('Target Value: $targetValue');
    print('Is Edit: $isEdit, ID: $id');

    try {
      if (isEdit && id != null) {
        print('Calling ApiTarget.updateHabit...');
        await ApiTarget.updateHabit(id: id, title: title, description: description, category: category, targetType: targetType, targetValue: targetValue);
        _showSuccessSnackbar('Target berhasil diupdate');
      } else {
        print('Calling ApiTarget.createHabit...');
        await ApiTarget.createHabit(title: title, description: description, category: category, targetType: targetType, targetValue: targetValue);
        _showSuccessSnackbar('Target baru berhasil ditambahkan');
      }
      if (mounted) Navigator.pop(dialogContext);
      loadHabits();
    } catch (e) {
      if (mounted) _showErrorSnackbar('Gagal menyimpan target: $e');
      print('--- ERROR SAVING HABIT ---'); 
      print('Error details: $e');
    }
  }

  void _showDeleteConfirmation(String id) {
    showDialog(context: context, builder: (dialogContext) => AlertDialog(
      title: Text('Konfirmasi Hapus', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      content: Text('Apakah Anda yakin ingin menghapus target ini?', style: GoogleFonts.poppins()),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      actions: [
        TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text('Batal', style: GoogleFonts.poppins(color: Colors.grey.shade700))),
        ElevatedButton(
          onPressed: () { Navigator.pop(dialogContext); _deleteHabit(id); },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade600, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          child: Text('Hapus', style: GoogleFonts.poppins()),
        ),
      ],
    ));
  }

  Future<void> _deleteHabit(String id) async {
    try { await ApiTarget.deleteHabit(id); _showSuccessSnackbar('Target berhasil dihapus'); loadHabits(); } 
    catch (e) { _showErrorSnackbar('Gagal menghapus target: $e'); }
  }

  Future<void> _updateProgress(String id, int increment) async {
    try { await ApiTarget.updateProgress(id: id, increment: increment); loadHabits(); HapticFeedback.lightImpact(); } 
    catch (e) { _showErrorSnackbar('Gagal mengupdate progress: $e'); }
  }

  Future<void> _markAsCompleted(String id) async {
    try { await ApiTarget.markAsCompleted(id); _showSuccessSnackbar('Target berhasil diselesaikan!'); loadHabits(); HapticFeedback.mediumImpact(); } 
    catch (e) { _showErrorSnackbar('Gagal menyelesaikan target: $e'); }
  }

  Future<void> _unmarkAsCompleted(String id) async {
    try { await ApiTarget.unmarkAsCompleted(id); _showSuccessSnackbar('Target dikembalikan ke status aktif'); loadHabits(); } 
    catch (e) { _showErrorSnackbar('Gagal mengubah status target: $e'); }
  }

  String _getCategoryDisplayName(String categoryKey) {
    const categoryNames = {
      'all': 'Semua Kategori', 'health': 'Kesehatan', 'fitness': 'Kebugaran', 
      'learning': 'Pembelajaran', 'productivity': 'Produktivitas', 
      'regular_habit': 'Kebiasaan Rutin'
      // Kategori yang dihapus dari tampilan:
      // 'social': 'Sosial', 
      // 'financial': 'Keuangan', 
      // 'spiritual': 'Spiritual', 
      // 'hobby': 'Hobi', 
    };
    return categoryNames[categoryKey.toLowerCase()] ?? categoryKey.replaceAll('_', ' ').split(' ').map((str) => str.isNotEmpty ? '${str[0].toUpperCase()}${str.substring(1)}' : '').join(' ');
  }

  String _getTargetTypeDisplayName(String targetTypeKey) {
    const targetTypeNames = {'all': 'Semua Periode', 'daily': 'Harian', 'weekly': 'Mingguan', 'monthly': 'Bulanan', 'yearly': 'Tahunan'};
    return targetTypeNames[targetTypeKey.toLowerCase()] ?? targetTypeKey.replaceAll('_', ' ').split(' ').map((str) => str.isNotEmpty ? '${str[0].toUpperCase()}${str.substring(1)}' : '').join(' ');
  }
}