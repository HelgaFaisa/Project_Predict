// lib/homepage.dart

import 'package:flutter/material.dart';
import 'dart:math'; // Dipertahankan jika masih ada penggunaan, misal di HealthGraphPage
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

// Halaman-halaman lain (Pastikan path import ini benar)
// Sesuaikan nama file jika berbeda dari yang kita kerjakan sebelumnya
import 'riwayatpemeriksaan/riwayat.dart'; // Pastikan ada file ini dan class RiwayatPage
import 'edukasi/edukasi.dart';           // Pastikan ada file ini dan class EdukasiPage
import 'target/targethidup.dart';     // Pastikan ada file ini dan class TargetHidupPage
import '../gejala/gejala_page.dart';     // Pastikan ada file ini dan class GejalaPage
// import 'logindokter/login.dart'; // Tidak biasanya diimport di homepage kecuali ada case khusus
// import 'logindokter/profile.dart'; // Untuk navigasi ke ProfilePage (jika ada)

// Model dan API (Pastikan path import ini benar)
import '../model/health_data.dart';
import '../api/health_data_api.dart';


// =========================================================================
// REKOMENDASI: Sebaiknya fungsi main() dan MyApp berada di file terpisah (main.dart)
// Saya akan tetap sertakan di sini jika Anda memang menginginkannya dalam satu file,
// namun ini tidak ideal untuk struktur proyek yang baik.
// =========================================================================
// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Health App', // Ganti dengan nama aplikasi Anda
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.blue[50],
//         fontFamily: GoogleFonts.poppins().fontFamily, // Default font
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         appBarTheme: AppBarTheme( // Global AppBar theme (jika ada AppBar standar)
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           iconTheme: IconThemeData(color: Colors.blue.shade800),
//           titleTextStyle: GoogleFonts.poppins(
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//             color: Colors.blue.shade800,
//           ),
//         ),
//         bottomNavigationBarTheme: BottomNavigationBarThemeData(
//           selectedItemColor: Colors.blue.shade700,
//           unselectedItemColor: Colors.grey.shade500,
//           selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
//           unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
//           backgroundColor: Colors.white,
//           elevation: 8.0,
//         ),
//       ),
//       // Ganti dengan halaman login Anda atau halaman utama jika sudah login
//       home: const HomePage(
//         userName: "Pengguna Tes", // Ganti dengan data pengguna aktual
//         patientId: "patient123", // Ganti dengan data pasien aktual
//         userRole: "Premium",     // Ganti dengan data peran aktual
//       ), 
//       routes: {
//         // '/profile': (context) => const ProfilePage(), // Contoh jika ProfilePage ada
//         // Anda bisa menggunakan onGenerateRoute untuk passing argumen ke ProfilePage
//       },
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
// =========================================================================


// ============== WIDGET REUSABLE UTAMA ==============
class CardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const CardContainer({required this.child, this.padding, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color.fromARGB(255, 224, 237, 248), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ============== EnhancedProfileHeader (Header Profil yang Lebih Baik) ==============
class EnhancedProfileHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onAvatarTap;

  const EnhancedProfileHeader(
      {Key? key, required this.userName, required this.onAvatarTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 20), // Sesuaikan margin jika perlu
      child: CardContainer(
        child: Row(
          children: [
            GestureDetector(
              onTap: onAvatarTap,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade600],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(3),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat datang,',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    userName,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Icon Notifikasi (bisa di-tap jika perlu)
            InkWell(
              onTap: (){
                // TODO: Aksi saat ikon notifikasi ditekan
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: Colors.blue.shade700,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ============== HALAMAN UTAMA ==============
class HomePage extends StatefulWidget {
  final String userName;
  final String patientId;
  final String userRole; // Tambahkan userRole jika akan digunakan

  const HomePage(
      {Key? key,
      required this.userName,
      required this.patientId,
      required this.userRole}) // Sesuaikan constructor
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int selectedIndex = 0;
  late AnimationController _fadeController; // Untuk animasi header
  late List<Widget> _pages; // Deklarasi _pages

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400), // Durasi animasi
      vsync: this,
    );

    // Inisialisasi _pages di sini, setelah widget.userName dan widget.patientId tersedia
    _pages = [
      HealthGraphPage(patientId: widget.patientId),
      RiwayatPage(userName: widget.userName), // Kirim userName jika RiwayatPage membutuhkannya
      EducationListScreen(userName: widget.userName), // Jika butuh userName, kirim juga
      TargetHidupPage(userName: widget.userName), // Kirim userName jika TargetHidupPage membutuhkannya
      GejalaPage(), // Jika butuh userName, kirim juga
    ];

    if (selectedIndex == 0) {
      _fadeController.forward(); // Jalankan animasi jika tab pertama aktif
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index != selectedIndex) {
      setState(() {
        selectedIndex = index;
      });
      if (index == 0) {
        _fadeController.forward(from: 0.0); // Mainkan animasi saat kembali ke tab Grafik
      } else {
        _fadeController.reverse(); // Sembunyikan header saat pindah dari tab Grafik
      }
    }
  }

  // Daftar item untuk BottomNavigationBar
  final List<Map<String, dynamic>> _navBarItems = [
    {'icon': Icons.bar_chart_rounded, 'label': 'Grafik'},
    {'icon': Icons.history_rounded, 'label': 'Riwayat'},
    {'icon': Icons.menu_book_rounded, 'label': 'Edukasi'},
    {'icon': Icons.flag_rounded, 'label': 'Target'}, // Icon diubah dari favorite
    {'icon': Icons.sick_outlined, 'label': 'Gejala'}, // Icon diubah dari medical_services
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Latar belakang solid
      body: SafeArea( // SafeArea untuk menghindari overlap dengan status bar
        child: Column(
          children: [
            // Header Profil yang Ditingkatkan, hanya tampil di tab pertama
            // dan dengan animasi
            if (selectedIndex == 0)
              AnimatedBuilder(
                animation: _fadeController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, -30 * (1 - _fadeController.value)), // Efek slide dari atas
                    child: Opacity(
                      opacity: _fadeController.value, // Efek fade
                      child: child,
                    ),
                  );
                },
                child: EnhancedProfileHeader(
                  userName: widget.userName,
                  onAvatarTap: () {
                    // Navigasi ke halaman profil jika ada
                    // Contoh jika Anda memiliki ProfilePage dan rute '/profile'
                    Navigator.pushNamed(context, '/profile', arguments: {
                      'userName': widget.userName,
                      'userRole': widget.userRole,
                      'patientId': widget.patientId,
                    });
                    print("Avatar tapped! Navigating to profile...");
                  },
                ),
              ),
            
            Expanded(
              child: IndexedStack( // Menggunakan IndexedStack untuk menjaga state halaman
                index: selectedIndex,
                children: _pages,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _navBarItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item['icon'] as IconData),
            label: item['label'] as String,
          );
        }).toList(),
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Agar semua label terlihat
        // Styling sudah diatur global di MyApp melalui bottomNavigationBarTheme
        // Jika tidak, Anda bisa set di sini:
        // selectedItemColor: Colors.blue.shade700,
        // unselectedItemColor: Colors.grey.shade500,
        // selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        // unselectedLabelStyle: GoogleFonts.poppins(),
      ),
    );
  }
}


// =========================================================================
// KODE UNTUK HealthGraphPage, _GraphCard, _LegendItem, _DescriptionCard
// SEBAIKNYA BERADA DI FILE TERPISAH (misal, health_graph_page.dart)
// Namun, jika Anda ingin tetap di sini, pastikan widget _CardContainer diganti dengan CardContainer
// Saya akan sertakan versi yang sudah disesuaikan di sini.
// =========================================================================

class HealthGraphPage extends StatefulWidget {
  final String patientId;

  const HealthGraphPage({Key? key, required this.patientId}) : super(key: key);

  @override
  State<HealthGraphPage> createState() => _HealthGraphPageState();
}

class _HealthGraphPageState extends State<HealthGraphPage> with TickerProviderStateMixin {
  late Future<List<HealthData>> _healthDataFuture;
  late AnimationController _loadingAnimationController; // Untuk animasi loading
  String _selectedPeriod = 'Bulanan'; // Periode default

  @override
  void initState() {
    super.initState();
    _loadingAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _healthDataFuture = HealthDataApi().fetchHealthData(widget.patientId);
  }

  @override
  void dispose() {
    _loadingAnimationController.dispose();
    super.dispose();
  }

  void _refreshData() {
    setState(() {
      _healthDataFuture = HealthDataApi().fetchHealthData(widget.patientId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Halaman Grafik
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Grafik Kesehatan',
                    style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pantau perkembangan kesehatan Anda',
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.refresh_rounded, color: Colors.blue.shade700, size: 28),
                onPressed: _refreshData,
                tooltip: 'Muat Ulang Data',
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Metrik Cepat (jika Anda ingin menambahkannya kembali)
          // _buildQuickMetricsRow(), 
          // const SizedBox(height: 24),

          FutureBuilder<List<HealthData>>(
            future: _healthDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingCard();
              } else if (snapshot.hasError) {
                return _buildErrorCard('Terjadi kesalahan: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyStateCard();
              } else {
                return _GraphCardPageContent( // Widget baru untuk konten jika data ada
                  healthData: snapshot.data!,
                  selectedPeriod: _selectedPeriod,
                  onPeriodChanged: (newPeriod) {
                    setState(() {
                      _selectedPeriod = newPeriod;
                      // TODO: Anda mungkin perlu memfilter ulang data grafik berdasarkan periode
                    });
                  },
                );
              }
            },
          ),
          const SizedBox(height: 20),
          _DescriptionCard(), // Card deskripsi tetap
          const SizedBox(height: 20), // Jarak tambahan di bawah
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return CardContainer(
      child: SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _loadingAnimationController,
                child: Icon(Icons.monitor_heart_outlined, size: 60, color: Colors.blue.shade300),
              ),
              const SizedBox(height: 20),
              Text('Memuat data grafik...', style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String errorMessage) {
    return CardContainer(
      child: SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline_rounded, size: 60, color: Colors.red.shade300),
              const SizedBox(height: 20),
              Text('Oops! Gagal Memuat Data', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
              const SizedBox(height: 8),
              Text(errorMessage, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]), textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh_rounded),
                label: Text('Coba Lagi', style: GoogleFonts.poppins()),
                onPressed: _refreshData,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600, foregroundColor: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyStateCard() {
     return CardContainer(
      child: SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inbox_outlined, size: 60, color: Colors.grey.shade400),
              const SizedBox(height: 20),
              Text('Belum Ada Data Kesehatan', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
              const SizedBox(height: 8),
              Text('Mulai lakukan pemeriksaan untuk melihat grafik Anda di sini.', style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget baru untuk menampung konten utama _GraphCard (agar _HealthGraphPageState tidak terlalu panjang)
class _GraphCardPageContent extends StatelessWidget {
  final List<HealthData> healthData;
  final String selectedPeriod;
  final Function(String) onPeriodChanged;

  const _GraphCardPageContent({
    required this.healthData,
    required this.selectedPeriod,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CardContainer( // Menggunakan CardContainer yang sudah kita buat
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tren Kesehatan',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
              ),
              _buildPeriodSelector(selectedPeriod, onPeriodChanged),
            ],
          ),
          const SizedBox(height: 20),
          _buildEnhancedLegend(),
          const SizedBox(height: 20),
          SizedBox(
            height: 280, // Tinggi grafik
            child: LineChart(_buildEnhancedChartData(healthData)),
          ),
           const SizedBox(height: 16),
          _buildChartInsights(),
        ],
      ),
    );
  }

  // --- FUNGSI-FUNGSI HELPER UNTUK GRAFIK ---
  // (Sama seperti yang ada di kode TargetHidupPage, tapi disesuaikan untuk HealthData)

  Widget _buildPeriodSelector(String currentPeriod, Function(String) onPeriodChangedCallback) {
    final periods = ['Harian', 'Mingguan', 'Bulanan']; // Contoh periode
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentPeriod,
          icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
          style: GoogleFonts.poppins(color: Colors.blue.shade700, fontWeight: FontWeight.w500),
          items: periods.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onPeriodChangedCallback(newValue);
            }
          },
        ),
      ),
    );
  }

  Widget _buildEnhancedLegend() {
    // Sesuaikan dengan data yang ingin Anda tampilkan di HealthGraphPage
    final legends = [
      {'color': Colors.purple.shade400, 'label': 'Glukosa'},
      {'color': Colors.green.shade400, 'label': 'Tekanan Darah'},
      {'color': Colors.blue.shade400, 'label': 'BMI'},
      {'color': Colors.orange.shade400, 'label': 'Berat Badan'},
    ];
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: legends.map((legend) {
        return Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: legend['color'] as Color, borderRadius: BorderRadius.circular(3))),
          const SizedBox(width: 6),
          Text(legend['label'] as String, style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[700])),
        ]);
      }).toList(),
    );
  }
   Widget _buildChartInsights() {
    // Insight bisa dinamis berdasarkan data jika perlu
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100)
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline_rounded, color: Colors.blue.shade600, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Tren menunjukkan perkembangan yang baik. Pertahankan gaya hidup sehat!',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.blue.shade700, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }


  LineChartData _buildEnhancedChartData(List<HealthData> data) {
    if (data.isEmpty) return LineChartData(); // Handle data kosong

    // Urutkan data berdasarkan timestamp untuk sumbu X yang benar
    data.sort((a, b) => a.predictionTimestamp.compareTo(b.predictionTimestamp));

    List<FlSpot> glucoseSpots = [];
    List<FlSpot> bpSpots = [];
    List<FlSpot> bmiSpots = [];
    List<FlSpot> weightSpots = [];

    for (int i = 0; i < data.length; i++) {
      final record = data[i];
      final xValue = i.toDouble(); // Gunakan index sebagai nilai X untuk kesederhanaan

      // Coba parse nilai, default ke 0.0 jika gagal atau null
      glucoseSpots.add(FlSpot(xValue, double.tryParse(record.glucose) ?? 0.0));
      bpSpots.add(FlSpot(xValue, double.tryParse(record.bloodPressure) ?? 0.0));
      // Skala BMI agar lebih terlihat, kalikan dengan faktor (misal 5 atau 10)
      bmiSpots.add(FlSpot(xValue, (double.tryParse(record.bmi) ?? 0.0) * 5)); 
      weightSpots.add(FlSpot(xValue, double.tryParse(record.weight) ?? 0.0));
    }
    
    // Tentukan minY dan maxY secara dinamis atau set manual
    double minY = 0; 
    double maxY = 200; // Sesuaikan ini berdasarkan rentang data Anda

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.1), strokeWidth: 1),
        getDrawingVerticalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.1), strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index >= 0 && index < data.length) {
                final date = data[index].predictionTimestamp;
                // Tampilkan setiap beberapa data agar tidak terlalu padat
                if (index % (data.length ~/ 5).clamp(1,data.length) == 0 || index == data.length -1) { 
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8.0,
                    child: Text('${date.day}/${date.month}', style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 10)),
                  );
                }
              }
              return Container();
            },
            // interval: (data.length / 5).ceilToDouble().clamp(1, double.infinity),
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              if (value % 20 == 0) { // Tampilkan label Y setiap kelipatan 20
                return Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(value.toInt().toString(), style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 10), textAlign: TextAlign.left)
                );
              }
              return Container();
            },
            interval: 20, // Interval sumbu Y
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1)),
      minX: 0,
      maxX: (data.length - 1).toDouble().clamp(0, double.infinity), // Pastikan tidak negatif
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        _buildLineBarData(glucoseSpots, Colors.purple.shade400),
        _buildLineBarData(bpSpots, Colors.green.shade400),
        _buildLineBarData(bmiSpots, Colors.blue.shade400),
        _buildLineBarData(weightSpots, Colors.orange.shade400),
      ],
      lineTouchData: LineTouchData( // Tooltip saat disentuh
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => Colors.blueGrey.withOpacity(0.8),
          tooltipRoundedRadius: 8,
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((barSpot) {
              final flSpot = barSpot;
              String yValueText = flSpot.y.toStringAsFixed(1);
              // Jika BMI, kembalikan ke nilai asli sebelum dikalikan
              if (barSpot.barIndex == 2) { // Asumsi BMI adalah line ke-3 (index 2)
                 yValueText = (flSpot.y / 5).toStringAsFixed(1); // Bagi dengan faktor skala
              }
              return LineTooltipItem(
                '${yValueText}\n',
                GoogleFonts.poppins(color: flSpot.bar.gradient?.colors.first ?? flSpot.bar.color ?? Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                children: [
                  TextSpan(
                    text: data[flSpot.x.toInt()].predictionTimestamp.day.toString() + "/" + data[flSpot.x.toInt()].predictionTimestamp.month.toString(),
                    style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
    );
  }

  LineChartBarData _buildLineBarData(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots.isEmpty ? [const FlSpot(0,0)] : spots, // Handle jika spots kosong
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false), // Sembunyikan titik default
      belowBarData: BarAreaData(show: true, color: color.withOpacity(0.1)),
    );
  }
}

// Card deskripsi di bawah grafik
class _DescriptionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CardContainer( // Menggunakan CardContainer
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, size: 22, color: Colors.blue.shade700),
              const SizedBox(width: 10),
              Text(
                'Keterangan Grafik',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Grafik ini menunjukkan tren parameter kesehatan Anda. Gunakan data ini sebagai referensi dan selalu konsultasikan dengan dokter untuk diagnosis dan penanganan medis yang akurat.',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700], height: 1.5),
          ),
        ],
      ),
    );
  }
}