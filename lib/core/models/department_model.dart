class DepartmentModel {
  final String id;
  final String name;
  final int postCount; // Changed from paperCount to postCount for clarity
  final String iconCode;

  DepartmentModel({
    required this.id,
    required this.name,
    required this.postCount,
    required this.iconCode,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      // Backend should ideally return a 'postCount' or we use whatever count is sent as postCount
      postCount: json['postCount'] ?? json['paperCount'] ?? 0, 
      iconCode: json['iconCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'postCount': postCount,
      'iconCode': iconCode,
    };
  }
}
