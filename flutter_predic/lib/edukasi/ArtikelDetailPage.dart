import 'package:flutter/material.dart';
import 'dart:convert';

class ArtikelDetailPage extends StatelessWidget {
  final dynamic artikel;

  const ArtikelDetailPage({Key? key, required this.artikel}) : super(key: key);

  // Helper function untuk mendapatkan nilai String dari dynamic
  String getStringValue(dynamic value) {
    if (value == null) {
      return '';
    } else if (value is String) {
      return value;
    } else if (value is Map) {
      // Jika nilai adalah Map dan memiliki key 'rendered'
      if (value.containsKey('rendered')) {
        return value['rendered'] as String? ?? '';
      } else {
        // Jika Map tapi tidak punya key 'rendered', konversi ke JSON string
        return jsonEncode(value);
      }
    } else {
      // Untuk tipe data lain, konversi ke string
      return value.toString();
    }
  }

  // Helper function untuk memproses tanggal dari berbagai format
  String formatDate(dynamic dateValue) {
    try {
      if (dateValue == null) {
        return 'Tanggal tidak tersedia';
      }
      
      // Jika sudah berupa String format tanggal standar
      if (dateValue is String) {
        try {
          final date = DateTime.parse(dateValue);
          return '${date.day}/${date.month}/${date.year}';
        } catch (_) {
          return dateValue; // Kembalikan string asli jika tidak bisa di-parse
        }
      }
      
      // Jika dalam format MongoDB extended JSON
      if (dateValue is Map) {
        if (dateValue.containsKey('\$date')) {
          var mongoDate = dateValue['\$date'];
          
          // Format $date: { $numberLong: "timestamp" }
          if (mongoDate is Map && mongoDate.containsKey('\$numberLong')) {
            String timestamp = mongoDate['\$numberLong'].toString();
            try {
              // MongoDB timestamp biasanya dalam milidetik
              final date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
              return '${date.day}/${date.month}/${date.year}';
            } catch (_) {
              return 'Format tanggal tidak valid';
            }
          }
          
          // Format $date: "ISO string"
          else if (mongoDate is String) {
            try {
              final date = DateTime.parse(mongoDate);
              return '${date.day}/${date.month}/${date.year}';
            } catch (_) {
              return 'Format tanggal tidak valid';
            }
          }
        }
      }
      
      // Untuk tipe data lain, coba konversi
      return 'Tanggal tidak dikenali: ${dateValue.toString()}';
    } catch (e) {
      print('Error memproses tanggal: $e');
      return 'Tanggal tidak tersedia';
    }
  }

  @override
  Widget build(BuildContext context) {
    print('Data artikel yang diterima: $artikel');
    print('Tipe artikel: ${artikel.runtimeType}');

    // Amankan pengambilan data dengan pengecekan null dan tipe
    final String judul = artikel['title'] != null ? getStringValue(artikel['title']) : 'Judul Tidak Tersedia';
    final String konten = artikel['content'] != null ? getStringValue(artikel['content']) : 'Konten tidak tersedia';
    final String? gambarUrl = artikel['main_image_path'] is String ? artikel['main_image_path'] : null;
    final String tanggal = formatDate(artikel['created_at']);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Artikel',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF2196F3),   // Biru Primary
                Color(0xFF0D47A1),   // Biru Gelap
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue[50]!,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (gambarUrl != null && gambarUrl.isNotEmpty)
                Stack(
                  children: [
                    Container(
                      height: 250,
                      width: double.infinity,
                      child: Image.network(
                        gambarUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.blue[100],
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 80,
                                color: Colors.blue[800],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(gambarUrl != null && gambarUrl.isNotEmpty ? 20 : 0),
                    topRight: Radius.circular(gambarUrl != null && gambarUrl.isNotEmpty ? 20 : 0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                margin: EdgeInsets.only(top: gambarUrl != null && gambarUrl.isNotEmpty ? -20 : 0),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      judul,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D47A1),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF64B5F6),   // Biru Muda
                            Color(0xFF1976D2),   // Biru Medium
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Colors.white,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Dipublikasikan: $tanggal',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: 50,
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF2196F3),   // Biru Primary
                            Color(0xFF64B5F6),   // Biru Muda
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      konten,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFE3F2FD),   // Biru Sangat Muda
                            Color(0xFFBBDEFB),   // Biru Muda
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Color(0xFF1976D2),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Artikel ini disediakan untuk tujuan edukasi',
                              style: TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Color(0xFF1565C0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: Color(0xFF1976D2),
        child: Icon(Icons.arrow_back, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}