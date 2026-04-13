class PostModel {
  final String id; // Changed from int to String
  final String name;
  final int paperCount;
  final String departmentId; // Changed from int to String

  PostModel({
    required this.id,
    required this.name,
    required this.paperCount,
    required this.departmentId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id']?.toString() ?? '', // Safe string conversion
      name: json['name'] ?? '',
      paperCount: json['paperCount'] ?? 0,
      departmentId: json['departmentId']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'paperCount': paperCount,
      'departmentId': departmentId,
    };
  }
}
