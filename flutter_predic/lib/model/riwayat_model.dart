class PrediksiRiwayat {
  final String? id;  // Ubah dari int? menjadi String?
  final String? patientId;  // Ubah dari int? menjadi String?
  final String? symptoms;
  final String? predictionResult;
  final int? pregnancies;
  final int? glucose;
  final int? bloodPressure;
  final int? height;
  final int? weight;
  final double? bmi;
  final int? age;
  final String? result;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? predictionTimestamp;

  PrediksiRiwayat({
    this.id,
    this.patientId,
    this.symptoms,
    this.predictionResult,
    this.pregnancies,
    this.glucose,
    this.bloodPressure,
    this.height,
    this.weight,
    this.bmi,
    this.age,
    this.result,
    this.createdAt,
    this.updatedAt,
    this.predictionTimestamp,
  });

  factory PrediksiRiwayat.fromJson(Map<String, dynamic> json) {
    return PrediksiRiwayat(
      id: json['id']?.toString(),  // Langsung konversi ke String
      patientId: json['patient_id']?.toString(),  // Langsung konversi ke String
      symptoms: json['symptoms'],
      predictionResult: json['prediction_result'],
      pregnancies: json['pregnancies'] is int ? json['pregnancies'] : (json['pregnancies'] != null ? int.tryParse(json['pregnancies'].toString()) : null),
      glucose: json['glucose'] is int ? json['glucose'] : (json['glucose'] != null ? int.tryParse(json['glucose'].toString()) : null),
      bloodPressure: json['blood_pressure'] is int ? json['blood_pressure'] : (json['blood_pressure'] != null ? int.tryParse(json['blood_pressure'].toString()) : null),
      height: json['height'] is int ? json['height'] : (json['height'] != null ? int.tryParse(json['height'].toString()) : null),
      weight: json['weight'] is int ? json['weight'] : (json['weight'] != null ? int.tryParse(json['weight'].toString()) : null),
      bmi: json['bmi'] is double ? json['bmi'] : (json['bmi'] != null ? double.tryParse(json['bmi'].toString()) : null),
      age: json['age'] is int ? json['age'] : (json['age'] != null ? int.tryParse(json['age'].toString()) : null),
      result: json['result']?.toString(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
      predictionTimestamp: json['prediction_timestamp'] != null ? DateTime.parse(json['prediction_timestamp']) : null,
    );
  }
}