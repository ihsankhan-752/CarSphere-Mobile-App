class UserModel {
  final String? userId;
  final String username;
  final String email;
  final String role;
  final String phone;
  final String city;
  final String? token;

  UserModel({
    this.userId,
    required this.username,
    required this.email,
    required this.role,
    required this.phone,
    required this.city,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId']?.toString() ?? json['id']?.toString(),
      username: json['username'] ?? 'User',
      email: json['email'] ?? '',
      role: json['role'] ?? 'buyer',
      phone: json['phone'] ?? '',
      city: json['city'] ?? '',
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'role': role,
      'phone': phone,
      'city': city,
    };
  }
}
