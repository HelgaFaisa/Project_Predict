import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Pastikan ini diimport untuk DateFormat
import '../api/riwayat_api.dart'; // Sesuaikan path jika berbeda
import '../model/riwayat_model.dart'; // Sesuaikan path jika berbeda

// Import untuk CardContainer dan EnhancedProfileHeader
// Sesuaikan path jika file homepage.dart Anda memiliki nama atau lokasi berbeda
import '../home_page.dart'; 

class RiwayatPage extends StatefulWidget {
  final String userName; // RiwayatPage sekarang membutuhkan userName
  const RiwayatPage({Key? key, required this.userName}) : super(key: key);

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

  String formatDate(DateTime? date) {
    if (date == null) return '-';
    // Asumsi 'id_ID' sudah diinisialisasi di main.dart
    return DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(date);
  }

  void _refreshRiwayat() {
    setState(() {
      _riwayatFuture = RiwayatApi.getCurrentUserHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Latar belakang konsisten
      body: Column( // Menggunakan Column agar header dan list bisa di-scroll bersama
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Profil (Sama seperti di HomePage dan TargetHidupPage)
          EnhancedProfileHeader(
            userName: widget.userName,
            onAvatarTap: () {
              // Navigasi ke halaman profil jika ada
              // Navigator.pushNamed(context, '/profile', arguments: {
              //   'userName': widget.userName,
              //   // 'userRole': 'PeranJikaAda', // Jika ProfilePage butuh userRole dan Anda memilikinya di sini
              //   // 'patientId': 'IdPasienJikaAda', // Jika ProfilePage butuh patientId
              // });
            },
          ),
          // 2. Judul Halaman
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Riwayat Pemeriksaan',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.refresh_rounded, color: Colors.blue.shade700, size: 28),
                  onPressed: _refreshRiwayat,
                  tooltip: 'Muat Ulang Riwayat',
                )
              ],
            ),
          ),
          // 3. Konten Utama (List Riwayat)
          Expanded(
            child: FutureBuilder<List<PrediksiRiwayat>>(
              future: _riwayatFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return _buildStateCard(
                    icon: Icons.error_outline_rounded,
                    color: Colors.red.shade400,
                    title: 'Gagal Memuat Riwayat',
                    subtitle: 'Terjadi kesalahan: ${snapshot.error}. Coba muat ulang.',
                    onRetry: _refreshRiwayat,
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildStateCard(
                    icon: Icons.history_toggle_off_rounded,
                    color: Colors.blue.shade300,
                    title: 'Belum Ada Riwayat',
                    subtitle: 'Data pemeriksaan Anda akan muncul di sini setelah Anda melakukan pemeriksaan.',
                  );
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20), // Padding untuk list
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final riwayat = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: CardContainer( // Menggunakan CardContainer
                          padding: const EdgeInsets.all(16),
                          child: InkWell(
                            onTap: () => _showDetailDialog(context, riwayat),
                            borderRadius: BorderRadius.circular(24), // Samakan dengan CardContainer
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today_outlined, color: Colors.blue.shade700, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        formatDate(riwayat.predictionTimestamp ?? riwayat.createdAt),
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600, // Dibuat lebih tebal
                                            fontSize: 15,
                                            color: Colors.blue.shade800),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Hasil Prediksi: ',
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.grey.shade700,
                                                fontWeight: FontWeight.w500)),
                                        const SizedBox(width: 4),
                                        _buildPredictionResultChip(riwayat.predictionResult ?? riwayat.result),
                                      ],
                                    ),
                                     Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
                                  ],
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
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan status (Error/Empty) yang lebih baik
  Widget _buildStateCard({required IconData icon, required Color color, required String title, required String subtitle, VoidCallback? onRetry}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CardContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Agar kartu tidak memenuhi layar jika konten sedikit
            children: [
              Icon(icon, size: 60, color: color),
              const SizedBox(height: 16),
              Text(
                title,
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text('Coba Lagi', style: GoogleFonts.poppins()),
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600, foregroundColor: Colors.white),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildPredictionResultChip(String? result) {
    Color textColor;
    Color bgColor;
    String displayText;

    if (result == null || result.isEmpty) {
      textColor = Colors.grey.shade700;
      bgColor = Colors.grey.shade200;
      displayText = 'N/A';
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16), // Dibuat lebih rounded
        border: Border.all(color: textColor.withOpacity(0.4)),
      ),
      child: Text(
        displayText,
        style: GoogleFonts.poppins(
          color: textColor,
          fontWeight: FontWeight.w600, // Dibuat lebih tebal
          fontSize: 12,
        ),
      ),
    );
  }

  void _showDetailDialog(BuildContext context, PrediksiRiwayat riwayat) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0, // Agar bayangan dari CardContainer lebih terlihat jika perlu
        backgroundColor: Colors.transparent, // Agar bisa memakai CardContainer
        child: CardContainer( // Menggunakan CardContainer untuk dialog
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView( // Agar bisa di-scroll jika konten panjang
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.blue.shade100, borderRadius: BorderRadius.circular(12)),
                      child: Icon(Icons.receipt_long_outlined, color: Colors.blue.shade700, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Detail Pemeriksaan',
                      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _detailItem(Icons.calendar_today_outlined, 'Tanggal', formatDate(riwayat.predictionTimestamp ?? riwayat.createdAt)),
                _detailItem(Icons.medical_information_outlined, 'Hasil Prediksi', _getPredictionText(riwayat.predictionResult ?? riwayat.result)),
                Divider(color: Colors.blue.shade100, thickness: 1, height: 32),
                 Text(
                  'Data Input Pemeriksaan:',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.blue.shade700),
                ),
                const SizedBox(height: 12),
                _detailItem(Icons.elderly_outlined, 'Usia', riwayat.age?.toString() ?? '-'),
                _detailItem(Icons.height_rounded, 'Tinggi Badan', riwayat.height != null ? '${riwayat.height} cm' : '-'),
                _detailItem(Icons.fitness_center_rounded, 'Berat Badan', riwayat.weight != null ? '${riwayat.weight} kg' : '-'),
                _detailItem(Icons.monitor_weight_outlined, 'BMI', riwayat.bmi?.toStringAsFixed(2) ?? '-'),
                _detailItem(Icons.opacity_outlined, 'Glukosa', riwayat.glucose?.toString() ?? '-'), // Ikon disesuaikan
                _detailItem(Icons.favorite_outline_rounded, 'Tekanan Darah', riwayat.bloodPressure?.toString() ?? '-'),
                _detailItem(Icons.pregnant_woman_outlined, 'Kehamilan', riwayat.pregnancies?.toString() ?? '-'), // Ikon disesuaikan
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text('Tutup', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.blue.shade700)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getPredictionText(String? result) {
    if (result == null || result.isEmpty) return '-';
    if (result.toLowerCase() == 'positif' || result.toLowerCase() == 'positive' || result.toLowerCase() == '1' || result.toLowerCase() == 'true') {
      return 'Positif';
    } else {
      return 'Negatif';
    }
  }

  Widget _detailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Jarak antar item
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue.shade400),
          const SizedBox(width: 12),
          SizedBox(
            width: 110, // Lebar label disesuaikan
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.grey.shade700, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}