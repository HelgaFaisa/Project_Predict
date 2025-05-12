import 'package:flutter/material.dart';
import '../api/riwayat_api.dart'; // Ganti dengan path yang benar
import '../model/pemeriksaan_model.dart'; // Ganti dengan path yang benar

class RiwayatScreen extends StatefulWidget {
  final int pasienId;

  RiwayatScreen({required this.pasienId});

  @override
  _RiwayatScreenState createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  late RiwayatApi _riwayatApi;
  List<Pemeriksaan> _riwayat = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _riwayatApi = RiwayatApi(); // Tidak perlu base URL di sini jika sudah di dalam kelas RiwayatApi
    _fetchRiwayat();
  }

  Future<void> _fetchRiwayat() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final List<Pemeriksaan> fetchedRiwayat = await _riwayatApi.getRiwayat(widget.pasienId);
      setState(() {
        _riwayat = fetchedRiwayat;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Terjadi kesalahan saat memuat riwayat: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Pemeriksaan'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _riwayat.isEmpty
                  ? Center(child: Text('Tidak ada riwayat pemeriksaan untuk pasien ini.'))
                  : ListView.builder(
                      itemCount: _riwayat.length,
                      itemBuilder: (context, index) {
                        final Pemeriksaan pemeriksaan = _riwayat[index];
                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Tanggal: ${pemeriksaan.tanggal.toLocal().toString().split(' ')[0]}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 8.0),
                                if (pemeriksaan.gejala != null && pemeriksaan.gejala!.isNotEmpty)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Gejala:', style: TextStyle(fontWeight: FontWeight.bold)),
                                      for (var entry in pemeriksaan.gejala!.entries)
                                        Text('- ${entry.key}: ${entry.value}'),
                                      SizedBox(height: 8.0),
                                    ],
                                  ),
                                if (pemeriksaan.skor != null)
                                  Text('Skor: ${pemeriksaan.skor!.toStringAsFixed(2)}'),
                                if (pemeriksaan.hasil != null && pemeriksaan.hasil!.isNotEmpty)
                                  Text('Hasil: ${pemeriksaan.hasil}'),
                                // Tambahkan tampilan untuk field lain dari model Pemeriksaan
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}