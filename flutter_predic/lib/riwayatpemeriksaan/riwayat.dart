import 'package:flutter/material.dart';
import '../api/riwayat_api.dart';
import '../model/riwayat_model.dart'; // Pastikan path ke model Riwayat benar

class RiwayatPage extends StatefulWidget {
  @override
  _RiwayatPageState createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  late Future<List<PrediksiRiwayat>> _riwayatFuture;

  @override
  void initState() {
    super.initState();
    _riwayatFuture = RiwayatApi.getCurrentUserHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pemeriksaan'),
      ),
      body: FutureBuilder<List<PrediksiRiwayat>>(
        future: _riwayatFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada riwayat pemeriksaan.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final riwayat = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tanggal: ${riwayat.createdAt}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Gejala: ${riwayat.symptoms ?? '-'}'),
                        Text('Hasil Prediksi: ${riwayat.predictionResult ?? '-'}'),
                        // Tambahkan detail lain sesuai model Riwayat Anda
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}