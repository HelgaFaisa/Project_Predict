import 'package:flutter/material.dart';
import 'riwayatpemeriksaan/riwayat.dart';
import 'edukasi/edukasi.dart';
import 'target/targethidup.dart';
import 'gejala_page.dart';
import '/model/gejala.dart';


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
        scaffoldBackgroundColor: Colors.blue[50], // Setting default scaffold background
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins',
      ),
      home: const HomePage(),
      routes: {
        '/profile': (context) => const Center(child: Text('Profile Page')),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// Home Page
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
    RiwayatScreen(pasienId: 1), // Ganti 1 dengan fungsi untuk mendapatkan ID pengguna saat ini
    EdukasiPage(),
    const TargetHidupSehatPage(),
    DiagnosisPage(),
  ];


  @override
 Widget build(BuildContext context) {
  return Scaffold(
    // Use a Container with decoration instead of backgroundColor
    backgroundColor: Colors.transparent, // Make Scaffold transparent
    body: Container(
      // Apply the gradient as decoration
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue[300]!, Colors.blue[50]!],
        ),
      ),
      child: Column(
        children: [
          if (selectedIndex == 0) const ProfileHeader(),
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

// Floating Bottom Navigation Bar
class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _page = 0;

  final List<IconData> _icons = [
    Icons.add,
    Icons.list,
    Icons.contact_mail,
    Icons.call,
    Icons.perm_identity,
  ];

  final List<String> _labels = [
    'Add',
    'List',
    'Mail',
    'Call',
    'Profile',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _page = index;
      print('Selected page: $_page');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Custom Floating Nav Bar')),
      body: Container(
        color: Colors.blue[50], // Changed to light blue
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_page == 0) Icon(Icons.add, size: 130, color: Colors.blue[700]),
              if (_page == 1) Icon(Icons.list, size: 130, color: Colors.blue[800]),
              if (_page == 2) Icon(Icons.contact_mail, size: 130, color: Colors.blue[700]),
              if (_page == 3) Icon(Icons.call, size: 130, color: Colors.blue[800]),
              if (_page == 4) Icon(Icons.perm_identity, size: 130, color: Colors.blue[700]),
              Text(_page.toString(), textScaleFactor: 5),
              ElevatedButton(
                child: Text('Go To Page of index 0'),
                onPressed: () {
                  setState(() {
                    _page = 0;
                  });
                },
              )
            ],
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: FloatingNavBar(
        selectedIndex: _page,
        onItemTapped: _onItemTapped,
        icons: _icons,
        labels: _labels,
      ),
    );
  }
}

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
            if (isSelected)
              const SizedBox(height: 20),
            if (isSelected)
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? activeColor : inactiveColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
    return false;
  }
}

// Profile Header
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 24, right: 24, bottom: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade700,
            Colors.blue.shade900,
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
        border: Border.all(color: Colors.blue.shade300, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Halo Naufal!',
                style: TextStyle(
                  fontSize: 22,
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
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.blue.shade900, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Health Graph Page
class HealthGraphPage extends StatelessWidget {
  const HealthGraphPage({Key? key}) : super(key: key);

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
          _GraphCard(),
          const SizedBox(height: 20),
          _DescriptionCard(),
          const SizedBox(height: 100), // Untuk jarak dengan floating navbar
        ],
      ),
    );
  }
}

class _GraphCard extends StatelessWidget {
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
                  'Bulanan',
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
            ],
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 200, child: EnhancedLineChart()),
        ],
      ),
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
            'Grafik ini menunjukkan tingkat glukosa dan tekanan darah Anda selama periode pengukuran terakhir. Tren menunjukkan fluktuasi yang perlu diperhatikan.',
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

// Enhanced Line Chart
class EnhancedLineChart extends StatelessWidget {
  const EnhancedLineChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: EnhancedLineChartPainter(),
    );
  }
}

class EnhancedLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Grid paint
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..strokeWidth = 1;

    // Axis labels paint
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    // Draw grid
    for (int i = 0; i <= 5; i++) {
      final y = height * i / 5;
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
      
      // Draw Y-axis labels
      textPainter.text = TextSpan(
        text: '${100 - (i * 20)}',
        style: TextStyle(color: Colors.grey[600], fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-25, y - textPainter.height / 2));
    }
    
    for (int i = 0; i <= 8; i++) {
      final x = width * i / 8;
      canvas.drawLine(Offset(x, 0), Offset(x, height), gridPaint);
      
      // Draw X-axis labels
      final month = _getMonthName(i);
      textPainter.text = TextSpan(
        text: month,
        style: TextStyle(color: Colors.grey[600], fontSize: 10),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, height + 5));
    }

    // Draw lines and points for each dataset
    _drawDataset(canvas, size, Colors.purple.shade400);
    _drawDataset(canvas, size, Colors.blue.shade400, offset: 0.15);
    _drawDataset(canvas, size, Colors.green.shade400, offset: -0.1);
  }
  
  void _drawDataset(Canvas canvas, Size size, Color color, {double offset = 0}) {
    final width = size.width;
    final height = size.height;
    
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    final shadowPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.fill;
      
    // Generate slightly different data points for each dataset
    final points = [
      Offset(width * 0 / 8, height * (0.7 + offset)),
      Offset(width * 1 / 8, height * (0.5 + offset)),
      Offset(width * 2 / 8, height * (0.6 + offset)),
      Offset(width * 3 / 8, height * (0.4 + offset)),
      Offset(width * 4 / 8, height * (0.5 + offset)),
      Offset(width * 5 / 8, height * (0.35 + offset)),
      Offset(width * 6 / 8, height * (0.4 + offset)),
      Offset(width * 7 / 8, height * (0.2 + offset)),
      Offset(width * 8 / 8, height * (0.3 + offset)),
    ];

    // Draw line
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      final p0 = points[i - 1];
      final p1 = points[i];
      
      // Create smooth curve
      final controlPoint1 = Offset(
        p0.dx + (p1.dx - p0.dx) / 2,
        p0.dy,
      );
      final controlPoint2 = Offset(
        p0.dx + (p1.dx - p0.dx) / 2,
        p1.dy,
      );
      
      path.cubicTo(
        controlPoint1.dx, controlPoint1.dy,
        controlPoint2.dx, controlPoint2.dy,
        p1.dx, p1.dy,
      );
    }
    
    // Draw shadow
    final shadowPath = Path()..addPath(path, Offset.zero);
    shadowPath.lineTo(width, height);
    shadowPath.lineTo(0, height);
    shadowPath.close();
    canvas.drawPath(shadowPath, shadowPaint);
    
    // Draw line
    canvas.drawPath(path, paint);
    
    // Draw points
    for (var point in points) {
      canvas.drawCircle(point, 4, pointPaint);
      canvas.drawCircle(point, 2, Paint()..color = Colors.white);
    }
  }
  
  String _getMonthName(int index) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agt', 'Sep'];
    return index < months.length ? months[index] : '';
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}