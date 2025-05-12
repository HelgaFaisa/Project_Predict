import 'package:flutter/material.dart';
import '../api/edukasi_api.dart';
import '../edukasi/ArtikelDetailPage.dart';

class EdukasiPage extends StatefulWidget {
  @override
  _EdukasiPageState createState() => _EdukasiPageState();
}

class _EdukasiPageState extends State<EdukasiPage> {
  List<dynamic> edukasiList = [];
  bool isLoading = true;
  String errorMessage = '';

  // Enhanced blue gradient palette
  final LinearGradient appBarGradient = LinearGradient(
    colors: [
      Color(0xFF0D47A1),      // Deep blue
      Color(0xFF1565C0),      // Rich blue
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Main background gradient - three-tier blue gradient (tua, setengah muda, muda)
  final LinearGradient backgroundGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 103, 159, 243),      // Deep blue (biru tua)
      Color.fromARGB(255, 144, 192, 241),      // Medium blue (setengah muda)
      Color.fromARGB(255, 181, 217, 246),      // Light blue (biru muda)
    ],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  final LinearGradient cardGradient = LinearGradient(
    colors: [
      Colors.white,
      Color(0xFFE1F5FE),      // Light blue 50
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final LinearGradient fabGradient = LinearGradient(
    colors: [
      Color(0xFF1976D2),      // Primary blue
      Color(0xFF0D47A1),      // Darker blue
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  @override
  void initState() {
    super.initState();
    loadEdukasi();
  }

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
        return value.toString();
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

  Future<void> loadEdukasi() async {
    try {
      final data = await EdukasiApi.getAllArticles();
      print('Data berhasil diambil: $data');
      setState(() {
        edukasiList = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error ambil data: $e');
      setState(() {
        errorMessage = 'Gagal memuat artikel: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Artikel Edukasi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 3.0,
                color: Colors.black.withOpacity(0.3),
              ),
            ]
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
                  flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0D47A1),     // Biru Sangat Gelap
                Color(0xFF1976D2),     // Biru Medium
                Color(0xFF42A5F5),     // Biru Muda
              ],
              stops: [0.0, 0.5, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Implementasi pencarian
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient, // Menggunakan gradien tiga tingkat (tua, setengah muda, muda)
        ),
        child: RefreshIndicator(
          onRefresh: loadEdukasi,
          color: Colors.white,
          backgroundColor: Color(0xFF1976D2),
          child: isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 3,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Memuat artikel...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : errorMessage.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.white,
                            size: 60,
                          ),
                          SizedBox(height: 16),
                          Text(
                            errorMessage,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color(0xFF1976D2),
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: loadEdukasi,
                            child: Text(
                              'Coba Lagi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : edukasiList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.article_outlined,
                                color: Colors.white.withOpacity(0.9),
                                size: 80,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Tidak ada artikel edukasi tersedia',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(top: 100, bottom: 20, left: 16, right: 16),
                          itemCount: edukasiList.length,
                          itemBuilder: (context, index) {
                            final item = edukasiList[index];
                            // Gunakan helper function untuk ekstraksi nilai yang aman
                            final String judul = getStringValue(item['title']);
                            final String konten = getStringValue(item['content']);
                            final String? gambarUrl = item['main_image_path'] is String ? item['main_image_path'] : null;
                            final String tanggal = formatDate(item['created_at']);

                            return Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: Stack(
                                children: [
                                  // Card dengan efek elevasi
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 15,
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Card(
                                      margin: EdgeInsets.zero,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          gradient: cardGradient,
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ArtikelDetailPage(artikel: item),
                                              ),
                                            );
                                          },
                                          borderRadius: BorderRadius.circular(16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Gambar dengan efek gradien overlay
                                              if (gambarUrl != null && gambarUrl.isNotEmpty)
                                                ClipRRect(
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(16),
                                                    topRight: Radius.circular(16),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        height: 180,
                                                        width: double.infinity,
                                                        child: Image.network(
                                                          gambarUrl,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (context, error, stackTrace) {
                                                            return Container(
                                                              height: 180,
                                                              decoration: BoxDecoration(
                                                                gradient: LinearGradient(
                                                                  colors: [
                                                                    Color(0xFFBBDEFB),
                                                                    Color(0xFF90CAF9),
                                                                  ],
                                                                  begin: Alignment.topLeft,
                                                                  end: Alignment.bottomRight,
                                                                ),
                                                              ),
                                                              child: Center(
                                                                child: Icon(
                                                                  Icons.image_not_supported_outlined,
                                                                  color: Colors.white,
                                                                  size: 60,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      // Efek gradien
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
                                                ),
                                              Padding(
                                                padding: EdgeInsets.all(20),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      judul,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
                                                        color: Color(0xFF0D47A1),
                                                        height: 1.3,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                          colors: [
                                                            Color(0xFF64B5F6),
                                                            Color(0xFF2196F3),
                                                          ],
                                                          begin: Alignment.centerLeft,
                                                          end: Alignment.centerRight,
                                                        ),
                                                        borderRadius: BorderRadius.circular(20),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Color(0xFF64B5F6).withOpacity(0.3),
                                                            blurRadius: 8,
                                                            offset: Offset(0, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons.calendar_today,
                                                            size: 14,
                                                            color: Colors.white,
                                                          ),
                                                          SizedBox(width: 6),
                                                          Text(
                                                            tanggal,
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 16),
                                                    Text(
                                                      konten.length > 120
                                                          ? '${konten.substring(0, 120)}...'
                                                          : konten,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                        height: 1.5,
                                                      ),
                                                    ),
                                                    SizedBox(height: 16),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                          decoration: BoxDecoration(
                                                            gradient: LinearGradient(
                                                              colors: [
                                                                Color(0xFF2196F3),
                                                                Color(0xFF1976D2),
                                                              ],
                                                              begin: Alignment.centerLeft,
                                                              end: Alignment.centerRight,
                                                            ),
                                                            borderRadius: BorderRadius.circular(30),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Color(0xFF1976D2).withOpacity(0.3),
                                                                blurRadius: 8,
                                                                offset: Offset(0, 2),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "Baca Selengkapnya",
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                              SizedBox(width: 4),
                                                              Icon(
                                                                Icons.arrow_forward,
                                                                color: Colors.white,
                                                                size: 14,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
          gradient: fabGradient,
        ),
        child: FloatingActionButton(
          onPressed: () {
            // Implementasi refresh atau add
            loadEdukasi();
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(Icons.refresh, color: Colors.white),
        ),
      ),
    );
  }
}