class UserModel {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String email;
  final String accountStatus;

  UserModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.accountStatus,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? json['Id']?.toString() ?? '',
      fullName: json['fullName'] ?? json['FullName'] ?? 'N/A',
      phoneNumber: json['phoneNumber'] ?? json['PhoneNumber'] ?? 'N/A',
      email: json['email'] ?? json['Email'] ?? 'N/A',
      accountStatus: json['accountStatus'] ?? json['AccountStatus'] ?? 'Active Member',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'accountStatus': accountStatus,
    };
  }
}
