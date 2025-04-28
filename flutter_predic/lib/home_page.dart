import 'package:flutter/material.dart';
import 'gejala_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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

  final List<Widget> _pages = [
    const HealthGraphPage(),
    Center(child: Text('Riwayat Pemeriksaan', style: TextStyle(fontSize: 18))),
    Center(child: Text('Edukasi', style: TextStyle(fontSize: 18))),
    Center(child: Text('Target Hidup Sehat', style: TextStyle(fontSize: 18))),
    GejalaPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          if (selectedIndex == 0) ProfileHeader(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.blue.shade300, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.bar_chart, 0),
              _buildNavItem(Icons.history, 1),
              _buildNavItem(Icons.list_alt, 2),
              _buildNavItem(Icons.favorite, 3),
              _buildNavItem(Icons.medical_services, 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selectedIndex == index ? Colors.white : Colors.transparent,
        ),
        child: Icon(
          icon,
          color: selectedIndex == index ? Colors.black87 : Colors.white,
          size: 24,
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        border: Border.all(color: Colors.blue.shade300, width: 1.5),
      ),
      padding: const EdgeInsets.only(top: 50, left: 24, right: 24, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Halo Naufal!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'April, 2025',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'),
            child: const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.black87, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}

class HealthGraphPage extends StatelessWidget {
  const HealthGraphPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Grafik Pemeriksaan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(color: Colors.blue.shade100, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Grafik: Glukosa, BMI, Tekanan darah',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: CustomLineChart(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(color: Colors.blue.shade100, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Keterangan:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Grafik ini menunjukkan tingkat glukosa dan tekanan darah Anda selama periode pengukuran terakhir. Tren menunjukkan fluktuasi yang perlu diperhatikan.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.5,
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

class CustomLineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: LineChartPainter(),
    );
  }
}

class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final paint = Paint()
      ..color = Colors.purple.shade400
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1;

    for (int i = 0; i <= 5; i++) {
      double y = height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }
    for (int i = 0; i <= 8; i++) {
      double x = width * i / 8;
      canvas.drawLine(Offset(x, 0), Offset(x, height), gridPaint);
    }

    final points = [
      Offset(width * 0 / 8, height * 0.7),
      Offset(width * 1 / 8, height * 0.5),
      Offset(width * 2 / 8, height * 0.6),
      Offset(width * 3 / 8, height * 0.9),
      Offset(width * 4 / 8, height * 0.8),
      Offset(width * 5 / 8, height * 0.4),
      Offset(width * 6 / 8, height * 0.2),
      Offset(width * 7 / 8, height * 0.6),
      Offset(width * 8 / 8, height * 0.3),
    ];

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(path, paint);

    final pointPaint = Paint()
      ..color = Colors.purple.shade400
      ..style = PaintingStyle.fill;

    for (var point in points) {
      canvas.drawCircle(point, 3, pointPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
