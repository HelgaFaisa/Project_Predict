class Pemeriksaan {
  final dynamic id; // Atau mungkin int atau String, tergantung tipe ID di database MongoDB
  final int idPasien;
  final DateTime tanggal;
  final Map<String, dynamic>? gejala; // Asumsi gejala disimpan sebagai map
  final double? skor;
  final String? hasil;
  // Tambahkan field lain sesuai dengan struktur data riwayat Anda

  Pemeriksaan({
    required this.id,
    required this.idPasien,
    required this.tanggal,
    this.gejala,
    this.skor,
    this.hasil,
  });

  factory Pemeriksaan.fromJson(Map<String, dynamic> json) {
    return Pemeriksaan(
      id: json['_id'], // Sesuaikan dengan nama field ID di MongoDB Anda ('_id' adalah umum)
      idPasien: json['id_pasien'] as int,
      tanggal: DateTime.parse(json['tanggal']), // Asumsi format tanggal adalah string ISO 8601
      gejala: json['gejala'] as Map<String, dynamic>?,
      skor: (json['skor'] as num?)?.toDouble(),
      hasil: json['hasil'] as String?,
      // Tambahkan pemetaan untuk field lain di sini
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'id_pasien': idPasien,
      'tanggal': tanggal.toIso8601String(),
      'gejala': gejala,
      'skor': skor,
      'hasil': hasil,
      // Tambahkan pemetaan untuk field lain di sini jika diperlukan untuk mengirim data kembali ke API
    };
  }
}