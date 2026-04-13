class DepartmentModel {
  final String id; // Changed from int to String
  final String name;
  final int paperCount;
  final String iconCode;

  DepartmentModel({
    required this.id,
    required this.name,
    required this.paperCount,
    required this.iconCode,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id']?.toString() ?? '', // Convert to string safely
      name: json['name'] ?? '',
      paperCount: json['paperCount'] ?? 0,
      iconCode: json['iconCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'paperCount': paperCount,
      'iconCode': iconCode,
    };
  }
}
