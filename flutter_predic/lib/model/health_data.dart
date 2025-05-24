// lib/model/health_data.dart

import 'dart:convert';

List<HealthData> healthDataFromJson(String str) => List<HealthData>.from(json.decode(str).map((x) => HealthData.fromJson(x)));

String healthDataToJson(List<HealthData> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class HealthData {
    String id;
    String patientId;
    String pregnancies;
    String glucose;
    String bloodPressure;
    String height;
    String weight;
    String bmi;
    String age;
    String result;
    DateTime predictionTimestamp;
    DateTime updatedAt;
    DateTime createdAt;

    HealthData({
        required this.id,
        required this.patientId,
        required this.pregnancies,
        required this.glucose,
        required this.bloodPressure,
        required this.height,
        required this.weight,
        required this.bmi,
        required this.age,
        required this.result,
        required this.predictionTimestamp,
        required this.updatedAt,
        required this.createdAt,
    });

    factory HealthData.fromJson(Map<String, dynamic> json) => HealthData(
        // KOREKSI UTAMA UNTUK _id:
        id: json["_id"] is Map<String, dynamic> && json["_id"].containsKey("\$oid")
            ? json["_id"]["\$oid"]?.toString() ?? '' // Jika _id adalah Map dan punya $oid
            : json["_id"]?.toString() ?? '', // Jika _id adalah String langsung atau null
        
        // Tambahkan null-aware operator (?.) dan null coalescing (?? '') ke semua field String
        // untuk menangani kasus di mana field mungkin null atau hilang di JSON
        patientId: json["patient_id"]?.toString() ?? '',
        pregnancies: json["pregnancies"]?.toString() ?? '',
        glucose: json["glucose"]?.toString() ?? '',
        bloodPressure: json["blood_pressure"]?.toString() ?? '',
        height: json["height"]?.toString() ?? '',
        weight: json["weight"]?.toString() ?? '',
        bmi: json["bmi"]?.toString() ?? '',
        age: json["age"]?.toString() ?? '',
        result: json["result"]?.toString() ?? '',
        
        // Gunakan DateTime.tryParse untuk penanganan tanggal yang lebih aman
        // Jika string tanggal null atau tidak valid, akan mengembalikan null, lalu di-default ke DateTime.now()
        predictionTimestamp: DateTime.tryParse(json["prediction_timestamp"]?.toString() ?? '') ?? DateTime.now(),
        updatedAt: DateTime.tryParse(json["updated_at"]?.toString() ?? '') ?? DateTime.now(),
        createdAt: DateTime.tryParse(json["created_at"]?.toString() ?? '') ?? DateTime.now(),
    );

    Map<String, dynamic> toJson() => {
        "_id": id, // Jika Anda ingin mengirim kembali, sesuaikan jika perlu format ObjectId
        "patient_id": patientId,
        "pregnancies": pregnancies,
        "glucose": glucose,
        "blood_pressure": bloodPressure,
        "height": height,
        "weight": weight,
        "bmi": bmi,
        "age": age,
        "result": result,
        "prediction_timestamp": predictionTimestamp.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
    };
}