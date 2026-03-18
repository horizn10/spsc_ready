class PostModel {
  final int id;
  final String name;
  final int paperCount;
  final int departmentId;

  PostModel({
    required this.id,
    required this.name,
    required this.paperCount,
    required this.departmentId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      paperCount: json['paperCount'] ?? 0,
      departmentId: json['departmentId'] ?? 0,
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
