class PaperModel {
  final int id;
  final String postName;
  final String paperName;
  final String department;
  final String year;
  final String examStage;
  final String pdfUrl;

  PaperModel({
    required this.id,
    required this.postName,
    required this.paperName,
    required this.department,
    required this.year,
    required this.examStage,
    required this.pdfUrl,
  });

  factory PaperModel.fromJson(Map<String, dynamic> json) {
    return PaperModel(
      id: json['id'] ?? 0,
      postName: json['postName'] ?? '',
      paperName: json['paperName'] ?? '',
      department: json['department'] ?? '',
      year: json['year']?.toString() ?? '',
      examStage: json['examStage'] ?? '',
      pdfUrl: json['pdfUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postName': postName,
      'paperName': paperName,
      'department': department,
      'year': year,
      'examStage': examStage,
      'pdfUrl': pdfUrl,
    };
  }
}
