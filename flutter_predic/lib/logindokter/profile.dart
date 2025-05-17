// import 'package:flutter/material.dart';
// import '../api/profile_api.dart';
// import '../riwayatpemeriksaan/riwayat.dart';

// class ProfilePage extends StatefulWidget {
//   final String idPasien;
//   final String token;
  
//   const ProfilePage({required this.idPasien, required this.token});
  
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {
//   Map<String, dynamic>? profileData;
//   bool isLoading = true;
//   String errorMessage = '';
  
//   @override
//   void initState() {
//     super.initState();
//     fetchProfile();
//   }
  
//   Future<void> fetchProfile() async {
//   try {
//     // Tambahkan logging untuk debugging
//     print('Memulai fetch profile untuk ID: ${widget.idPasien}');
//     print('Token digunakan: ${widget.token.substring(0, min(10, widget.token.length))}...');
    
//     // Test endpoint API terlebih dahulu
//     final bool isApiAvailable = await ProfileApi.testEndpoint();
//     if (!isApiAvailable) {
//       print('API endpoint test gagal. Mungkin server tidak aktif atau ada masalah jaringan.');
//     }
    
//     // Perhatikan bahwa ID pasien tidak diperlukan lagi untuk endpoint /patient/profile
//     // karena endpoint tersebut sudah menggunakan token untuk mengidentifikasi pasien
//     final data = await ProfileApi.getProfile(widget.idPasien, widget.token);
    
//     // Verifikasi struktur data yang diterima
//     print('Data profil diterima: $data');
    
//     setState(() {
//       profileData = data;
//       isLoading = false;
//     });
//   } catch (e) {
//     // handling error tetap sama
//   }
// }
//   void logout() {
//     // Konfirmasi logout dengan dialog
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Konfirmasi'),
//         content: Text('Apakah Anda yakin ingin keluar?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Batal'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context); // tutup dialog
//               // Clear any stored credentials and navigate back to login
//               Navigator.pushReplacementNamed(context, '/login');
//             },
//             child: Text('Keluar', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profil Pasien'),
//         backgroundColor: Colors.blue,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.refresh),
//             onPressed: () {
//               setState(() {
//                 isLoading = true;
//                 errorMessage = '';
//               });
//               fetchProfile();
//             },
//             tooltip: 'Refresh',
//           ),
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: logout,
//             tooltip: 'Logout',
//           ),
//         ],
//       ),
//       body: isLoading 
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 16),
//                   Text('Memuat data profil...'),
//                 ],
//               ),
//             )
//           : errorMessage.isNotEmpty 
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.error_outline, color: Colors.red, size: 60),
//                       SizedBox(height: 16),
//                       Text(
//                         'Terjadi Kesalahan',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 8),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                         child: Text(
//                           errorMessage,
//                           textAlign: TextAlign.center,
//                           style: TextStyle(color: Colors.red),
//                         ),
//                       ),
//                       SizedBox(height: 24),
//                       ElevatedButton.icon(
//                         icon: Icon(Icons.refresh),
//                         label: Text('Coba Lagi'),
//                         onPressed: () {
//                           setState(() {
//                             isLoading = true;
//                             errorMessage = '';
//                           });
//                           fetchProfile();
//                         },
//                       ),
//                       SizedBox(height: 12),
//                       // Tambah tombol untuk kembali ke login
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pushReplacementNamed(context, '/login');
//                         },
//                         child: Text('Kembali ke Login'),
//                       ),
//                     ],
//                   ),
//                 )
//               : profileData == null 
//                   ? Center(child: Text('Data tidak ditemukan'))
//                   : Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Info ID Pasien untuk debugging
//                           Padding(
//                             padding: const EdgeInsets.only(bottom: 16.0),
//                             child: Card(
//                               color: Colors.blue.shade50,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.info_outline, color: Colors.blue),
//                                     SizedBox(width: 8),
//                                     Expanded(
//                                       child: Text(
//                                         'ID Pasien: ${widget.idPasien}',
//                                         style: TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.blue.shade800,
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
                          
//                           Center(
//                             child: CircleAvatar(
//                               radius: 50,
//                               backgroundColor: Colors.blue.shade100,
//                               child: Icon(
//                                 Icons.person,
//                                 size: 50,
//                                 color: Colors.blue,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 24),
//                           ProfileInfoCard(
//                             title: 'Informasi Pasien',
//                             items: [
//                               ProfileItem(title: 'Nama', value: profileData!['name'] ?? 'N/A'),
//                               ProfileItem(title: 'Email', value: profileData!['email'] ?? 'N/A'),
//                               ProfileItem(title: 'No. Telepon', value: profileData!['phone_number'] ?? 'N/A'),
//                               ProfileItem(title: 'Status', value: profileData!['status'] ?? 'N/A'),
//                             ],
//                           ),
//                           SizedBox(height: 24),
//                           Center(
//                             child: ElevatedButton.icon(
//                               icon: Icon(Icons.history),
//                               label: Text('Lihat Riwayat Pemeriksaan'),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.blue,
//                                 foregroundColor: Colors.white,
//                                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                               ),
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => RiwayatPage(idPasien: widget.idPasien, token: widget.token),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//     );
//   }
// }

// // Helper function untuk min
// int min(int a, int b) {
//   return a < b ? a : b;
// }

// class ProfileInfoCard extends StatelessWidget {
//   final String title;
//   final List<ProfileItem> items;
  
//   const ProfileInfoCard({
//     required this.title,
//     required this.items,
//   });
  
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue.shade800,
//               ),
//             ),
//             Divider(height: 24),
//             ...items.map((item) => Padding(
//               padding: const EdgeInsets.only(bottom: 12.0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     width: 100,
//                     child: Text(
//                       '${item.title}:',
//                       style: TextStyle(
//                         color: Colors.grey.shade700,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Text(
//                       item.value,
//                       style: TextStyle(
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )).toList(),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ProfileItem {
//   final String title;
//   final String value;
  
//   ProfileItem({required this.title, required this.value});
// }