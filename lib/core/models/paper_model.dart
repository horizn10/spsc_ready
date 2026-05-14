class PaperModel {
  final String id;
  final String postName;
  final String paperName;
  final String examName;
  final String department;
  final String year;
  final String examStage;
  final String pdfUrl;

  PaperModel({
    required this.id,
    required this.postName,
    required this.paperName,
    required this.examName,
    required this.department,
    required this.year,
    required this.examStage,
    required this.pdfUrl,
  });

  factory PaperModel.fromJson(Map<String, dynamic> json) {
    // 1. Extract Paper Title (e.g. "Paper - I")
    String title = (json['title'] ?? json['Title'] ?? json['paperTitle'] ?? json['PaperTitle'] ?? '').toString().trim();

    // 2. Extract the SINGLE Subject for this card (Flattened logic)
    String subjectStr = "";
    
    // Check for singular SubjectName first (from our flattened backend)
    String? singularSubject = json['subjectName'] ?? json['SubjectName'];
    if (singularSubject != null && singularSubject.toString().isNotEmpty) {
      subjectStr = singularSubject.toString().trim();
    } else {
      // Fallback: take first item from list if singular is missing
      var subData = json['subjectNames'] ?? json['SubjectNames'] ?? json['subjects'] ?? json['Subjects'];
      if (subData is List && subData.isNotEmpty) {
        var first = subData.first;
        subjectStr = (first is String ? first : (first['name'] ?? first['Name'] ?? '')).toString().trim();
      }
    }

    // 2.1 Final Paper Name (Subject Only - Req 2)
    String finalPaperName = subjectStr.isNotEmpty ? subjectStr : "General Paper";

    // 3. Extract Exam Name (Using Title column - Req 3)
    String examName = title.isNotEmpty ? title : (json['examName'] ?? json['ExamName'] ?? 'SPSC Examination').toString().trim();

    // 4. Extract Post Name
    String postName = "";
    var postData = json['postNames'] ?? json['PostNames'];
    if (postData is List && postData.isNotEmpty) {
      postName = postData.first.toString().trim();
    } else {
      postName = (json['postName'] ?? json['PostName'] ?? 'Competitive Post').toString().trim();
    }

    // 5. Extract Department
    String deptName = "";
    var deptData = json['departmentNames'] ?? json['DepartmentNames'];
    if (deptData is List && deptData.isNotEmpty) {
      deptName = deptData.first.toString().trim();
    } else {
      deptName = (json['departmentName'] ?? json['DepartmentName'] ?? 'SPSC').toString().trim();
    }

    // 6. Extract Stage
    String stageName = (json['stageName'] ?? json['StageName'] ?? '').toString().trim();
    if (stageName.isEmpty) {
      var stageData = json['stageNames'] ?? json['StageNames'];
      if (stageData is List && stageData.isNotEmpty) {
        stageName = stageData.first.toString().trim();
      }
    }
    if (stageName.isEmpty) stageName = "General";

    // 7. Extract Year (Strictly from ExamDate column of ExamPapers table)
    String year = 'N/A';
    
    // Prioritize examDate which maps to ExamPapers.ExamDate
    var dateValue = json['examDate'] ?? json['ExamDate'] ?? json['date'] ?? json['Date'];
    
    if (dateValue != null) {
      String dateStr = dateValue.toString();
      // Try to extract a 4-digit year (YYYY) from the date string
      final yearRegex = RegExp(r'\b(19|20)\d{2}\b');
      final match = yearRegex.firstMatch(dateStr);
      if (match != null) {
        year = match.group(0)!;
      } else if (dateStr.length >= 4) {
        // Fallback to first 4 characters if regex fails (e.g. "2023-01-01")
        year = dateStr.substring(0, 4);
      }
    }
    
    // Fallback to backup year fields if ExamDate is unavailable
    if (year == 'N/A' || year == '0') {
      String backupYear = (json['year'] ?? json['Year'] ?? json['examYear'] ?? json['ExamYear'] ?? '').toString().trim();
      if (backupYear.isNotEmpty && backupYear != '0') {
        year = backupYear;
      }
    }

    // PDF URL is fetched on-demand, not from the list response
    const String rawPdfUrl = '';

    return PaperModel(
      id: (json['id'] ?? json['Id'])?.toString() ?? '',
      postName: postName,
      paperName: finalPaperName,
      examName: examName,
      department: deptName,
      year: year,
      examStage: stageName,
      pdfUrl: rawPdfUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postName': postName,
      'paperName': paperName,
      'examName': examName,
      'department': department,
      'year': year,
      'examStage': examStage,
      'pdfUrl': pdfUrl,
    };
  }
}
