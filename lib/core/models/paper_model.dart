class PaperModel {
  final String id;
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
    // Navigate the nested structure returned by the backend
    final examCycle = json['examCycle'] ?? {};
    final post = examCycle['post'] ?? {};
    final department = examCycle['department'] ?? {};
    final examStage = json['examStage'] ?? {};

    String rawPdfUrl = json['pdfUrl'] ?? '';
    // Ensure the PDF URL is absolute so the viewer can find it
    if (rawPdfUrl.isNotEmpty && !rawPdfUrl.startsWith('http')) {
      // Use the same IP/Port as your ApiService
      // Note: We're using 7241 as confirmed by your logs
      rawPdfUrl = 'https://10.0.2.2:7241$rawPdfUrl';
    }

    return PaperModel(
      id: json['id']?.toString() ?? '',
      postName: post['name'] ?? '',
      paperName: json['title'] ?? '',
      department: department['name'] ?? '',
      year: examCycle['examYear']?.toString() ?? '',
      examStage: examStage['name'] ?? '',
      pdfUrl: rawPdfUrl,
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
