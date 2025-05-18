// File: gejala.dart
// Widget untuk menampilkan dan berinteraksi dengan data Gejala

import 'package:flutter/material.dart';
import 'dart:async';
import '../model/gejala.dart';
import '../api/gejala_api.dart';

class GejalaPage extends StatefulWidget {
  const GejalaPage({Key? key}) : super(key: key);

  @override
  _GejalaPageState createState() => _GejalaPageState();
}

class _GejalaPageState extends State<GejalaPage> {
  final GejalaApi _gejalaApi = GejalaApi();
  List<Gejala> _gejalaList = [];
  bool _isLoading = true;
  String _errorMessage = '';
  
  // Untuk pull-to-refresh
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  
  // Timer untuk update otomatis
  Timer? _autoRefreshTimer;
  
  // Auto update interval dalam menit
  final int _autoUpdateInterval = 5;

  @override
  void initState() {
    super.initState();
    _loadData();
    
    // Mengatur pembaruan otomatis setiap beberapa menit
    _autoRefreshTimer = Timer.periodic(
      Duration(minutes: _autoUpdateInterval), 
      (_) => _refreshData()
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  // Memuat data dari API
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final gejalaList = await _gejalaApi.getAllGejala();
      
      setState(() {
        _gejalaList = gejalaList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data: $e';
        _isLoading = false;
      });
    }
  }

  // Refresh data (digunakan untuk pull-to-refresh)
  Future<void> _refreshData() async {
    try {
      final gejalaList = await _gejalaApi.refreshGejala();
      
      setState(() {
        _gejalaList = gejalaList;
        _errorMessage = '';
      });
      _refreshController.refreshCompleted();
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memperbarui data: $e';
      });
      _refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Gejala'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Perbarui Data',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_gejalaList.isEmpty) {
      return const Center(
        child: Text('Tidak ada data gejala yang tersedia'),
      );
    }

    // SmartRefresher untuk pull-to-refresh
    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _refreshData,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _gejalaList.length,
        itemBuilder: (context, index) {
          final gejala = _gejalaList[index];
          return _buildGejalaCard(gejala);
        },
      ),
    );
  }

  Widget _buildGejalaCard(Gejala gejala) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(gejala.kode),
          backgroundColor: gejala.aktif ? Colors.green.shade100 : Colors.grey.shade300,
        ),
        title: Text(
          gejala.nama,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: gejala.aktif ? Colors.black : Colors.grey,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                _buildFactorChip('MB', gejala.mb),
                const SizedBox(width: 8),
                _buildFactorChip('MD', gejala.md),
              ],
            ),
          ],
        ),
        trailing: gejala.aktif
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.cancel, color: Colors.grey),
        onTap: () => _showGejalaDetails(gejala),
      ),
    );
  }

  Widget _buildFactorChip(String label, double value) {
    return Chip(
      label: Text(
        '$label: ${value.toStringAsFixed(2)}',
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: Colors.blue.shade50,
      padding: const EdgeInsets.all(0),
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  void _showGejalaDetails(Gejala gejala) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _buildDetailSheet(gejala),
    );
  }

  Widget _buildDetailSheet(Gejala gejala) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(30),
              ),
              margin: const EdgeInsets.only(bottom: 16),
            ),
          ),
          Text(
            'Detail Gejala: ${gejala.kode}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Divider(),
          _buildDetailItem('Nama', gejala.nama),
          _buildDetailItem('Measure of Belief (MB)', gejala.mb.toString()),
          _buildDetailItem('Measure of Disbelief (MD)', gejala.md.toString()),
          _buildDetailItem('Status', gejala.aktif ? 'Aktif' : 'Tidak Aktif'),
          const SizedBox(height: 16),
          Text(
            'Informasi Tambahan',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'MB dan MD adalah nilai yang digunakan dalam metode certainty factor untuk kalkulasi probabilitas diagnosis. Semakin tinggi nilai MB, semakin kuat keyakinan bahwa gejala ini mengindikasikan suatu kondisi. Semakin tinggi nilai MD, semakin kuat keyakinan bahwa gejala ini tidak mengindikasikan suatu kondisi.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

// Dibutuhkan untuk SmartRefresher
class RefreshController {
  final bool initialRefresh;
  
  RefreshController({required this.initialRefresh});
  
  void refreshCompleted() {}
  
  void refreshFailed() {}
  
  void dispose() {}
}

// Widget SmartRefresher sederhana untuk pull-to-refresh
class SmartRefresher extends StatelessWidget {
  final RefreshController controller;
  final Widget child;
  final Function onRefresh;

  const SmartRefresher({
    Key? key,
    required this.controller,
    required this.child,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await onRefresh();
      },
      child: child,
    );
  }
}