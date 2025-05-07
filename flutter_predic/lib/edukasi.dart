import 'package:flutter/material.dart';
import '../api/edukasi_api.dart';

class EdukasiPage extends StatefulWidget {
  @override
  _EdukasiPageState createState() => _EdukasiPageState();
}

class _EdukasiPageState extends State<EdukasiPage> {
  List<dynamic> edukasiList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadEdukasi();
  }

  Future<void> loadEdukasi() async {
    try {
      final data = await EdukasiApi.getAllArticles();
      setState(() {
        edukasiList = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Artikel Edukasi')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: edukasiList.length,
              itemBuilder: (context, index) {
                final item = edukasiList[index];
                // Pastikan field 'title' dan 'content' digunakan
                final judul = item['title'] ?? 'No Title'; // Default to 'No Title' if null
                final konten = item['content'] ?? 'No content available'; // Default content

                return ListTile(
                  title: Text(judul),
                  subtitle: Text(konten),
                );
              },
            ),
    );
  }
}
