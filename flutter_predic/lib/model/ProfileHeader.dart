import 'package:flutter/material.dart';

// Widget ProfileHeader yang menampilkan salam dan informasi pengguna
class ProfileHeader extends StatelessWidget {
  // Parameter wajib untuk nama pengguna yang akan ditampilkan
  final String userName;

  // Konstruktor untuk ProfileHeader, memerlukan userName
  const ProfileHeader({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Menggunakan Container untuk latar belakang dengan gradient dan dekorasi
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
      // Menggunakan Row untuk menata elemen secara horizontal
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Menggunakan Column untuk menata teks secara vertikal
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Menampilkan teks sapaan dengan nama pengguna
              Text(
                'Halo $userName!', // Menggunakan userName yang diterima
                style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4), // Jarak vertikal
              // Menampilkan teks tanggal (contoh statis)
              const Text(
                'April, 2025', // Tanggal statis
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          // GestureDetector untuk membuat CircleAvatar bisa diklik
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/profile'), // Navigasi ke halaman profil
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Bentuk lingkaran
                boxShadow: [ // Efek bayangan
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              // Widget CircleAvatar untuk menampilkan ikon profil
              child: CircleAvatar(
                radius: 25, // Ukuran avatar
                backgroundColor: Colors.white, // Warna latar belakang avatar
                child: Icon(Icons.person, color: Colors.blue.shade900, size: 30), // Ikon orang
              ),
            ),
          ),
        ],
      ),
    );
  }
}