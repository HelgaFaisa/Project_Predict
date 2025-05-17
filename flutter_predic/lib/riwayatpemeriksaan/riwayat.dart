import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api/riwayat_api.dart';
import '../model/riwayat_model.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({Key? key}) : super(key: key);

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

  // Format datetime to a readable format
  String formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: InkWell(
                    onTap: () {
                      _showDetailDialog(context, riwayat);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tanggal: ${formatDate(riwayat.predictionTimestamp ?? riwayat.createdAt)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text('Hasil Prediksi: ', style: TextStyle(fontSize: 15)),
                              _buildPredictionResult(riwayat.predictionResult ?? riwayat.result),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => _showDetailDialog(context, riwayat),
                              child: const Text('Lihat Detail'),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildPredictionResult(String? result) {
    Color textColor;
    String displayText;
    
    if (result == null || result.isEmpty) {
      textColor = Colors.grey;
      displayText = '-';
    } else if (result.toLowerCase() == 'positif' || 
               result.toLowerCase() == 'positive' || 
               result.toLowerCase() == '1' ||
               result.toLowerCase() == 'true') {
      textColor = Colors.red;
      displayText = 'Positif';
    } else {
      textColor = Colors.green;
      displayText = 'Negatif';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: textColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textColor)
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, PrediksiRiwayat riwayat) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Detail Pemeriksaan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _detailItem('Tanggal Pemeriksaan', formatDate(riwayat.predictionTimestamp ?? riwayat.createdAt)),
              _detailItem('Hasil Prediksi', _getPredictionText(riwayat.predictionResult ?? riwayat.result)),
              const Divider(height: 24),
              const Text('Data Pemeriksaan:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _detailItem('Usia', riwayat.age?.toString() ?? '-'),
              _detailItem('Tinggi Badan', riwayat.height != null ? '${riwayat.height} cm' : '-'),
              _detailItem('Berat Badan', riwayat.weight != null ? '${riwayat.weight} kg' : '-'),
              _detailItem('BMI', riwayat.bmi?.toStringAsFixed(2) ?? '-'),
              _detailItem('Glukosa', riwayat.glucose?.toString() ?? '-'),
              _detailItem('Tekanan Darah', riwayat.bloodPressure?.toString() ?? '-'),
              _detailItem('Kehamilan', riwayat.pregnancies?.toString() ?? '-'),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Tutup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPredictionText(String? result) {
    if (result == null || result.isEmpty) {
      return '-';
    } else if (result.toLowerCase() == 'positif' || 
              result.toLowerCase() == 'positive' || 
              result.toLowerCase() == '1' ||
              result.toLowerCase() == 'true') {
      return 'Positif';
    } else {
      return 'Negatif';
    }
  }

  Widget _detailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
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