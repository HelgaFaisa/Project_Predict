// lib/homepage.dart

import 'package:flutter/material.dart';
import 'riwayatpemeriksaan/riwayat.dart';
import 'edukasi/edukasi.dart';
import 'target/targethidup.dart';
import '../gejala/gejala_page.dart';
import '/model/gejala.dart'; 
import 'logindokter/login.dart';
import '../api/riwayat_api.dart';
import 'api/login_api.dart';
import '../edukasi/ArtikelDetailPage.dart';
import '../api/edukasi_api.dart';
import '../api/gejala_api.dart';
import '../model/ProfileHeader.dart';

// Import model dan API untuk data kesehatan
import '../model/health_data.dart';
import '../api/health_data_api.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart

void main() {
  runApp(const MyApp());
}

// Root App
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue[50],
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins',
      ),
      home: LoginPage(),
      routes: {
        '/profile': (context) => const Center(child: Text('Profile Page')),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// Home Page - Sekarang menerima userName dan patientId
class HomePage extends StatefulWidget {
  final String userName;
  final String patientId; // Tambahkan patientId

  const HomePage({Key? key, required this.userName, required this.patientId}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // Daftar halaman, sesuaikan jika ada halaman yang butuh data spesifik
  // Kirimkan patientId ke HealthGraphPage
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HealthGraphPage(patientId: widget.patientId), // Kirim patientId
      RiwayatPage(),
      EdukasiPage(),
      const TargetHidupSehatPage(),
      GejalaPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[300]!, Colors.blue[50]!],
          ),
        ),
        child: Column(
          children: [
            // Pastikan ProfileHeader hanya muncul di halaman utama (index 0)
            if (selectedIndex == 0) ProfileHeader(userName: widget.userName),
            
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween(
                      begin: const Offset(0.0, 0.1),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: _pages[selectedIndex],
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: FloatingNavBar(
        selectedIndex: selectedIndex,
        onItemTapped: _onItemTapped,
        icons: const [
          Icons.bar_chart_rounded,
          Icons.history_rounded,
          Icons.menu_book_rounded,
          Icons.favorite_rounded,
          Icons.medical_services_rounded,
        ],
        labels: const [
          'Grafik',
          'Riwayat',
          'Edukasi',
          'Target',
          'Gejala',
        ],
      ),
    );
  }
}

// Floating Bottom Navigation Bar (tidak ada perubahan)
class FloatingNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final List<IconData> icons;
  final List<String> labels;

  const FloatingNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.icons,
    required this.labels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemWidth = (MediaQuery.of(context).size.width - 40) / icons.length;
    final activeColor = Colors.blue.shade300;
    final inactiveColor = Colors.white;

    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Stack(
        children: [
          // Navigation bar background
          Positioned.fill(
            child: CustomPaint(
              painter: NavBarPainter(
                selectedIndex: selectedIndex,
                itemCount: icons.length,
                baseColor: Colors.blue.shade900,
                gradientColors: [
                  Colors.blue.shade800,
                  Colors.blue.shade900,
                ],
              ),
            ),
          ),
          // Selected item indicator circle
          Positioned(
            top: 0,
            left: itemWidth * selectedIndex + (itemWidth - 50) / 2,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          // Navigation items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              icons.length,
              (index) => _buildNavItem(
                context,
                icons[index],
                labels[index],
                index,
                activeColor,
                inactiveColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
    Color activeColor,
    Color inactiveColor,
  ) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        width: (MediaQuery.of(context).size.width - 40) / icons.length,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                icon,
                color: isSelected ? activeColor : inactiveColor,
                size: isSelected ? 26 : 24,
              ),
            ),
            // Hapus Text jika tidak terpilih, agar tidak overlap
            if (isSelected) const SizedBox(height: 15), // Mengurangi jarak
            if (isSelected)
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? activeColor : inactiveColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            // Jika tidak terpilih, tambahkan sedikit ruang kosong agar tingginya sama
            if (!isSelected) const SizedBox(height: 16), // Sesuaikan jarak agar item tidak terpilih tetap pada posisi yang sama
          ],
        ),
      ),
    );
  }
}

class NavBarPainter extends CustomPainter {
  final int selectedIndex;
  final int itemCount;
  final Color baseColor;
  final List<Color> gradientColors;

  NavBarPainter({
    required this.selectedIndex,
    required this.itemCount,
    required this.baseColor,
    required this.gradientColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.fill;

    final Rect rect = Rect.fromLTRB(0, 0, size.width, size.height);
    final RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(30));

    canvas.drawRRect(rRect, paint);

    // Draw gradient under the selected item
    final double itemWidth = size.width / itemCount;
    final double xPos = itemWidth * selectedIndex;
    final Rect selectedRect = Rect.fromLTRB(xPos, 0, xPos + itemWidth, size.height);

    final Gradient gradient = LinearGradient(
      colors: gradientColors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    paint.shader = gradient.createShader(selectedRect);
    canvas.drawRRect(RRect.fromRectAndRadius(selectedRect, Radius.circular(30)), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false; // Biasanya false jika tidak ada perubahan state dalam painter itu sendiri
  }
}

// Health Graph Page - Sekarang StatefulWidget untuk fetching data
class HealthGraphPage extends StatefulWidget {
  final String patientId; // Menerima patientId

  const HealthGraphPage({Key? key, required this.patientId}) : super(key: key);

  @override
  State<HealthGraphPage> createState() => _HealthGraphPageState();
}

class _HealthGraphPageState extends State<HealthGraphPage> {
  late Future<List<HealthData>> _healthDataFuture;

  @override
  void initState() {
    super.initState();
    _healthDataFuture = HealthDataApi().fetchHealthData(widget.patientId);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grafik Pemeriksaan',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Pantau kesehatan Anda secara berkala',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          // Gunakan FutureBuilder untuk menampilkan data saat sudah siap
          FutureBuilder<List<HealthData>>(
            future: _healthDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Tidak ada data kesehatan tersedia.'));
              } else {
                // Data sudah tersedia, kirim ke _GraphCard
                return _GraphCard(healthData: snapshot.data!);
              }
            },
          ),
          const SizedBox(height: 20),
          _DescriptionCard(),
          const SizedBox(height: 100), // Untuk jarak dengan floating navbar
        ],
      ),
    );
  }
}

class _GraphCard extends StatelessWidget {
  final List<HealthData> healthData; // Menerima data kesehatan

  const _GraphCard({Key? key, required this.healthData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Grafik Parameter Kesehatan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue.shade800
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 141, 202, 246),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Bulanan', // Ini bisa dibuat dinamis (Harian, Mingguan, Bulanan)
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _LegendItem(color: Colors.purple.shade400, label: 'Glukosa'),
              const SizedBox(width: 16),
              _LegendItem(color: Colors.blue.shade400, label: 'BMI'),
              const SizedBox(width: 16),
              _LegendItem(color: Colors.green.shade400, label: 'Tekanan Darah'),
              const SizedBox(width: 16),
              _LegendItem(color: Colors.orange.shade400, label: 'Berat Badan'), // Tambah legend berat badan
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 250, // Tinggikan sedikit agar lebih jelas
            child: LineChart(
              _buildChartData(healthData), // Kirim data ke fungsi builder chart
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membangun data chart dari HealthData
  LineChartData _buildChartData(List<HealthData> data) {
    // Pastikan data diurutkan berdasarkan tanggal
    data.sort((a, b) => a.predictionTimestamp.compareTo(b.predictionTimestamp));

    // Ambil nilai minimum dan maksimum untuk sumbu Y
    double minGlucose = data.map((e) => double.tryParse(e.glucose) ?? 0.0).reduce((a, b) => a < b ? a : b);
    double maxGlucose = data.map((e) => double.tryParse(e.glucose) ?? 0.0).reduce((a, b) => a > b ? a : b);
    
    double minBp = data.map((e) => double.tryParse(e.bloodPressure) ?? 0.0).reduce((a, b) => a < b ? a : b);
    double maxBp = data.map((e) => double.tryParse(e.bloodPressure) ?? 0.0).reduce((a, b) => a > b ? a : b);

    double minBmi = data.map((e) => double.tryParse(e.bmi) ?? 0.0).reduce((a, b) => a < b ? a : b);
    double maxBmi = data.map((e) => double.tryParse(e.bmi) ?? 0.0).reduce((a, b) => a > b ? a : b);

    double minWeight = data.map((e) => double.tryParse(e.weight) ?? 0.0).reduce((a, b) => a < b ? a : b);
    double maxWeight = data.map((e) => double.tryParse(e.weight) ?? 0.0).reduce((a, b) => a > b ? a : b);

    // Tentukan range yang agak luas untuk sumbu Y agar grafik tidak terlalu padat
    double minY = [minGlucose, minBp, minBmi * 5, minWeight].reduce((a, b) => a < b ? a : b) - 10; // Mengurangi sedikit
    double maxY = [maxGlucose, maxBp, maxBmi * 5, maxWeight].reduce((a, b) => a > b ? a : b) + 10; // Menambahkan sedikit
    
    // Normalisasi data untuk fl_chart (biasanya tidak perlu normalisasi jika nilai aktual ditampilkan)
    // fl_chart akan secara otomatis menyesuaikan skala berdasarkan min/max Y axis yang Anda berikan.

    // Ambil timestamp dari data
    final firstTimestamp = data.first.predictionTimestamp.millisecondsSinceEpoch.toDouble();
    final lastTimestamp = data.last.predictionTimestamp.millisecondsSinceEpoch.toDouble();
    final double minX = firstTimestamp;
    final double maxX = lastTimestamp;

    // List of LineBarSpot for each metric
    List<FlSpot> glucoseSpots = data.asMap().entries.map((entry) {
      return FlSpot(entry.value.predictionTimestamp.millisecondsSinceEpoch.toDouble(), double.parse(entry.value.glucose));
    }).toList();

    List<FlSpot> bpSpots = data.asMap().entries.map((entry) {
      return FlSpot(entry.value.predictionTimestamp.millisecondsSinceEpoch.toDouble(), double.parse(entry.value.bloodPressure));
    }).toList();

    List<FlSpot> bmiSpots = data.asMap().entries.map((entry) {
      // Skalakan BMI agar terlihat di grafik yang sama dengan Glukosa/Tekanan Darah
      // Misal, kalikan 5 agar rentang nilainya mirip. Sesuaikan skalanya jika perlu.
      return FlSpot(entry.value.predictionTimestamp.millisecondsSinceEpoch.toDouble(), double.parse(entry.value.bmi) * 5);
    }).toList();

    List<FlSpot> weightSpots = data.asMap().entries.map((entry) {
      // Skalakan berat badan jika perlu, atau biarkan nilai aslinya
      return FlSpot(entry.value.predictionTimestamp.millisecondsSinceEpoch.toDouble(), double.parse(entry.value.weight));
    }).toList();


    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.grey.withOpacity(0.1),
          strokeWidth: 1,
        ),
        getDrawingVerticalLine: (value) => FlLine(
          color: Colors.grey.withOpacity(0.1),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: (maxX - minX) / (data.length > 1 ? data.length - 1 : 1), // Sesuaikan interval
            getTitlesWidget: (value, meta) {
              final DateTime date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
              String formattedDate = '${date.day}/${date.month}'; // Format tanggal
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 8.0,
                child: Text(formattedDate, style: TextStyle(color: Colors.grey[600], fontSize: 10)),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              // Menyesuaikan label Y-axis berdasarkan skala (misal, BMI yang diskalakan)
              String text;
              if (value >= 0 && value <= maxY) {
                // Untuk Glukosa/BP/Weight, tampilkan nilai asli
                text = value.toInt().toString();
                
                // Tambahkan label spesifik untuk BMI jika diskalakan
                // Misalnya, jika BMI diskalakan x5, tampilkan nilai aslinya / 5
           if (value.toInt() % 20 != 0 && value.toInt() % 10 !=0) { // Contoh: hanya tampilkan kelipatan 10/20
                return Container(); // Sembunyikan label yang bukan kelipatan 10/20
            }

              } else {
                return Container(); // Sembunyikan label di luar rentang
              }
              return Text(text, style: TextStyle(color: Colors.grey[600], fontSize: 10));
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
      ),
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: glucoseSpots,
          isCurved: true,
          color: Colors.purple.shade400,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: true, color: Colors.purple.shade400.withOpacity(0.1)),
        ),
        LineChartBarData(
          spots: bpSpots,
          isCurved: true,
          color: Colors.green.shade400,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: true, color: Colors.green.shade400.withOpacity(0.1)),
        ),
        LineChartBarData(
          spots: bmiSpots,
          isCurved: true,
          color: Colors.blue.shade400,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: true, color: Colors.blue.shade400.withOpacity(0.1)),
        ),
        LineChartBarData(
          spots: weightSpots,
          isCurved: true,
          color: Colors.orange.shade400, // Warna baru untuk Berat Badan
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: true, color: Colors.orange.shade400.withOpacity(0.1)),
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    Key? key,
    required this.color,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}

class _DescriptionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 20, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              const Text(
                'Keterangan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Grafik ini menunjukkan tingkat glukosa, BMI, tekanan darah, dan berat badan Anda selama periode pengukuran terakhir. Tren menunjukkan fluktuasi yang perlu diperhatikan.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.tips_and_updates, size: 20, color: Colors.blue.shade600),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Periksa kesehatanmu secara rutin untuk hasil yang lebih akurat',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardContainer extends StatelessWidget {
  final Widget child;

  const _CardContainer({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color.fromARGB(255, 142, 198, 243), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// Removed EnhancedLineChartPainter and EnhancedLineChart
// Replaced with direct use of LineChart from fl_chart library.
// The CustomPainter for chart was too complex and not scalable for real data.
// fl_chart is the industry standard for charting in Flutter.