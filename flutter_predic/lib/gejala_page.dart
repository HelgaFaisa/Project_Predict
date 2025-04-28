import 'package:flutter/material.dart';
import '../model/gejala.dart'; // Import model gejala
import 'package:http/http.dart' as http;
import 'dart:convert';

class GejalaPage extends StatefulWidget {
  const GejalaPage({super.key});

  @override
  State<GejalaPage> createState() => _GejalaPageState();
}

class _GejalaPageState extends State<GejalaPage> {
  List<Gejala> listGejala = [];
  bool isLoading = true;
  double totalSkor = 0.0;
  String hasilDiagnosa = "";

  @override
  void initState() {
    super.initState();
    fetchGejala();
  }

  Future<void> fetchGejala() async {
    try {
      // Sesuaikan URL dengan endpoint API yang benar
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/gejala'));
      if (response.statusCode == 200) {
        print("Data dari API: ${response.body}"); // Log untuk debugging
        List<dynamic> data = json.decode(response.body);
        setState(() {
          listGejala = data.map((e) => Gejala.fromJson(e)).toList();
          isLoading = false;
        });
        
        print("Jumlah gejala dimuat: ${listGejala.length}"); // Log untuk debugging
        // Print beberapa data gejala untuk memastikan parsing berhasil
        if (listGejala.isNotEmpty) {
          print("Contoh gejala pertama: ${listGejala[0].nama}, nilai: ${listGejala[0].nilai}");
        }
      } else {
        throw Exception('Gagal load data: ${response.statusCode}');
      }
    } catch (e) {
      print("Error saat fetch data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void hitungSkor() async {
    totalSkor = 0.0;
    List<int> idGejalaDipilih = [];

    for (var gejala in listGejala) {
      if (gejala.selected) {
        totalSkor += gejala.nilai;
        idGejalaDipilih.add(gejala.id);
      }
    }

    if (totalSkor >= 0.6) {
      hasilDiagnosa = "Risiko Tinggi Diabetes";
    } else {
      hasilDiagnosa = "Risiko Rendah Diabetes";
    }

    setState(() {});

    // Kirim ke backend
    await kirimHasilDiagnosa(idGejalaDipilih, totalSkor, hasilDiagnosa);
  }

  Future<void> kirimHasilDiagnosa(List<int> idGejala, double skor, String hasil) async {
  try {
    // Buat map data yang akan dikirim
    Map<String, dynamic> data = {
      'gejala': idGejala,
      'skor': skor,
      'hasil': hasil,
      'pasien_id': 1, // contoh, biasanya diambil dari user login
    };
    
    // Log data yang akan dikirim untuk debugging
    print('Mengirim data: ${json.encode(data)}');
    
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/hasil-diagnosis'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    // Log lebih detail tentang respons
    print('Status response: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Hasil diagnosis berhasil dikirim');
    } else {
      print('Gagal kirim hasil diagnosis: Status ${response.statusCode} - Body: ${response.body}');
    }
  } catch (e) {
    print('Error kirim diagnosis: $e');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnosis Mandiri'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: listGejala.length,
                    itemBuilder: (context, index) {
                      final gejala = listGejala[index];
                      return CheckboxListTile(
                        title: Text(gejala.nama),
                        subtitle: Text('Nilai: ${gejala.nilai.toStringAsFixed(2)}'),
                        value: gejala.selected,
                        onChanged: (bool? value) {
                          setState(() {
                            gejala.selected = value ?? false;
                          });
                        },
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: hitungSkor,
                  child: const Text('Cek Diagnosis'),
                ),
                const SizedBox(height: 20),
                Text(
                  'Total Skor: ${totalSkor.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Text(
                  hasilDiagnosa,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
    );
  }
}