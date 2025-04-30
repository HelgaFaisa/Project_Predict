import 'package:flutter/material.dart';

void main() {
  runApp(const DiabetesEducationApp());
}

class DiabetesEducationApp extends StatelessWidget {
  const DiabetesEducationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Edukasi Diabetes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: const DiabetesEducationHome(),
    );
  }
}

class DiabetesEducationHome extends StatelessWidget {
  const DiabetesEducationHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background gradient container
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A73E8),
                  Color(0xFF6AAFFF),
                ],
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.2, // Approximately 20% of screen height
          ),
          // Main column with safe area
          Column(
            children: [
              // Header with safe area
              SafeArea(
                bottom: false,
                child: _buildHeader(),
              ),
              // Content area
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: ArticlesListView(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      // Keep bottom navigation bar but don't modify it
      // We're adding padding to the content instead to create space
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Edukasi Diabetes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Informasi lengkap seputar diabetes',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class ArticlesListView extends StatelessWidget {
  ArticlesListView({Key? key}) : super(key: key);

  final List<ArticleData> articles = [
    ArticleData(
      title: 'Pengertian Dasar Diabetes',
      description: 'Pelajari tentang apa itu diabetes, jenisnya, dan penyebabnya.',
      icon: Icons.medical_services,
      color: Color(0xFF1A73E8),
    ),
    ArticleData(
      title: 'Pola Makan Sehat',
      description: 'Tips pola makan sehat untuk mengelola diabetes.',
      icon: Icons.restaurant,
      color: Color(0xFF4285F4),
    ),
    ArticleData(
      title: 'Aktivitas Fisik',
      description: 'Rekomendasi olahraga dan aktivitas fisik untuk penderita diabetes.',
      icon: Icons.directions_run,
      color: Color(0xFF5E97F6),
    ),
    ArticleData(
      title: 'Pengelolaan Obat dan Insulin',
      description: 'Panduan penggunaan obat dan insulin untuk diabetes.',
      icon: Icons.medication,
      color: Color(0xFF1A73E8),
    ),
    ArticleData(
      title: 'Pemantauan Gula Darah',
      description: 'Cara memantau kadar gula darah secara efektif dan teratur.',
      icon: Icons.monitor_heart,
      color: Color(0xFF4285F4),
    ),
    ArticleData(
      title: 'Gejala Hipoglikemia dan Hiperglikemia',
      description: 'Kenali tanda dan gejala kadar gula darah terlalu rendah atau tinggi.',
      icon: Icons.warning_amber_rounded,
      color: Color(0xFF5E97F6),
    ),
    ArticleData(
      title: 'Perawatan Kaki',
      description: 'Panduan perawatan kaki untuk mencegah komplikasi diabetes.',
      icon: Icons.accessibility,
      color: Color(0xFF1A73E8),
    ),
    ArticleData(
      title: 'Kesehatan Mental',
      description: 'Mengelola stres dan kesehatan mental dengan diabetes.',
      icon: Icons.psychology,
      color: Color(0xFF4285F4),
    ),
    ArticleData(
      title: 'Diabetes dan Kehidupan Sehari-hari',
      description: 'Tips hidup sehat dengan diabetes dalam aktivitas sehari-hari.',
      icon: Icons.home,
      color: Color(0xFF5E97F6),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 189), // Increased bottom padding to about 5 cm
      itemCount: articles.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleDetailScreen(article: articles[index]),
              ),
            );
          },
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.only(bottom: 16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    articles[index].color.withOpacity(0.1),
                  ],
                ),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: articles[index].color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    articles[index].icon,
                    color: articles[index].color,
                    size: 28,
                  ),
                ),
                title: Text(
                  articles[index].title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    articles[index].description,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: articles[index].color,
                  size: 18,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ArticleData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  ArticleData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class ArticleDetailScreen extends StatelessWidget {
  final ArticleData article;

  const ArticleDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background gradient container for header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  article.color,
                  article.color.withOpacity(0.7),
                ],
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.15, // Approximately 15% of screen height
          ),
          // Main column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          article.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.bookmark_border, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              // Content with rounded corners
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: article.color.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  article.icon,
                                  color: article.color,
                                  size: 28,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article.title,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '5 menit membaca',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          _buildArticleContent(article.title),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArticleContent(String title) {
    // Konten artikel berdasarkan judul
    Map<String, List<Map<String, dynamic>>> articleContents = {
      'Pengertian Dasar Diabetes': [
        {
          'type': 'heading',
          'content': 'Apa itu Diabetes?',
        },
        {
          'type': 'paragraph',
          'content': 'Diabetes mellitus adalah kondisi kronis yang ditandai dengan kadar glukosa (gula) darah yang tinggi karena tubuh tidak dapat memproduksi insulin yang cukup atau tidak dapat menggunakan insulin secara efektif. Insulin adalah hormon yang diproduksi oleh pankreas yang memungkinkan glukosa dari makanan yang kita konsumsi masuk ke dalam sel-sel tubuh untuk menghasilkan energi.',
        },
        {
          'type': 'heading',
          'content': 'Jenis-jenis Diabetes',
        },
        {
          'type': 'list',
          'items': [
            {'bold': 'Diabetes Tipe 1:', 'text': ' Tubuh tidak memproduksi insulin karena sistem kekebalan tubuh menyerang dan menghancurkan sel-sel penghasil insulin di pankreas.'},
            {'bold': 'Diabetes Tipe 2:', 'text': ' Tubuh tidak menggunakan insulin dengan baik dan tidak dapat menjaga kadar gula darah pada tingkat normal.'},
            {'bold': 'Diabetes Gestasional:', 'text': ' Terjadi pada wanita hamil yang sebelumnya tidak memiliki riwayat diabetes.'},
            {'bold': 'Prediabetes:', 'text': ' Kondisi di mana kadar gula darah lebih tinggi dari normal tetapi belum cukup tinggi untuk didiagnosis sebagai diabetes tipe 2.'},
          ]
        },
        {
          'type': 'heading',
          'content': 'Faktor Risiko',
        },
        {
          'type': 'paragraph',
          'content': 'Beberapa faktor yang dapat meningkatkan risiko terkena diabetes antara lain:',
        },
        {
          'type': 'list',
          'items': [
            {'text': 'Riwayat keluarga dengan diabetes'},
            {'text': 'Kelebihan berat badan dan obesitas'},
            {'text': 'Kurangnya aktivitas fisik'},
            {'text': 'Usia di atas 45 tahun'},
            {'text': 'Tekanan darah tinggi'},
            {'text': 'Riwayat diabetes gestasional'},
            {'text': 'Kolesterol tinggi'},
          ]
        },
      ],
      'Pola Makan Sehat': [
        {
          'type': 'heading',
          'content': 'Prinsip Pola Makan untuk Diabetes',
        },
        {
          'type': 'paragraph',
          'content': 'Pola makan sehat sangat penting dalam pengelolaan diabetes. Tujuan utamanya adalah menjaga kadar gula darah tetap stabil, mengontrol berat badan, dan mencegah komplikasi diabetes.',
        },
        {
          'type': 'heading',
          'content': 'Rekomendasi Pola Makan',
        },
        {
          'type': 'list',
          'items': [
            {'bold': 'Jadwal Makan Teratur:', 'text': ' Makan pada waktu yang sama setiap hari untuk membantu menjaga kadar gula darah stabil.'},
            {'bold': 'Porsi Terkontrol:', 'text': ' Gunakan metode piring untuk mengontrol porsi (½ piring sayuran, ¼ piring protein, ¼ piring karbohidrat kompleks).'},
            {'bold': 'Pilih Karbohidrat Kompleks:', 'text': ' Konsumsi biji-bijian utuh, seperti nasi merah, roti gandum, oatmeal, dan quinoa.'},
            {'bold': 'Tingkatkan Asupan Serat:', 'text': ' Konsumsi lebih banyak sayuran, buah-buahan, biji-bijian utuh, dan kacang-kacangan.'},
            {'bold': 'Batasi Gula dan Makanan Olahan:', 'text': ' Kurangi konsumsi minuman manis, permen, kue, dan makanan olahan lainnya.'},
          ]
        },
        {
          'type': 'heading',
          'content': 'Metode Penghitungan Karbohidrat',
        },
        {
          'type': 'paragraph',
          'content': 'Menghitung karbohidrat dapat membantu mengontrol kadar gula darah. Satu "porsi" karbohidrat setara dengan 15 gram karbohidrat. Jumlah porsi yang direkomendasikan bervariasi tergantung pada kebutuhan individu, biasanya berkisar antara 3-5 porsi per waktu makan untuk wanita dan 4-6 porsi untuk pria.',
        },
      ],
      'Aktivitas Fisik': [
        {
          'type': 'heading',
          'content': 'Manfaat Aktivitas Fisik',
        },
        {
          'type': 'paragraph',
          'content': 'Aktivitas fisik teratur memiliki banyak manfaat bagi penderita diabetes, antara lain:',
        },
        {
          'type': 'list',
          'items': [
            {'text': 'Meningkatkan sensitivitas insulin dan membantu sel-sel tubuh menggunakan glukosa dengan lebih efisien'},
            {'text': 'Membantu menurunkan dan mengelola berat badan'},
            {'text': 'Mengurangi risiko penyakit kardiovaskular'},
            {'text': 'Meningkatkan kesehatan mental dan mengurangi stres'},
            {'text': 'Memperbaiki kualitas tidur'},
          ]
        },
        {
          'type': 'heading',
          'content': 'Rekomendasi Aktivitas Fisik',
        },
        {
          'type': 'paragraph',
          'content': 'American Diabetes Association merekomendasikan:',
        },
        {
          'type': 'list',
          'items': [
            {'bold': 'Aktivitas Aerobik:', 'text': ' Minimal 150 menit per minggu dengan intensitas sedang (seperti jalan cepat, bersepeda, berenang)'},
            {'bold': 'Latihan Kekuatan:', 'text': ' 2-3 kali seminggu, melatih semua kelompok otot utama'},
            {'bold': 'Mengurangi Waktu Duduk:', 'text': ' Setiap 30 menit duduk, bergeraklah selama beberapa menit'},
          ]
        },
      ],
      // Template default untuk artikel lainnya
      'default': [
        {
          'type': 'heading',
          'content': 'Informasi ' + title,
        },
        {
          'type': 'paragraph',
          'content': 'Artikel ini berisi informasi penting tentang ' + title.toLowerCase() + ' untuk membantu Anda mengelola diabetes dengan lebih baik. Konten lengkap sedang dalam proses pengembangan.',
        },
        {
          'type': 'paragraph',
          'content': 'Silakan kembali lagi nanti untuk mendapatkan informasi yang lebih lengkap dan terperinci mengenai topik ini.',
        },
      ],
    };

    // Mengambil konten artikel berdasarkan judul, jika tidak ada gunakan default
    List<Map<String, dynamic>> content = (articleContents[title] ?? articleContents['default'])!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: content.map((item) {
        switch (item['type']) {
          case 'heading':
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
              child: Text(
                item['content'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A73E8),
                ),
              ),
            );
          case 'paragraph':
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                item['content'],
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
            );
          case 'list':
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0, left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: (item['items'] as List).map<Widget>((listItem) {
                  if (listItem.containsKey('bold')) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: listItem['bold'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
                                height: 1.5,
                              ),
                            ),
                            TextSpan(
                              text: listItem['text'],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A73E8),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              listItem['text'],
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }).toList(),
              ),
            );
          default:
            return SizedBox.shrink();
        }
      }).toList(),
    );
  }
}