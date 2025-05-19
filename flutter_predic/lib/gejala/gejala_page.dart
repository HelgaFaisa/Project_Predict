// File: gejala.dart (atau gejala_page.dart)
// Widget untuk menampilkan dan berinteraksi dengan data Gejala

import 'package:flutter/material.dart';
import 'dart:async';
import '../model/gejala.dart';
import '../api/gejala_api.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum JawabanGejala { ya, tidak, belum }

class GejalaJawaban {
  final Gejala gejala;
  JawabanGejala jawaban;

  GejalaJawaban({required this.gejala, this.jawaban = JawabanGejala.belum});
}

class GejalaPage extends StatefulWidget {
  const GejalaPage({Key? key}) : super(key: key);

  @override
  _GejalaPageState createState() => _GejalaPageState();
}

class _GejalaPageState extends State<GejalaPage> {
  final GejalaApi _gejalaApi = GejalaApi();
  List<GejalaJawaban> _gejalaJawabanList = []; // Menggunakan model GejalaJawaban
  bool _isLoading = true;
  String _errorMessage = '';

  // Untuk pull-to-refresh
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  // Timer untuk update otomatis
  Timer? _autoRefreshTimer;

  // Auto update interval dalam menit
  final int _autoUpdateInterval = 5;

  double _totalNilaiGejala = 0;
  String _saran = '';
  String _hasilPerhitungan = ''; // State untuk menampilkan hasil perhitungan

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
        _gejalaJawabanList = gejalaList.map((gejala) => GejalaJawaban(gejala: gejala)).toList();
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
        _gejalaJawabanList = gejalaList.map((gejala) => GejalaJawaban(gejala: gejala)).toList();
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

  // =======================
  // PERBAIKAN PERHITUNGAN CF
  // =======================
  void _hitungNilaiGejala() {
    double cfGlobal = 0;

    for (var item in _gejalaJawabanList) {
      double cf;

      if (item.jawaban == JawabanGejala.ya) {
        cf = item.gejala.mb - item.gejala.md;      // CF jika jawab "Ya"
      } else if (item.jawaban == JawabanGejala.tidak) {
        cf = -item.gejala.md;                      // CF negatif jika jawab "Tidak"
      } else {
        cf = 0;                                    // Belum dijawab
      }

      // Penggabungan CF
      cfGlobal = cfGlobal + cf * (1 - cfGlobal);
    }

    _totalNilaiGejala = cfGlobal.clamp(-1, 1);     // Pastikan tetap di rentang -1..1
    _hasilPerhitungan =
        'Certainty Factor total: ${_totalNilaiGejala.toStringAsFixed(2)}';

    _berikanSaran();                               
  }

  void _berikanSaran() {
    if (_totalNilaiGejala >= 0.6) {
      _saran = 'Risiko tinggi – segera periksa dokter.';
    } else if (_totalNilaiGejala >= 0.3) {
      _saran = 'Risiko sedang – pertimbangkan konsultasi.';
    } else {
      _saran = 'Risiko rendah – tetap pantau kesehatan.';
    }
    setState(() {}); // Memanggil setState untuk memperbarui tampilan
  }
  // =======================
  // END PERHITUNGAN
  // =======================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pemeriksaan Gejala'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Perbarui Data',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildGejalaList()),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _hitungNilaiGejala,
                child: const Text('Periksa Gejala'),
              ),
            ),
            if (_hasilPerhitungan.isNotEmpty) // Tampilkan hasil perhitungan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  _hasilPerhitungan,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            if (_saran.isNotEmpty) // Tampilkan saran
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.orange.shade400),
                  ),
                  child: Text(
                    'Saran: $_saran',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGejalaList() {
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

    if (_gejalaJawabanList.isEmpty) {
      return const Center(
        child: Text('Tidak ada data gejala yang tersedia'),
      );
    }

    return SmartRefresher(
      controller: _refreshController,
      onRefresh: _refreshData,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _gejalaJawabanList.length,
        itemBuilder: (context, index) {
          final gejalaJawaban = _gejalaJawabanList[index];
          return _buildGejalaRow(gejalaJawaban);
        },
      ),
    );
  }

  Widget _buildGejalaRow(GejalaJawaban gejalaJawaban) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  gejalaJawaban.gejala.nama,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('MB: ${gejalaJawaban.gejala.mb.toStringAsFixed(2)}, MD: ${gejalaJawaban.gejala.md.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Radio<JawabanGejala>(
                value: JawabanGejala.ya,
                groupValue: gejalaJawaban.jawaban,
                onChanged: (JawabanGejala? value) {
                  setState(() {
                    gejalaJawaban.jawaban = value!;
                  });
                },
              ),
              const Text('Ya'),
              Radio<JawabanGejala>(
                value: JawabanGejala.tidak,
                groupValue: gejalaJawaban.jawaban,
                onChanged: (JawabanGejala? value) {
                  setState(() {
                    gejalaJawaban.jawaban = value!;
                  });
                },
              ),
              const Text('Tidak'),
            ],
          ),
        ],
      ),
    );
  }
}