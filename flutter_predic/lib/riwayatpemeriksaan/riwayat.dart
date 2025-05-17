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

  // Define gradient colors for app theme - matching the screenshot
  final LinearGradient _appGradient = const LinearGradient(
    colors: [Color(0xFF0A4AA0), Color(0xFF1465D1), Color(0xFF2E8FE3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Lighter gradient for content backgrounds
  final LinearGradient _cardGradient = const LinearGradient(
    colors: [Color(0xFFFAFAFA), Color(0xFFD6E9F8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

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
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(gradient: _appGradient),
        ),
        title: const Text('Riwayat Pemeriksaan',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFF0A4AA0), const Color(0xFF5EABF3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<PrediksiRiwayat>>(
          future: _riwayatFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1976D2)),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 60, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text('Error: ${snapshot.error}',
                        style: const TextStyle(color: Color(0xFF0D47A1))),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 60, color: Colors.blue[300]),
                    const SizedBox(height: 16),
                    const Text(
                      'Belum ada riwayat pemeriksaan.',
                      style: TextStyle(
                          color: Color(0xFF0D47A1),
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              );
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final riwayat = snapshot.data![index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: _cardGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          _showDetailDialog(context, riwayat);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      color: Color(0xFF0D47A1), size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Tanggal: ${formatDate(riwayat.predictionTimestamp ?? riwayat.createdAt)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Color(0xFF0D47A1)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Text('Hasil Prediksi: ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFF1976D2),
                                          fontWeight: FontWeight.w500)),
                                  const SizedBox(width: 4),
                                  _buildPredictionResult(
                                      riwayat.predictionResult ?? riwayat.result),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () =>
                                      _showDetailDialog(context, riwayat),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1976D2),
                                    foregroundColor: Colors.white,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Lihat Detail'),
                                      SizedBox(width: 4),
                                      Icon(Icons.arrow_forward, size: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildPredictionResult(String? result) {
    Color textColor;
    Color bgColor;
    String displayText;

    if (result == null || result.isEmpty) {
      textColor = Colors.grey;
      bgColor = Colors.grey.withOpacity(0.1);
      displayText = '-';
    } else if (result.toLowerCase() == 'positif' ||
        result.toLowerCase() == 'positive' ||
        result.toLowerCase() == '1' ||
        result.toLowerCase() == 'true') {
      textColor = Colors.red.shade700;
      bgColor = Colors.red.shade50;
      displayText = 'Positif';
    } else {
      textColor = Colors.green.shade700;
      bgColor = Colors.green.shade50;
      displayText = 'Negatif';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withOpacity(0.7)),
        boxShadow: [
          BoxShadow(
            color: textColor.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, PrediksiRiwayat riwayat) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 8,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, const Color(0xFFD6E9F8)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1976D2).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.article_rounded,
                      color: Color(0xFF0D47A1),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Detail Pemeriksaan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _detailItem(Icons.calendar_today, 'Tanggal Pemeriksaan',
                  formatDate(riwayat.predictionTimestamp ?? riwayat.createdAt)),
              _detailItem(Icons.medical_information, 'Hasil Prediksi',
                  _getPredictionText(riwayat.predictionResult ?? riwayat.result)),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withOpacity(0.1),
                      Colors.blue.withOpacity(0.5),
                      Colors.blue.withOpacity(0.1),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF1976D2).withOpacity(0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Data Pemeriksaan:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _detailItem(
                        Icons.person, 'Usia', riwayat.age?.toString() ?? '-'),
                    _detailItem(Icons.height, 'Tinggi Badan',
                        riwayat.height != null ? '${riwayat.height} cm' : '-'),
                    _detailItem(Icons.fitness_center, 'Berat Badan',
                        riwayat.weight != null ? '${riwayat.weight} kg' : '-'),
                    _detailItem(Icons.monitor_weight, 'BMI',
                        riwayat.bmi?.toStringAsFixed(2) ?? '-'),
                    _detailItem(Icons.opacity, 'Glukosa',
                        riwayat.glucose?.toString() ?? '-'),
                    _detailItem(Icons.favorite, 'Tekanan Darah',
                        riwayat.bloodPressure?.toString() ?? '-'),
                    _detailItem(Icons.child_care, 'Kehamilan',
                        riwayat.pregnancies?.toString() ?? '-'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text('Tutup', style: TextStyle(fontSize: 16)),
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

  Widget _detailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: const Color(0xFF1976D2),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF1976D2),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}