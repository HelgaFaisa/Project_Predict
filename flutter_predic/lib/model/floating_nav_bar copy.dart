import 'package:flutter/material.dart';

// Widget Floating Bottom Navigation Bar
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

  // Helper method to build individual navigation items
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
            // Tampilkan label hanya jika item terpilih
            if (isSelected)
              const SizedBox(height: 4), // Jarak antara ikon dan label
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

// Custom Painter untuk menggambar bentuk FloatingNavBar
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

    // Menggambar bentuk dasar rounded rectangle
    final Rect rect = Rect.fromLTRB(0, 0, size.width, size.height);
    final RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(30));
    canvas.drawRRect(rRect, paint);

    // Menggambar gradient di bawah item yang terpilih
    final double itemWidth = size.width / itemCount;
    final double xPos = itemWidth * selectedIndex;
    final Rect selectedRect = Rect.fromLTRB(xPos, 0, xPos + itemWidth, size.height);

    final Gradient gradient = LinearGradient(
      colors: gradientColors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    // Menggunakan shader gradient untuk menggambar ulang bagian yang terpilih
    paint.shader = gradient.createShader(selectedRect);
    canvas.drawRRect(RRect.fromRectAndRadius(selectedRect, Radius.circular(30)), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // Mengembalikan true jika ada perubahan yang memerlukan repaint
    // Dalam kasus ini, karena selectedIndex bisa berubah, kita kembalikan true
    return true; // Diubah dari false menjadi true agar repaint saat selectedIndex berubah
  }
}
