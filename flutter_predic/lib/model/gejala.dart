// File: gejala_model.dart
// Model untuk data Gejala yang diterima dari API

class Gejala {
  final String id;
  final String kode;
  final String nama;
  final double mb;
  final double md;
  final bool aktif;
  final String? pertanyaan;

  Gejala({
    required this.id,
    required this.kode,
    required this.nama,
    required this.mb,
    required this.md,
    this.aktif = true,
     this.pertanyaan,
  });

  // Konversi dari JSON ke objek Gejala
  factory Gejala.fromJson(Map<String, dynamic> json) {
    return Gejala(
      // MongoDB mengembalikan _id yang perlu ditangani secara khusus
      id: json['_id'] is Map ? json['_id']['\$oid'] : json['_id']?.toString() ?? '',
      kode: json['kode'] ?? '',
      nama: json['nama'] ?? '',
      mb: json['mb'] != null ? double.parse(json['mb'].toString()) : 0.0,
      md: json['md'] != null ? double.parse(json['md'].toString()) : 0.0,
      aktif: json['aktif'] ?? true,
    );
  }

  // Konversi dari objek Gejala ke JSON
  Map<String, dynamic> toJson() {
    return {
      'kode': kode,
      'nama': nama,
      'mb': mb,
      'md': md,
      'aktif': aktif,
    };
  }

  // Method untuk membuat salinan objek dengan beberapa properti yang diubah
  Gejala copyWith({
    String? id,
    String? kode,
    String? nama,
    double? mb,
    double? md,
    bool? aktif,
  }) {
    return Gejala(
      id: id ?? this.id,
      kode: kode ?? this.kode,
      nama: nama ?? this.nama,
      mb: mb ?? this.mb,
      md: md ?? this.md,
      aktif: aktif ?? this.aktif,
    );
  }

  @override
  String toString() {
    return 'Gejala{id: $id, kode: $kode, nama: $nama, mb: $mb, md: $md, aktif: $aktif}';
  }
}