import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const DiabetesApp());
}

class DiabetesApp extends StatelessWidget {
  const DiabetesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diabetes Chingu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const RiwayatPemeriksaanPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RiwayatPemeriksaanPage extends StatefulWidget {
  const RiwayatPemeriksaanPage({Key? key}) : super(key: key);

  @override
  _RiwayatPemeriksaanPageState createState() => _RiwayatPemeriksaanPageState();
}

class _RiwayatPemeriksaanPageState extends State<RiwayatPemeriksaanPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  
  // Dummy data for doctor examinations
  final List<DoctorExamination> _doctorExaminations = [];
  
  // Dummy data for self predictions
  final List<SelfPrediction> _selfPredictions = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  // Simulate loading data from an API or local storage
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Sample doctor examination data
    if (_doctorExaminations.isEmpty) {
      _doctorExaminations.addAll([
        DoctorExamination(
          date: DateTime.now().subtract(const Duration(days: 30)),
          pregnancies: 0,
          glucose: 85,
          bloodPressure: '120/80',
          bmi: 22.5,
          age: 45,
          result: 'Negatif',
        ),
        DoctorExamination(
          date: DateTime.now().subtract(const Duration(days: 60)),
          pregnancies: 0,
          glucose: 95,
          bloodPressure: '130/85',
          bmi: 23.1,
          age: 45,
          result: 'Negatif',
        ),
      ]);
    }
    
    // Sample self prediction data
    if (_selfPredictions.isEmpty) {
      _selfPredictions.addAll([
        SelfPrediction(
          date: DateTime.now().subtract(const Duration(days: 15)),
          pregnancies: 0,
          glucose: 100,
          bloodPressure: '135/90',
          bmi: 24.2,
          age: 45,
          result: 'Risiko Rendah',
        ),
        SelfPrediction(
          date: DateTime.now().subtract(const Duration(days: 5)),
          pregnancies: 0,
          glucose: 110,
          bloodPressure: '140/95',
          bmi: 24.5,
          age: 45,
          result: 'Risiko Sedang',
        ),
      ]);
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
 Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Riwayat Pemeriksaan'),
      backgroundColor: Colors.blue[700],
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          // Handle back button press
        },
      ),
    ),
    body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue[300]!, Colors.blue[50]!],
        ),
      ),
      child: Column(
        children: [
          Container(
            color: Colors.blue[600],
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(text: 'Pemeriksaan Dokter'),
                Tab(text: 'Prediksi Mandiri'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Doctor Examination Tab
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _doctorExaminations.isEmpty
                        ? _buildEmptyState('Belum ada riwayat pemeriksaan dari dokter. Kunjungi klinik mitra untuk mendapatkan pemeriksaan komprehensif.')
                        : _buildDoctorExaminationList(),

                // Self Prediction Tab
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _selfPredictions.isEmpty
                        ? _buildEmptyState('Belum ada riwayat prediksi mandiri. Gunakan fitur prediksi untuk mendapatkan penilaian awal tentang risiko diabetes Anda.')
                        : _buildSelfPredictionList(),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? Colors.blue[700] : Colors.grey,
        ),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.blue[700] : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: Colors.blue[200],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorExaminationList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _doctorExaminations.length,
      itemBuilder: (context, index) {
        final examination = _doctorExaminations[index];
        Color resultColor = examination.result.toLowerCase().contains('negatif')
            ? Colors.green
            : Colors.red;

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              _showExaminationDetails(examination);
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd MMM yyyy').format(examination.date),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: resultColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: resultColor),
                        ),
                        child: Text(
                          examination.result,
                          style: TextStyle(
                            color: resultColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Glukosa: ${examination.glucose} mg/dL',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tekanan Darah: ${examination.bloodPressure} mmHg',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'BMI: ${examination.bmi.toStringAsFixed(1)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        icon: Icon(
                          Icons.share,
                          size: 16,
                          color: Colors.blue[700],
                        ),
                        label: Text(
                          'Bagikan',
                          style: TextStyle(color: Colors.blue[700]),
                        ),
                        onPressed: () {
                          // Handle share
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelfPredictionList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _selfPredictions.length,
      itemBuilder: (context, index) {
        final prediction = _selfPredictions[index];
        Color resultColor;
        
        if (prediction.result.toLowerCase().contains('rendah')) {
          resultColor = Colors.green;
        } else if (prediction.result.toLowerCase().contains('sedang')) {
          resultColor = Colors.orange;
        } else {
          resultColor = Colors.red;
        }

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              _showPredictionDetails(prediction);
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('dd MMM yyyy, HH:mm').format(prediction.date),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: resultColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: resultColor),
                        ),
                        child: Text(
                          prediction.result,
                          style: TextStyle(
                            color: resultColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Glukosa: ${prediction.glucose} mg/dL',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tekanan Darah: ${prediction.bloodPressure} mmHg',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'BMI: ${prediction.bmi.toStringAsFixed(1)}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        icon: Icon(
                          Icons.delete_outline,
                          size: 16,
                          color: Colors.red[400],
                        ),
                        label: Text(
                          'Hapus',
                          style: TextStyle(color: Colors.red[400]),
                        ),
                        onPressed: () {
                          // Handle delete
                          _confirmDelete(prediction);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showExaminationDetails(DoctorExamination examination) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detail Pemeriksaan Dokter',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              _buildDetailItem('Tanggal', DateFormat('dd MMMM yyyy').format(examination.date)),
              _buildDetailItem('Kehamilan', examination.pregnancies.toString()),
              _buildDetailItem('Glukosa', '${examination.glucose} mg/dL'),
              _buildDetailItem('Tekanan Darah', '${examination.bloodPressure} mmHg'),
              _buildDetailItem('BMI', examination.bmi.toStringAsFixed(1)),
              _buildDetailItem('Usia', '${examination.age} tahun'),
              _buildDetailItem('Hasil', examination.result, isResult: true, result: examination.result),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Handle share functionality
                    Navigator.pop(context);
                  },
                  child: const Text('Bagikan Hasil'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPredictionDetails(SelfPrediction prediction) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detail Prediksi Mandiri',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              _buildDetailItem('Tanggal & Waktu', DateFormat('dd MMMM yyyy, HH:mm').format(prediction.date)),
              _buildDetailItem('Kehamilan', prediction.pregnancies.toString()),
              _buildDetailItem('Glukosa', '${prediction.glucose} mg/dL'),
              _buildDetailItem('Tekanan Darah', '${prediction.bloodPressure} mmHg'),
              _buildDetailItem('BMI', prediction.bmi.toStringAsFixed(1)),
              _buildDetailItem('Usia', '${prediction.age} tahun'),
              _buildDetailItem('Hasil Prediksi', prediction.result, isResult: true, result: prediction.result),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue[700],
                        side: BorderSide(color: Colors.blue[700]!),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _confirmDelete(prediction);
                      },
                      child: const Text('Hapus Data'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        // Handle consultation functionality
                        Navigator.pop(context);
                      },
                      child: const Text('Konsultasi'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value, {bool isResult = false, String result = ''}) {
    Color? valueColor;
    
    if (isResult) {
      if (result.toLowerCase().contains('negatif') || result.toLowerCase().contains('rendah')) {
        valueColor = Colors.green;
      } else if (result.toLowerCase().contains('sedang')) {
        valueColor = Colors.orange;
      } else {
        valueColor = Colors.red;
      }
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isResult ? FontWeight.bold : FontWeight.normal,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(SelfPrediction prediction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Data'),
        content: const Text('Apakah Anda yakin ingin menghapus data prediksi ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _selfPredictions.remove(prediction);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data prediksi berhasil dihapus'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

// Data models
class DoctorExamination {
  final DateTime date;
  final int pregnancies;
  final int glucose;
  final String bloodPressure;
  final double bmi;
  final int age;
  final String result;

  DoctorExamination({
    required this.date,
    required this.pregnancies,
    required this.glucose,
    required this.bloodPressure,
    required this.bmi,
    required this.age,
    required this.result,
  });
}

class SelfPrediction {
  final DateTime date;
  final int pregnancies;
  final int glucose;
  final String bloodPressure;
  final double bmi;
  final int age;
  final String result;

  SelfPrediction({
    required this.date,
    required this.pregnancies,
    required this.glucose,
    required this.bloodPressure,
    required this.bmi,
    required this.age,
    required this.result,
  });
}