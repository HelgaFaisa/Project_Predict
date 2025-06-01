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

  // Enhanced soft blue gradient palette
  final LinearGradient appBarGradient = LinearGradient(
    colors: [Color.fromARGB(255, 23, 139, 234), Color.fromARGB(255, 10, 108, 195), Color.fromARGB(255, 6, 79, 153)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Main background gradient - softer blue tones (very gentle progression)
  final LinearGradient backgroundGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 80, 167, 239),      // Biru soft (lightest)
      Color.fromARGB(255, 124, 194, 252),      // Biru muda lembut (very light)
      Color.fromARGB(255, 183, 217, 242),      // Biru sangat muda (almost white)
    ],
    stops: [0.0, 0.6, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  final LinearGradient cardGradient = LinearGradient(
    colors: [
      Colors.white,
      Color(0xFFE3F2FD),      // Biru sangat muda
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final LinearGradient fabGradient = LinearGradient(
    colors: [
      Color(0xFF64B5F6),      // Biru medium soft
      Color(0xFF42A5F5),      // Biru lembut
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 23, 139, 234), Color.fromARGB(255, 10, 108, 195), Color.fromARGB(255, 6, 79, 153)],
              stops: [0.0, 0.5, 1.0],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
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
                    color: Colors.black.withOpacity(0.2),
                  ),
                ]
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
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
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        child: RefreshIndicator(
          onRefresh: loadEdukasi,
          color: Color(0xFF42A5F5),
          backgroundColor: Colors.white,
          child: isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF42A5F5)),
                          strokeWidth: 3,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Memuat artikel...',
                        style: TextStyle(
                          color: Color(0xFF1976D2),
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
                            color: Color(0xFF42A5F5),
                            size: 60,
                          ),
                          SizedBox(height: 16),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              errorMessage,
                              style: TextStyle(
                                color: Color(0xFF1976D2),
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                              softWrap: true,
                            ),
                          ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF42A5F5),
                              foregroundColor: Colors.white,
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
                                color: Color(0xFF64B5F6),
                                size: 80,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Tidak ada artikel edukasi tersedia',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1976D2),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.only(top: 110, bottom: 20, left: 16, right: 16),
                          itemCount: edukasiList.length,
                          itemBuilder: (context, index) {
                            final item = edukasiList[index];
                            // Gunakan helper function untuk ekstraksi nilai yang aman
                            final String judul = getStringValue(item['title']);
                            final String konten = getStringValue(item['content']);
                            final String? gambarUrl = item['main_image_path'] is String ? item['main_image_path'] : null;
                            final String tanggal = formatDate(item['created_at']);

                            return Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  // Responsive card sizing
                                  double cardHeight = constraints.maxWidth > 600 ? 400 : 320;
                                  
                                  return Container(
                                    height: cardHeight,
                                    child: Stack(
                                      children: [
                                        // Card dengan efek elevasi
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0xFF42A5F5).withOpacity(0.15),
                                                spreadRadius: 2,
                                                blurRadius: 15,
                                                offset: Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          child: Card(
                                            margin: EdgeInsets.zero,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Container(
                                              height: cardHeight,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                gradient: cardGradient,
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  // Bagian yang clickable untuk membuka detail (gambar + konten utama)
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) => ArtikelDetailPage(artikel: item),
                                                          ),
                                                        );
                                                      },
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(20),
                                                        topRight: Radius.circular(20),
                                                      ),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          // Gambar dengan efek gradien overlay
                                                          Expanded(
                                                            flex: 3,
                                                            child: gambarUrl != null && gambarUrl.isNotEmpty
                                                                ? ClipRRect(
                                                                    borderRadius: BorderRadius.only(
                                                                      topLeft: Radius.circular(20),
                                                                      topRight: Radius.circular(20),
                                                                    ),
                                                                    child: Stack(
                                                                      children: [
                                                                        Container(
                                                                          width: double.infinity,
                                                                          height: double.infinity,
                                                                          child: Image.network(
                                                                            gambarUrl,
                                                                            fit: BoxFit.cover,
                                                                            errorBuilder: (context, error, stackTrace) {
                                                                              return Container(
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
                                                                        // Efek gradien yang lebih soft
                                                                        Positioned(
                                                                          bottom: 0,
                                                                          left: 0,
                                                                          right: 0,
                                                                          child: Container(
                                                                            height: 60,
                                                                            decoration: BoxDecoration(
                                                                              gradient: LinearGradient(
                                                                                begin: Alignment.bottomCenter,
                                                                                end: Alignment.topCenter,
                                                                                colors: [
                                                                                  Colors.black.withOpacity(0.3),
                                                                                  Colors.transparent,
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.only(
                                                                        topLeft: Radius.circular(20),
                                                                        topRight: Radius.circular(20),
                                                                      ),
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
                                                                        Icons.article_outlined,
                                                                        color: Colors.white,
                                                                        size: 60,
                                                                      ),
                                                                    ),
                                                                  ),
                                                          ),
                                                          // Content section (tanpa button)
                                                          Expanded(
                                                            flex: 2,
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  // Title - Responsive font size
                                                                  Flexible(
                                                                    child: Text(
                                                                      judul,
                                                                      style: TextStyle(
                                                                        fontSize: constraints.maxWidth > 600 ? 18 : 16,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Color(0xFF1976D2),
                                                                        height: 1.2,
                                                                      ),
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 8),
                                                                  
                                                                  // Date badge - More compact
                                                                  Container(
                                                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                                    decoration: BoxDecoration(
                                                                      gradient: LinearGradient(
                                                                        colors: [
                                                                          Color(0xFF90CAF9),
                                                                          Color(0xFF64B5F6),
                                                                        ],
                                                                        begin: Alignment.centerLeft,
                                                                        end: Alignment.centerRight,
                                                                      ),
                                                                      borderRadius: BorderRadius.circular(15),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Icon(
                                                                          Icons.calendar_today,
                                                                          size: 12,
                                                                          color: Colors.white,
                                                                        ),
                                                                        SizedBox(width: 4),
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
                                                                  
                                                                  SizedBox(height: 8),
                                                                  
                                                                  // Content preview - Flexible
                                                                  Expanded(
                                                                    child: Text(
                                                                      konten.length > 80
                                                                          ? '${konten.substring(0, 80)}...'
                                                                          : konten,
                                                                      style: TextStyle(
                                                                        fontSize: 13,
                                                                        color: Colors.black87,
                                                                        height: 1.4,
                                                                      ),
                                                                      maxLines: 2,
                                                                      overflow: TextOverflow.ellipsis,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  
                                                  // Button "Baca Selengkapnya" - Lebih compact
                                                  Container(
                                                    padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => ArtikelDetailPage(artikel: item),
                                                              ),
                                                            );
                                                          },
                                                          child: Container(
                                                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                            decoration: BoxDecoration(
                                                              gradient: LinearGradient(
                                                                colors: [
                                                                  Color(0xFF64B5F6),
                                                                  Color(0xFF42A5F5),
                                                                ],
                                                                begin: Alignment.centerLeft,
                                                                end: Alignment.centerRight,
                                                              ),
                                                              borderRadius: BorderRadius.circular(20),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Color(0xFF42A5F5).withOpacity(0.3),
                                                                  blurRadius: 6,
                                                                  offset: Offset(0, 2),
                                                                ),
                                                              ],
                                                            ),
                                                            child: Row(
                                                              mainAxisSize: MainAxisSize.min,
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
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
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
              color: Color(0xFF42A5F5).withOpacity(0.3),
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