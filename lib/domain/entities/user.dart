// lib/domain/entities/user.dart
class User {
  final int id;
  final String fullName;

  User({required this.id, required this.fullName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'],
    );
  }
}
