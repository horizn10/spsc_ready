class DepartmentModel {
  final int id;
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
      id: json['id'] ?? 0,
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
