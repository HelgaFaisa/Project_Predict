// // lib/profile/profile_page.dart - VERSI PERBAIKAN

// import 'package:flutter/material.dart';

// class ProfilePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[50],
//       appBar: AppBar(
//         title: Text('Profil Saya'),
//         backgroundColor: Colors.blue[700],
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             // Header Profil
//             Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.blue[700]!, Colors.blue[500]!],
//                 ),
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.white,
//                       child: Icon(
//                         Icons.person,
//                         size: 60,
//                         color: Colors.blue[700],
//                       ),
//                     ),
//                     SizedBox(height: 16),
//                     Text(
//                       'Dr. John Doe', // Ganti dengan nama dinamis
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     Text(
//                       'Dokter Spesialis',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white70,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
            
//             SizedBox(height: 20),
            
//             // Menu Profil
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 children: [
//                   _buildProfileMenuItem(
//                     icon: Icons.person_outline,
//                     title: 'Edit Profil',
//                     subtitle: 'Ubah informasi pribadi',
//                     onTap: () {
//                       // Navigasi ke halaman edit profil
//                       Navigator.pushNamed(context, '/edit-profile');
//                     },
//                   ),
//                   _buildProfileMenuItem(
//                     icon: Icons.lock_outline,
//                     title: 'Ubah Password',
//                     subtitle: 'Ganti kata sandi akun',
//                     onTap: () {
//                       // Navigasi ke halaman ubah password
//                       Navigator.pushNamed(context, '/change-password');
//                     },
//                   ),
//                   _buildProfileMenuItem(
//                     // PERBAIKAN: Ganti dengan icon yang ada
//                     icon: Icons.notifications,
//                     title: 'Notifikasi',
//                     subtitle: 'Atur preferensi notifikasi',
//                     onTap: () {
//                       // Navigasi ke halaman pengaturan notifikasi
//                       _showNotificationSettings(context);
//                     },
//                   ),
//                   _buildProfileMenuItem(
//                     icon: Icons.help_outline,
//                     title: 'Bantuan',
//                     subtitle: 'FAQ dan dukungan',
//                     onTap: () {
//                       // Navigasi ke halaman bantuan
//                       _showHelpDialog(context);
//                     },
//                   ),
//                   _buildProfileMenuItem(
//                     icon: Icons.info_outline,
//                     title: 'Tentang Aplikasi',
//                     subtitle: 'Versi dan informasi aplikasi',
//                     onTap: () {
//                       _showAboutDialog(context);
//                     },
//                   ),
//                   _buildProfileMenuItem(
//                     icon: Icons.logout,
//                     title: 'Keluar',
//                     subtitle: 'Logout dari aplikasi',
//                     onTap: () {
//                       _showLogoutDialog(context);
//                     },
//                     isLogout: true,
//                   ),
//                 ],
//               ),
//             ),
            
//             SizedBox(height: 100), // Space untuk bottom navigation
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileMenuItem({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//     bool isLogout = false,
//   }) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 12),
//       child: Material(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         elevation: 2,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(12),
//           child: Padding(
//             padding: EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: isLogout ? Colors.red[50] : Colors.blue[50],
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Icon(
//                     icon,
//                     color: isLogout ? Colors.red[600] : Colors.blue[600],
//                     size: 24,
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                           color: isLogout ? Colors.red[700] : Colors.black87,
//                         ),
//                       ),
//                       Text(
//                         subtitle,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Icon(
//                   Icons.arrow_forward_ios,
//                   size: 16,
//                   color: Colors.grey[400],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // PERBAIKAN: Tambahkan method untuk notifikasi
//   void _showNotificationSettings(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Pengaturan Notifikasi'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SwitchListTile(
//               title: Text('Notifikasi Pemeriksaan'),
//               subtitle: Text('Pengingat jadwal pemeriksaan'),
//               value: true,
//               onChanged: (value) {
//                 // Handle switch
//               },
//             ),
//             SwitchListTile(
//               title: Text('Notifikasi Obat'),
//               subtitle: Text('Pengingat minum obat'),
//               value: true,
//               onChanged: (value) {
//                 // Handle switch
//               },
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Tutup'),
//           ),
//         ],
//       ),
//     );
//   }

//   // PERBAIKAN: Tambahkan method untuk bantuan
//   void _showHelpDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Bantuan'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('FAQ:', style: TextStyle(fontWeight: FontWeight.bold)),
//             SizedBox(height: 8),
//             Text('• Bagaimana cara menggunakan aplikasi?'),
//             Text('• Cara mengecek gula darah?'),
//             Text('• Cara mengatur target harian?'),
//             SizedBox(height: 16),
//             Text('Kontak Support:', style: TextStyle(fontWeight: FontWeight.bold)),
//             Text('Email: support@diabetacare.com'),
//             Text('Telepon: 021-1234-5678'),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Tutup'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showAboutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Tentang DiabetaCare'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Versi: 1.0.0'),
//             SizedBox(height: 8),
//             Text('DiabetaCare adalah aplikasi untuk membantu monitoring kesehatan diabetes.'),
//             SizedBox(height: 8),
//             Text('Dikembangkan dengan ❤️ untuk kesehatan yang lebih baik.'),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Tutup'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Konfirmasi Logout'),
//         content: Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Batal'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context); // Tutup dialog
//               Navigator.pushNamedAndRemoveUntil(
//                 context,
//                 '/login',
//                 (route) => false,
//               );
//             },
//             child: Text('Keluar', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
// }