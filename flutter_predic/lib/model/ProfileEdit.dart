import 'package:flutter/material.dart';

// Widget untuk Halaman Profil Pengguna
// Halaman ini akan ditampilkan saat pengguna menekan ikon profil di ProfileHeader.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Scaffold memberikan struktur dasar halaman, seperti AppBar dan body.
    return Scaffold(
      // AppBar di bagian atas halaman
      appBar: AppBar(
        title: const Text('Profil Pengguna'), // Judul halaman di AppBar
        backgroundColor: Colors.blue.shade700, // Warna latar belakang AppBar, disesuaikan dengan header
        foregroundColor: Colors.white, // Warna teks dan ikon di AppBar
        // Tombol kembali (back button) akan otomatis muncul karena menggunakan pushNamed
      ),
      // Body adalah area utama konten halaman
      body: Padding(
        padding: const EdgeInsets.all(24.0), // Memberikan padding di sekeliling konten
        child: Center( // Memusatkan konten Column di tengah layar
          child: SingleChildScrollView( // Memungkinkan konten untuk discroll jika melebihi tinggi layar
            child: Column(
              // Menata elemen-elemen di dalam Column secara vertikal
              mainAxisAlignment: MainAxisAlignment.center, // Pusatkan item secara vertikal (jika tidak perlu discroll)
              crossAxisAlignment: CrossAxisAlignment.center, // Pusatkan item secara horizontal
              children: <Widget>[
                // Bagian Foto Profil (Avatar yang lebih besar dari di header)
                Container(
                   decoration: BoxDecoration(
                    shape: BoxShape.circle, // Bentuk lingkaran
                    boxShadow: [ // Efek bayangan untuk avatar
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                   ),
                   child: CircleAvatar(
                      radius: 60, // Ukuran avatar lebih besar
                      backgroundColor: Colors.blue.shade100, // Warna latar belakang avatar
                      child: Icon(
                         Icons.person, // Ikon orang
                         size: 80, // Ukuran ikon di dalam avatar
                         color: Colors.blue.shade900, // Warna ikon
                      ),
                      // Jika Anda memiliki gambar profil pengguna (dari internet atau lokal),
                      // Anda bisa mengganti 'child' dengan:
                      // backgroundImage: NetworkImage('URL_GAMBAR_PROFIL'),
                      // atau
                      // backgroundImage: AssetImage('path/to/your/image.png'),
                   ),
                ),

                const SizedBox(height: 24), // Jarak vertikal antara avatar dan nama

                // Bagian Nama Pengguna
                const Text(
                  'Nama Pengguna Lengkap', // Ganti dengan data nama pengguna sebenarnya
                  style: TextStyle(
                    fontSize: 28, // Ukuran font
                    fontWeight: FontWeight.bold, // Ketebalan font
                    color: Colors.blueGrey, // Warna teks
                  ),
                ),

                const SizedBox(height: 8), // Jarak vertikal antara nama dan email

                // Bagian Email atau Informasi Kontak Lain
                const Text(
                  'email.pengguna@example.com', // Ganti dengan data email pengguna sebenarnya
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueGrey,
                  ),
                ),

                const SizedBox(height: 30), // Jarak vertikal yang lebih besar sebelum tombol

                // Tombol untuk Aksi Utama (misalnya Edit Profil)
                ElevatedButton(
                  onPressed: () {
                    // TODO: Tambahkan logika untuk navigasi ke halaman edit profil atau menampilkan dialog edit
                    // Contoh sederhana: Menampilkan SnackBar saat tombol ditekan
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tombol Edit Profil Ditekan')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15), // Padding tombol
                    backgroundColor: Colors.blue, // Warna latar tombol
                    foregroundColor: Colors.white, // Warna teks tombol
                    shape: RoundedRectangleBorder( // Bentuk tombol dengan sudut membulat
                       borderRadius: BorderRadius.circular(30),
                    ),
                     elevation: 5, // Ketinggian bayangan tombol
                  ),
                  child: const Text(
                     'Edit Profil', // Teks tombol
                     style: TextStyle(fontSize: 18), // Gaya teks tombol
                  ),
                ),

                 const SizedBox(height: 16), // Jarak vertikal antara tombol edit dan tombol keluar

                 // Tombol untuk Aksi Sekunder (misalnya Keluar/Logout)
                TextButton(
                  onPressed: () {
                    // TODO: Tambahkan logika untuk proses keluar (logout)
                    // Ini biasanya melibatkan menghapus token autentikasi dan navigasi ke halaman login.
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tombol Keluar Ditekan')),
                    );
                    // Contoh navigasi setelah logout (mengganti semua halaman di stack dengan halaman login):
                    // Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: TextButton.styleFrom(
                     foregroundColor: Colors.redAccent, // Warna teks tombol keluar
                  ),
                  child: const Text(
                    'Keluar', // Teks tombol
                    style: TextStyle(fontSize: 16), // Gaya teks tombol
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
