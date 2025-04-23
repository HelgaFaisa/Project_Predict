import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void _goTo(BuildContext context, String page) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Navigasi ke halaman $page')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menu Utama')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildMenu(context, Icons.person, 'Profile'),
            _buildMenu(context, Icons.bar_chart, 'Laporan'),
            _buildMenu(context, Icons.settings, 'Pengaturan'),
            _buildMenu(
              context,
              Icons.logout,
              'Logout',
              onTap: () => Navigator.pushReplacementNamed(context, '/'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenu(BuildContext context, IconData icon, String title, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap ?? () => _goTo(context, title),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.blue),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
