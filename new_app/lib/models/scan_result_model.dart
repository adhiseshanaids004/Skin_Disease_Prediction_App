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
}
