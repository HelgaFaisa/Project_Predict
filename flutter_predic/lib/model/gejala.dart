class Gejala {
  final int id;
  final String nama;
  final double nilai;
  bool selected;
  
  Gejala({
    required this.id,
    required this.nama,
    required this.nilai,
    this.selected = false,
  });
  
  factory Gejala.fromJson(Map<String, dynamic> json) {
    // Konversi String _id menjadi int jika memungkinkan
    int idValue = 0;
    if (json['_id'] != null) {
      // Mengambil 6 karakter terakhir dari _id dan konversi ke int
      // Atau cara alternatif lainnya untuk menghasilkan ID unik
      String idStr = json['_id'] as String;
      idValue = idStr.hashCode;
    }
    
    return Gejala(
      id: idValue,
      nama: json['name'] ?? '(Tidak ada nama)',  // Gunakan 'name' bukan 'nama'
      nilai: json['weight'] != null ? (json['weight'] as num).toDouble() : 0.0,  // Gunakan 'weight' bukan 'nilai'
      selected: false,
    );
  }
}