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
    // Try primary path: examCycle -> post -> department
    final examCycle = json['examCycle'] ?? {};
    final post = examCycle['post'] ?? {};
    
    // Try multiple possible locations for department
    final deptObj = examCycle['department'] ?? post['department'] ?? json['department'] ?? {};
    final stageObj = json['examStage'] ?? {};

    String rawPdfUrl = json['pdfUrl'] ?? '';
    if (rawPdfUrl.isNotEmpty && !rawPdfUrl.startsWith('http')) {
      rawPdfUrl = 'https://10.0.2.2:7241$rawPdfUrl';
    }

    return PaperModel(
      id: json['id']?.toString() ?? '',
      postName: post['name'] ?? json['postName'] ?? '',
      paperName: json['title'] ?? json['paperName'] ?? '',
      department: deptObj['name'] ?? '',
      year: examCycle['examYear']?.toString() ?? '',
      examStage: stageObj['name'] ?? '',
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
