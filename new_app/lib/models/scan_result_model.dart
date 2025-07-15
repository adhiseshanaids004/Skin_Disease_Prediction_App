import 'package:cloud_firestore/cloud_firestore.dart';

class ScanResult {
  final String disease;
  final String stage;
  final String description;
  final String remedy;
  final String precautions;
  final DateTime date;

  ScanResult({
    required this.disease,
    required this.stage,
    required this.description,
    required this.remedy,
    required this.precautions,
    required this.date,
  });

  // Create a ScanResult from a Map (for Firestore)
  factory ScanResult.fromMap(Map<String, dynamic> map) {
    return ScanResult(
      disease: map['disease'] as String,
      stage: map['stage'] as String,
      description: map['description'] as String,
      remedy: map['remedy'] as String,
      precautions: map['precautions'] as String,
      date: map['date'] is Timestamp ? map['date'].toDate() : DateTime.parse(map['date']),
    );
  }
}
