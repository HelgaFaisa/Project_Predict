import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/gejala.dart';

class DiagnosisPage extends StatefulWidget {
  const DiagnosisPage({super.key});

  @override
  State<DiagnosisPage> createState() => _DiagnosisPageState();
}

class _DiagnosisPageState extends State<DiagnosisPage> {
  // Data gejala
  List<Gejala> listGejala = [];
  bool isLoading = true;
  double totalSkor = 0.0;
  String hasilDiagnosa = "";

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  
  // Data Pribadi & Fisik
  final TextEditingController _usiaController = TextEditingController();
  String _jenisKelamin = 'Laki-laki';
  final TextEditingController _beratBadanController = TextEditingController();
  final TextEditingController _tinggiBadanController = TextEditingController();
  double _bmi = 0.0;
  
  // Riwayat Medis
  bool _riwayatKeluargaDiabetes = false;
  bool _riwayatHipertensi = false;
  bool _riwayatKolesterol = false;
  bool _riwayatDiabetesGestasional = false;
  
  // Gaya Hidup
  String _aktivitasFisik = 'Tidak Aktif';
  bool _kebiasaanMerokok = false;
  String _polaMakan = 'Normal';
  bool _konsumsiAlkohol = false;
  
  // Data Medis/Lab
  final TextEditingController _gulaDarahPuasaController = TextEditingController();
  final TextEditingController _gulaDarahSewaktuController = TextEditingController();
  final TextEditingController _hba1cController = TextEditingController();
  final TextEditingController _tekananDarahSistolController = TextEditingController();
  final TextEditingController _tekananDarahDiastolController = TextEditingController();
  final TextEditingController _kolesterolTotalController = TextEditingController();
  final TextEditingController _hdlController = TextEditingController();
  final TextEditingController _ldlController = TextEditingController();

  // Controllers untuk tab
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final List<String> _tabTitles = [
    'Data Pribadi & Fisik',
    'Riwayat Medis',
    'Gaya Hidup',
    'Gejala Klinis',
    'Data Medis/Lab'
  ];

  @override
  void initState() {
    super.initState();
    fetchGejala();

    // Listener untuk menghitung BMI otomatis
    _beratBadanController.addListener(_hitungBMI);
    _tinggiBadanController.addListener(_hitungBMI);
  }

  @override
  void dispose() {
    // Dispose semua controllers
    _usiaController.dispose();
    _beratBadanController.dispose();
    _tinggiBadanController.dispose();
    _gulaDarahPuasaController.dispose();
    _gulaDarahSewaktuController.dispose();
    _hba1cController.dispose();
    _tekananDarahSistolController.dispose();
    _tekananDarahDiastolController.dispose();
    _kolesterolTotalController.dispose();
    _hdlController.dispose();
    _ldlController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _hitungBMI() {
    if (_beratBadanController.text.isNotEmpty && _tinggiBadanController.text.isNotEmpty) {
      try {
        double berat = double.parse(_beratBadanController.text);
        double tinggi = double.parse(_tinggiBadanController.text) / 100; // konversi ke meter
        setState(() {
          _bmi = berat / (tinggi * tinggi);
        });
      } catch (e) {
        setState(() {
          _bmi = 0.0;
        });
      }
    } else {
      setState(() {
        _bmi = 0.0;
      });
    }
  }

  Future<void> fetchGejala() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/gejala'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          listGejala = data.map((e) => Gejala.fromJson(e)).toList();
          isLoading = false;
        });
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
    if (!_formKey.currentState!.validate()) {
      // Tampilkan snackbar untuk memberitahu pengguna
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi data yang diperlukan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validasi wanita saja yang bisa pilih riwayat diabetes gestasional
    if (_jenisKelamin != 'Perempuan' && _riwayatDiabetesGestasional) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Diabetes gestasional hanya berlaku untuk perempuan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Hitung skor dari gejala
    totalSkor = 0.0;
    List<int> idGejalaDipilih = [];

    for (var gejala in listGejala) {
      if (gejala.selected) {
        totalSkor += gejala.nilai;
        idGejalaDipilih.add(gejala.id);
      }
    }

    // Hitung skor tambahan dari faktor risiko lain
    // Usia > 45 tahun
    if (_usiaController.text.isNotEmpty && int.parse(_usiaController.text) > 45) {
      totalSkor += 0.05;
    }

    // BMI
    if (_bmi > 25) {
      totalSkor += 0.05;
    }

    // Riwayat keluarga
    if (_riwayatKeluargaDiabetes) {
      totalSkor += 0.10;
    }

    // Hipertensi
    if (_riwayatHipertensi) {
      totalSkor += 0.05;
    }

    // Kolesterol tinggi
    if (_riwayatKolesterol) {
      totalSkor += 0.05;
    }

    // Diabetes gestasional
    if (_riwayatDiabetesGestasional) {
      totalSkor += 0.10;
    }

    // Aktivitas fisik
    if (_aktivitasFisik == 'Tidak Aktif') {
      totalSkor += 0.05;
    }

    // Merokok
    if (_kebiasaanMerokok) {
      totalSkor += 0.05;
    }

    // Pola makan tinggi gula/karbohidrat
    if (_polaMakan == 'Tinggi Gula/Karbohidrat') {
      totalSkor += 0.05;
    }

    // Konsumsi alkohol
    if (_konsumsiAlkohol) {
      totalSkor += 0.03;
    }

    // Cek data lab jika dimasukkan
    if (_gulaDarahPuasaController.text.isNotEmpty) {
      double gdp = double.parse(_gulaDarahPuasaController.text);
      if (gdp >= 126) {
        totalSkor += 0.20;
      } else if (gdp >= 100) {
        totalSkor += 0.10;
      }
    }

    if (_gulaDarahSewaktuController.text.isNotEmpty) {
      double gds = double.parse(_gulaDarahSewaktuController.text);
      if (gds >= 200) {
        totalSkor += 0.20;
      } else if (gds >= 140) {
        totalSkor += 0.10;
      }
    }

    if (_hba1cController.text.isNotEmpty) {
      double hba1c = double.parse(_hba1cController.text);
      if (hba1c >= 6.5) {
        totalSkor += 0.20;
      } else if (hba1c >= 5.7) {
        totalSkor += 0.10;
      }
    }

    // Normalisasi skor ke nilai 0-1
    totalSkor = totalSkor > 1.0 ? 1.0 : totalSkor;

    // Tentukan hasil diagnosa
    if (totalSkor >= 0.6) {
      hasilDiagnosa = "Risiko Tinggi Diabetes";
    } else if (totalSkor >= 0.4) {
      hasilDiagnosa = "Risiko Sedang Diabetes";
    } else {
      hasilDiagnosa = "Risiko Rendah Diabetes";
    }

    setState(() {});

    // Kirim ke backend
    await kirimHasilDiagnosa(idGejalaDipilih, totalSkor, hasilDiagnosa);
  }

  Future<void> kirimHasilDiagnosa(List<int> idGejala, double skor, String hasil) async {
    try {
      // Siapkan data untuk dikirim ke backend
      Map<String, dynamic> data = {
        'gejala': idGejala,
        'skor': skor,
        'hasil': hasil,
        'pasien_id': 1, // contoh, biasanya diambil dari user login
        'data_pribadi': {
          'usia': _usiaController.text.isEmpty ? null : int.parse(_usiaController.text),
          'jenis_kelamin': _jenisKelamin,
          'berat_badan': _beratBadanController.text.isEmpty ? null : double.parse(_beratBadanController.text),
          'tinggi_badan': _tinggiBadanController.text.isEmpty ? null : double.parse(_tinggiBadanController.text),
          'bmi': _bmi,
        },
        'riwayat_medis': {
          'riwayat_keluarga_diabetes': _riwayatKeluargaDiabetes,
          'riwayat_hipertensi': _riwayatHipertensi,
          'riwayat_kolesterol': _riwayatKolesterol,
          'riwayat_diabetes_gestasional': _riwayatDiabetesGestasional,
        },
        'gaya_hidup': {
          'aktivitas_fisik': _aktivitasFisik,
          'merokok': _kebiasaanMerokok,
          'pola_makan': _polaMakan,
          'konsumsi_alkohol': _konsumsiAlkohol,
        },
        'data_lab': {
          'gula_darah_puasa': _gulaDarahPuasaController.text.isEmpty ? null : double.parse(_gulaDarahPuasaController.text),
          'gula_darah_sewaktu': _gulaDarahSewaktuController.text.isEmpty ? null : double.parse(_gulaDarahSewaktuController.text),
          'hba1c': _hba1cController.text.isEmpty ? null : double.parse(_hba1cController.text),
          'tekanan_darah_sistol': _tekananDarahSistolController.text.isEmpty ? null : int.parse(_tekananDarahSistolController.text),
          'tekanan_darah_diastol': _tekananDarahDiastolController.text.isEmpty ? null : int.parse(_tekananDarahDiastolController.text),
          'kolesterol_total': _kolesterolTotalController.text.isEmpty ? null : double.parse(_kolesterolTotalController.text),
          'hdl': _hdlController.text.isEmpty ? null : double.parse(_hdlController.text),
          'ldl': _ldlController.text.isEmpty ? null : double.parse(_ldlController.text),
        }
      };
      
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/hasil-diagnosis'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Hasil diagnosis berhasil dikirim');
        
        // Tampilkan snackbar sukses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hasil diagnosis berhasil disimpan'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print('Gagal kirim hasil diagnosis: Status ${response.statusCode}');
        
        // Tampilkan snackbar error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan hasil: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error kirim diagnosis: $e');
      
      // Tampilkan snackbar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Navigasi antar tab
  void _nextPage() {
    if (_currentIndex < _tabTitles.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _prevPage() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _jumpToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 13, 69, 115),
              const Color.fromARGB(255, 102, 176, 250),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Diagnosis Mandiri Diabetes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: const Offset(1, 1),
                        blurRadius: 3.0,
                        color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
              ),
              // Tab indicators
              Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: List.generate(
                    _tabTitles.length,
                    (index) => Expanded(
                      child: GestureDetector(
                        onTap: () => _jumpToPage(index),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _currentIndex == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              _tabTitles[index],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: _currentIndex == index
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: _currentIndex == index
                                    ? Colors.blue.shade700
                                    : Colors.blue.shade900,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        )
                      : Form(
                          key: _formKey,
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                            children: [
                              // Page 1: Data Pribadi & Fisik
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionTitle('Data Pribadi & Fisik'),
                                    _buildTextField(
                                      label: 'Usia (tahun)',
                                      controller: _usiaController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Usia wajib diisi';
                                        }
                                        return null;
                                      },
                                    ),
                                    _buildDropdown(
                                      label: 'Jenis Kelamin',
                                      value: _jenisKelamin,
                                      items: const ['Laki-laki', 'Perempuan'],
                                      onChanged: (value) {
                                        setState(() {
                                          _jenisKelamin = value!;
                                          // Reset diabetes gestasional jika laki-laki
                                          if (value == 'Laki-laki') {
                                            _riwayatDiabetesGestasional = false;
                                          }
                                        });
                                      },
                                    ),
                                    _buildTextField(
                                      label: 'Berat Badan (kg)',
                                      controller: _beratBadanController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Berat badan wajib diisi';
                                        }
                                        return null;
                                      },
                                    ),
                                    _buildTextField(
                                      label: 'Tinggi Badan (cm)',
                                      controller: _tinggiBadanController,
                                      keyboardType: TextInputType.number,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Tinggi badan wajib diisi';
                                        }
                                        return null;
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.blue.shade200),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'BMI (Indeks Massa Tubuh):',
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              _bmi.toStringAsFixed(2),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: _bmi > 25
                                                    ? Colors.red
                                                    : Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (_bmi > 0)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Text(
                                          _getBmiCategory(),
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: _bmi > 25
                                                ? Colors.red.shade700
                                                : _bmi < 18.5
                                                    ? Colors.orange
                                                    : Colors.green.shade700,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 16),
                                    _buildNavigationButtons(),
                                  ],
                                ),
                              ),
                              
                              // Page 2: Riwayat Medis
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionTitle('Riwayat Medis'),
                                    _buildCheckbox(
                                      label: 'Riwayat keluarga dengan diabetes',
                                      value: _riwayatKeluargaDiabetes,
                                      onChanged: (value) {
                                        setState(() {
                                          _riwayatKeluargaDiabetes = value!;
                                        });
                                      },
                                    ),
                                    _buildCheckbox(
                                      label: 'Pernah didiagnosis hipertensi',
                                      value: _riwayatHipertensi,
                                      onChanged: (value) {
                                        setState(() {
                                          _riwayatHipertensi = value!;
                                        });
                                      },
                                    ),
                                    _buildCheckbox(
                                      label: 'Pernah didiagnosis kolesterol tinggi',
                                      value: _riwayatKolesterol,
                                      onChanged: (value) {
                                        setState(() {
                                          _riwayatKolesterol = value!;
                                        });
                                      },
                                    ),
                                    if (_jenisKelamin == 'Perempuan')
                                      _buildCheckbox(
                                        label: 'Riwayat kehamilan dengan diabetes gestasional',
                                        value: _riwayatDiabetesGestasional,
                                        onChanged: (value) {
                                          setState(() {
                                            _riwayatDiabetesGestasional = value!;
                                          });
                                        },
                                      ),
                                    const SizedBox(height: 16),
                                    _buildNavigationButtons(),
                                  ],
                                ),
                              ),
                              
                              // Page 3: Gaya Hidup
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionTitle('Gaya Hidup'),
                                    _buildDropdown(
                                      label: 'Aktivitas Fisik',
                                      value: _aktivitasFisik,
                                      items: const ['Aktif', 'Cukup Aktif', 'Tidak Aktif'],
                                      onChanged: (value) {
                                        setState(() {
                                          _aktivitasFisik = value!;
                                        });
                                      },
                                    ),
                                    _buildCheckbox(
                                      label: 'Kebiasaan merokok',
                                      value: _kebiasaanMerokok,
                                      onChanged: (value) {
                                        setState(() {
                                          _kebiasaanMerokok = value!;
                                        });
                                      },
                                    ),
                                    _buildDropdown(
                                      label: 'Pola Makan',
                                      value: _polaMakan,
                                      items: const [
                                        'Normal',
                                        'Tinggi Gula/Karbohidrat',
                                        'Diet Rendah Gula',
                                        'Diet Vegetarian'
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          _polaMakan = value!;
                                        });
                                      },
                                    ),
                                    _buildCheckbox(
                                      label: 'Konsumsi alkohol',
                                      value: _konsumsiAlkohol,
                                      onChanged: (value) {
                                        setState(() {
                                          _konsumsiAlkohol = value!;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    _buildNavigationButtons(),
                                  ],
                                ),
                              ),
                              
                              // Page 4: Gejala Klinis
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionTitle('Gejala Klinis'),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: listGejala.length,
                                      itemBuilder: (context, index) {
                                        final gejala = listGejala[index];
                                        return Card(
                                          elevation: 2,
                                          margin: const EdgeInsets.symmetric(vertical: 4),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: CheckboxListTile(
                                            title: Text(
                                              gejala.nama,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            subtitle: Text(
                                              'Nilai: ${gejala.nilai.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontSize: 12,
                                              ),
                                            ),
                                            value: gejala.selected,
                                            activeColor: Colors.blue.shade700,
                                            checkColor: Colors.white,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                gejala.selected = value ?? false;
                                              });
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    _buildNavigationButtons(),
                                  ],
                                ),
                              ),
                              
                              // Page 5: Data Medis/Lab
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildSectionTitle('Data Medis/Lab (Opsional)'),
                                    _buildInfoBox(
                                      'Data medis bersifat opsional tetapi sangat membantu untuk diagnosis yang lebih akurat',
                                      Colors.blue,
                                    ),
                                    
                                    _buildTextField(
                                      label: 'Gula Darah Puasa (mg/dL)',
                                      controller: _gulaDarahPuasaController,
                                      keyboardType: TextInputType.number,
                                      helperText: 'Normal: <100, Prediabetes: 100-125, Diabetes: ≥126',
                                    ),
                                    _buildTextField(
                                      label: 'Gula Darah Sewaktu (mg/dL)',
                                      controller: _gulaDarahSewaktuController,
                                      keyboardType: TextInputType.number,
                                      helperText: 'Normal: <140, Prediabetes: 140-199, Diabetes: ≥200',
                                    ),
                                   _buildTextField(
                                      label: 'HbA1c (%)',
                                      controller: _hba1cController,
                                      keyboardType: TextInputType.number,
                                      helperText: 'Normal: <5.7, Prediabetes: 5.7-6.4, Diabetes: ≥6.5',
                                    ),

                                    _buildTextField(
                                      label: 'Tekanan Darah Sistol (mmHg)',
                                      controller: _tekananDarahSistolController,
                                      keyboardType: TextInputType.number,
                                      helperText: 'Normal: <120, Prehipertensi: 120-139, Hipertensi: ≥140',
                                    ),
                                    _buildTextField(
                                      label: 'Tekanan Darah Diastol (mmHg)',
                                      controller: _tekananDarahDiastolController,
                                      keyboardType: TextInputType.number,
                                      helperText: 'Normal: <80, Prehipertensi: 80-89, Hipertensi: ≥90',
                                    ),
                                    _buildTextField(
                                      label: 'Kolesterol Total (mg/dL)',
                                      controller: _kolesterolTotalController,
                                      keyboardType: TextInputType.number,
                                      helperText: 'Diinginkan: <200, Batas tinggi: 200-239, Tinggi: ≥240',
                                    ),
                                    _buildTextField(
                                      label: 'HDL Kolesterol (mg/dL)',
                                      controller: _hdlController,
                                      keyboardType: TextInputType.number,
                                      helperText: 'Rendah: <40 (pria) atau <50 (wanita), Optimal: ≥60',
                                    ),
                                    _buildTextField(
                                      label: 'LDL Kolesterol (mg/dL)',
                                      controller: _ldlController,
                                      keyboardType: TextInputType.number,
                                      helperText: 'Optimal: <100, Mendekati optimal: 100-129, Batas tinggi: 130-159',
                                    ),
                                    
                                    const SizedBox(height: 20),
                                    
                                    // Tombol diagnosa
                                    Center(
                                      child: ElevatedButton.icon(
                                        onPressed: hitungSkor,
                                        icon: const Icon(Icons.health_and_safety),
                                        label: const Text('Lakukan Diagnosis'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green.shade600,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 20),
                                    
                                    // Hasil diagnosa
                                    if (hasilDiagnosa.isNotEmpty)
                                      _buildHasilDiagnosa(),
                                    
                                    const SizedBox(height: 16),
                                    _buildNavigationButtons(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _getBmiCategory() {
    if (_bmi < 18.5) {
      return 'Kategori: Berat badan kurang';
    } else if (_bmi >= 18.5 && _bmi < 25) {
      return 'Kategori: Berat badan normal';
    } else if (_bmi >= 25 && _bmi < 30) {
      return 'Kategori: Kelebihan berat badan (Overweight)';
    } else {
      return 'Kategori: Obesitas';
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade800,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    String? helperText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          helperMaxLines: 2,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildCheckbox({
    required String label,
    required bool value,
    required Function(bool?) onChanged,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: CheckboxListTile(
        title: Text(label),
        value: value,
        activeColor: Colors.blue.shade700,
        checkColor: Colors.white,
        onChanged: onChanged,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }

  Widget _buildInfoBox(String message, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.blue.shade800, // bukan hanya color.shade800
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_currentIndex > 0)
          ElevatedButton.icon(
            onPressed: _prevPage,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Sebelumnya'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              foregroundColor: Colors.blue.shade800,
            ),
          )
        else
          const SizedBox(width: 10),
        if (_currentIndex < _tabTitles.length - 1)
          ElevatedButton.icon(
            onPressed: _nextPage,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Selanjutnya'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
            ),
          )
        else
          const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildHasilDiagnosa() {
    Color warnaBg;
    Color warnaText;
    IconData icon;
    String pesanTambahan;

    // Set warna, ikon, dan pesan berdasarkan hasil diagnosa
    if (hasilDiagnosa == "Risiko Tinggi Diabetes") {
      warnaBg = Colors.red.shade100;
      warnaText = Colors.red.shade900;
      icon = Icons.warning;
      pesanTambahan = "Segera konsultasikan dengan dokter untuk pemeriksaan lebih lanjut.";
    } else if (hasilDiagnosa == "Risiko Sedang Diabetes") {
      warnaBg = Colors.orange.shade100;
      warnaText = Colors.orange.shade900;
      icon = Icons.info;
      pesanTambahan = "Disarankan untuk melakukan pemeriksaan kesehatan lebih lanjut.";
    } else {
      warnaBg = Colors.green.shade100;
      warnaText = Colors.green.shade900;
      icon = Icons.check_circle;
      pesanTambahan = "Tetap jaga pola hidup sehat.";
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: warnaBg,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: warnaText,
                size: 36,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hasil Diagnosis:',
                      style: TextStyle(
                        fontSize: 14,
                        color: warnaText.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      hasilDiagnosa,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: warnaText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Skor Risiko: ${(totalSkor * 100).toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: warnaText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            pesanTambahan,
            style: TextStyle(
              fontSize: 14,
              color: warnaText.withOpacity(0.9),
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Catatan: Hasil diagnosis ini tidak menggantikan konsultasi dengan tenaga medis profesional.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade800,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}