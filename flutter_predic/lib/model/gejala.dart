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
    return Gejala(
      id: json['id'],
      nama: json['nama'],
      nilai: double.parse(json['nilai'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'nilai': nilai,
      'selected': selected,
    };
  }
}