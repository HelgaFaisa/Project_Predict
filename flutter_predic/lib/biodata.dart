import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BiodataFormPage extends StatefulWidget {
  @override
  _BiodataFormPageState createState() => _BiodataFormPageState();
}

class _BiodataFormPageState extends State<BiodataFormPage> {
  final formKey = GlobalKey<FormState>();
  
  // Controller untuk form fields
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  
  // Dropdown values
  String? selectedGender;
  String? selectedBloodType;
  DateTime? selectedBirthDate;
  
  final List<String> genders = ['Laki-laki', 'Perempuan'];
  final List<String> bloodTypes = ['A', 'B', 'AB', 'O'];

  // Format tanggal
  final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
  
  // Untuk menampilkan date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedBirthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF1976D2),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != selectedBirthDate) {
      setState(() {
        selectedBirthDate = picked;
      });
    }
  }

  // Method untuk memproses form
  void _submitBiodata() {
    if (formKey.currentState!.validate()) {
      // Di sini Anda bisa menyimpan data biodata ke database atau shared preferences
      
      // Tampilkan dialog sukses
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Berhasil', style: TextStyle(color: Colors.green)),
          content: Text('Data biodata berhasil disimpan!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
                Navigator.pushReplacementNamed(context, '/home'); // Navigasi ke homepage
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lengkapi Biodata'),
        backgroundColor: Color(0xFF1976D2),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1976D2),
              Color(0xFF42A5F5),
              Color(0xFF90CAF9),
            ],
          ),
        ),
        child: SafeArea(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Isi Data Diri Anda',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 3),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Form Biodata
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 10),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Nama Lengkap
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'Nama Lengkap',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15),
                          
                          // Tanggal Lahir
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: AbsorbPointer(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Tanggal Lahir',
                                  prefixIcon: Icon(Icons.calendar_today),
                                  suffixIcon: Icon(Icons.arrow_drop_down),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                controller: TextEditingController(
                                  text: selectedBirthDate != null 
                                      ? dateFormat.format(selectedBirthDate!)
                                      : '',
                                ),
                                validator: (value) {
                                  if (selectedBirthDate == null) {
                                    return 'Pilih tanggal lahir';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          
                          // Jenis Kelamin
                          DropdownButtonFormField<String>(
                            value: selectedGender,
                            decoration: InputDecoration(
                              labelText: 'Jenis Kelamin',
                              prefixIcon: Icon(Icons.people),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            items: genders.map((gender) {
                              return DropdownMenuItem(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Pilih jenis kelamin';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15),
                          
                          // Umur
                          TextFormField(
                            controller: ageController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Umur',
                              prefixIcon: Icon(Icons.cake),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Umur tidak boleh kosong';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Umur harus berupa angka';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15),
                          
                          // Golongan Darah
                          DropdownButtonFormField<String>(
                            value: selectedBloodType,
                            decoration: InputDecoration(
                              labelText: 'Golongan Darah',
                              prefixIcon: Icon(Icons.bloodtype),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            items: bloodTypes.map((bloodType) {
                              return DropdownMenuItem(
                                value: bloodType,
                                child: Text(bloodType),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedBloodType = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Pilih golongan darah';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15),
                          
                          // Berat Badan
                          TextFormField(
                            controller: weightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Berat Badan (kg)',
                              prefixIcon: Icon(Icons.monitor_weight),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Berat badan tidak boleh kosong';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Berat badan harus berupa angka';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15),
                          
                          // Tinggi Badan
                          TextFormField(
                            controller: heightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Tinggi Badan (cm)',
                              prefixIcon: Icon(Icons.height),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tinggi badan tidak boleh kosong';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Tinggi badan harus berupa angka';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15),
                          
                          // Nomor Telepon
                          TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Nomor Telepon',
                              prefixIcon: Icon(Icons.phone),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nomor telepon tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15),
                          
                          // Alamat
                          TextFormField(
                            controller: addressController,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: 'Alamat',
                              prefixIcon: Icon(Icons.home),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Alamat tidak boleh kosong';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 25),
                          
                          // Tombol Submit
                          Container(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _submitBiodata,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                'Simpan',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}