import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// Sesuaikan path import ini dengan struktur proyek Anda
import '../model/gejala.dart'; 
import '../api/gejala_api.dart';   
import '../home_page.dart'; // Untuk CardContainer (asumsi ada di home_page.dart atau diimport olehnya)   

enum JawabanGejala { ya, tidak, belum }

class GejalaJawaban {
  final Gejala gejala;
  JawabanGejala jawaban;
  GejalaJawaban({required this.gejala, this.jawaban = JawabanGejala.belum});
}

class GejalaPage extends StatefulWidget {
  // Jika GejalaPage membutuhkan userName (misalnya untuk EnhancedProfileHeader), 
  // tambahkan di sini dan di constructor. Saat ini saya buat tanpa userName.
  // final String userName;
  // const GejalaPage({Key? key, required this.userName}) : super(key: key);
  const GejalaPage({Key? key}) : super(key: key);

  @override
  _GejalaPageState createState() => _GejalaPageState();
}

class _GejalaPageState extends State<GejalaPage> with TickerProviderStateMixin {
  final GejalaApi _gejalaApi = GejalaApi();
  List<GejalaJawaban> _gejalaJawabanList = [];
  bool _isLoading = true;
  String _errorMessage = '';

  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  Timer? _autoRefreshTimer;
  final int _autoUpdateInterval = 5; // dalam menit

  double _totalNilaiGejala = 0;
  String _saran = '';
  String _hasilPerhitungan = '';

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
    _slideController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _loadData();
    _autoRefreshTimer = Timer.periodic(Duration(minutes: _autoUpdateInterval), (_) => _refreshData(showLoading: false));
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _autoRefreshTimer?.cancel();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _loadData({bool showLoadingAnimation = true}) async {
    if (showLoadingAnimation) {
      if(mounted) setState(() => _isLoading = true);
    }
    if(mounted) _errorMessage = ''; 

    try {
      final gejalaList = await _gejalaApi.getAllGejala();
      if (!mounted) return;
      setState(() {
        _gejalaJawabanList = gejalaList.map((gejala) => GejalaJawaban(gejala: gejala)).toList();
        _isLoading = false;
      });
      _fadeController.forward(from: 0.0); // Reset dan jalankan animasi
      _slideController.forward(from: 0.0);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Gagal memuat data: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshData({bool showLoading = true}) async {
    if(showLoading && mounted) _refreshController.requestRefresh(); 

    try {
      final gejalaList = await _gejalaApi.refreshGejala(); 
      if (!mounted) return;
      setState(() {
        _gejalaJawabanList = gejalaList.map((gejala) => GejalaJawaban(gejala: gejala)).toList();
        _errorMessage = '';
        _totalNilaiGejala = 0;
        _saran = '';
        _hasilPerhitungan = '';
      });
      if(showLoading && mounted) _refreshController.refreshCompleted();
    } catch (e) {
      if (!mounted) return;
      if(showLoading && mounted) _refreshController.refreshFailed();
      if (mounted) { 
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memperbarui data: $e', style: GoogleFonts.poppins()), backgroundColor: Colors.red)
          );
      }
    }
  }

  void _hitungNilaiGejala() {
    double cfGlobal = 0;
    int answeredCount = _gejalaJawabanList.where((item) => item.jawaban != JawabanGejala.belum).length;

    if (answeredCount < _gejalaJawabanList.length) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Harap jawab semua pertanyaan gejala.', style: GoogleFonts.poppins()), backgroundColor: Colors.orangeAccent),
        );
      }
      return;
    }

    for (var item in _gejalaJawabanList) {
      double cf;
      if (item.jawaban == JawabanGejala.ya) {
        cf = item.gejala.mb - item.gejala.md;
      } else if (item.jawaban == JawabanGejala.tidak) {
        cf = -(item.gejala.md * 0.5); 
      } else { 
        cf = 0; 
      }
      
      if (cfGlobal == 0 && cf != 0) { 
          cfGlobal = cf;
      } else if (cfGlobal != 0 && cf != 0) { 
          if (cfGlobal > 0 && cf > 0) {
              cfGlobal = cfGlobal + cf * (1 - cfGlobal);
          } else if (cfGlobal < 0 && cf < 0) {
              cfGlobal = cfGlobal + cf * (1 + cfGlobal);
          } else {
              cfGlobal = (cfGlobal + cf) / (1 - (cfGlobal.abs() < cf.abs() ? cfGlobal.abs() : cf.abs()) );
          }
      }
    }
    _totalNilaiGejala = cfGlobal.clamp(-1, 1); 
    _hasilPerhitungan = 'Nilai Kepastian (CF): ${(_totalNilaiGejala * 100).toStringAsFixed(1)}%';
    _berikanSaran();
  }

  void _berikanSaran() {
    if (_totalNilaiGejala >= 0.8) {
      _saran = 'Risiko Sangat Tinggi! Segera konsultasikan dengan dokter spesialis.';
    } else if (_totalNilaiGejala >= 0.6) {
      _saran = 'Risiko Tinggi. Dianjurkan untuk berkonsultasi dengan dokter.';
    } else if (_totalNilaiGejala >= 0.3) {
      _saran = 'Risiko Sedang. Pertimbangkan untuk konsultasi dan jaga pola hidup sehat.';
    } else if (_totalNilaiGejala > 0){
      _saran = 'Risiko Rendah. Tetap jaga kesehatan dan pantau gejala secara berkala.';
    } else {
       _saran = 'Tidak ada indikasi risiko berdasarkan gejala yang dipilih. Tetap jaga kesehatan.';
    }
    if(mounted) setState(() {}); 
  }

  Color _getRiskColor() {
    if (_totalNilaiGejala >= 0.8) return Colors.red.shade700;
    if (_totalNilaiGejala >= 0.6) return Colors.red.shade400;
    if (_totalNilaiGejala >= 0.3) return Colors.orange.shade600;
    if (_totalNilaiGejala > 0) return Colors.green.shade600;
    return Colors.blue.shade600; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], 
      appBar: AppBar(
        elevation: 1, 
        backgroundColor: Colors.white, 
        foregroundColor: Colors.blue.shade800, 
        title: Text(
          'Pemeriksaan Gejala',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600, 
            color: Colors.blue.shade800,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: Colors.blue.shade700),
            onPressed: () => _refreshData(showLoading: true),
            tooltip: 'Muat Ulang Data',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column( 
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade600, Colors.blue.shade400], 
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.fact_check_outlined, color: Colors.white, size: 48), 
                const SizedBox(height: 12),
                Text(
                  'Cek Risiko Diabetes',
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Jawab pertanyaan berikut sesuai dengan kondisi yang Anda rasakan saat ini.',
                  style: GoogleFonts.poppins(color: Colors.white.withOpacity(0.9), fontSize: 14, height: 1.4),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          Expanded(child: _buildGejalaList()),
          
          if (_hasilPerhitungan.isNotEmpty || _saran.isNotEmpty)
            SlideTransition( 
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left:16, right:16, bottom: 16, top: 8),
                  child: CardContainer( 
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        if (_hasilPerhitungan.isNotEmpty)
                          _buildResultItem(
                            icon: Icons.analytics_outlined,
                            title: 'Hasil Perhitungan:',
                            value: _hasilPerhitungan,
                            valueColor: _getRiskColor(),
                          ),
                        if (_saran.isNotEmpty) ...[
                           if(_hasilPerhitungan.isNotEmpty) const SizedBox(height: 12),
                           _buildResultItem(
                            icon: Icons.lightbulb_outline_rounded,
                            title: 'Saran:',
                            value: _saran,
                            valueColor: _getRiskColor(),
                            isSaran: true
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16,8,16,16), 
            child: ElevatedButton.icon(
              icon: const Icon(Icons.health_and_safety_outlined, size: 20),
              label: Text('Periksa Gejala', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
              onPressed: _hitungNilaiGejala,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600, 
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), 
                elevation: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem({required IconData icon, required String title, required String value, required Color valueColor, bool isSaran = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blue.shade700, size: 20),
            const SizedBox(width: 8),
            Text(title, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: valueColor,
            fontWeight: FontWeight.w600,
            fontSize: isSaran ? 15 : 16, 
            height: 1.4
          ),
        ),
      ],
    );
  }


  Widget _buildGejalaList() {
    if (_isLoading) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600)),
            const SizedBox(height: 20),
            Text('Memuat data gejala...', style: GoogleFonts.poppins(color: Colors.grey.shade700, fontSize: 14)),
          ],
        ),
      ));
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.error_outline_rounded, size: 50, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text(_errorMessage, style: GoogleFonts.poppins(color: Colors.red.shade700, fontSize: 15), textAlign: TextAlign.center),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh_rounded),
            label: Text('Coba Lagi', style: GoogleFonts.poppins()),
            onPressed: () => _loadData(showLoadingAnimation: true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600, foregroundColor: Colors.white),
          )
        ]),
      ));
    }

    if (_gejalaJawabanList.isEmpty) {
      return Center(child: Text('Tidak ada data gejala.', style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 16)));
    }

    return SmartRefresher(
      controller: _refreshController,
      onRefresh: () => _refreshData(showLoading: true),
      header: WaterDropHeader( 
        waterDropColor: Colors.blue.shade600,
        complete: Icon(Icons.check, color: Colors.blue.shade600),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
        itemCount: _gejalaJawabanList.length,
        itemBuilder: (context, index) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: Tween<Offset>(begin: Offset(0, 0.1 + (index * 0.02)), end: Offset.zero)
                  .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutQuart)),
              child: _buildGejalaCard(_gejalaJawabanList[index], index),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGejalaCard(GejalaJawaban gejalaJawaban, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: CardContainer( 
        padding: const EdgeInsets.all(16), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              gejalaJawaban.gejala.nama,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, 
                fontSize: 16,
                color: Colors.black87, 
              ),
            ),
            // --- PERBAIKAN ERROR ADA DI SINI ---
            if (gejalaJawaban.gejala.pertanyaan != null && gejalaJawaban.gejala.pertanyaan!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6.0, bottom: 4.0), // Tambah padding bawah sedikit
                child: Text(
                  gejalaJawaban.gejala.pertanyaan!, // Akses field yang sudah ada di model
                  style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700, height: 1.4), // Disesuaikan stylenya
                ),
              ),
            // --- AKHIR PERBAIKAN ERROR ---
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildAnswerButton('Ya', Icons.check_circle_outline_rounded, gejalaJawaban.jawaban == JawabanGejala.ya, Colors.green.shade600, () => setState(() => gejalaJawaban.jawaban = JawabanGejala.ya))),
                const SizedBox(width: 10), 
                Expanded(child: _buildAnswerButton('Tidak', Icons.highlight_off_rounded, gejalaJawaban.jawaban == JawabanGejala.tidak, Colors.red.shade500, () => setState(() => gejalaJawaban.jawaban = JawabanGejala.tidak))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerButton(String text, IconData icon, bool isSelected, Color selectedColor, VoidCallback onTap) {
    final color = isSelected ? selectedColor : Colors.grey.shade200; // Warna tombol tidak terpilih lebih soft
    final textColor = isSelected ? Colors.white : Colors.black87;   // Teks hitam untuk tombol tidak terpilih

    return ElevatedButton.icon(
      icon: Icon(icon, size: 18, color: textColor),
      label: Text(text, style: GoogleFonts.poppins(color: textColor, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor, 
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: isSelected ? 2 : 0,
        side: !isSelected ? BorderSide(color: Colors.grey.shade300) : null, // Border tipis untuk tombol tidak terpilih
      ),
    );
  }
}