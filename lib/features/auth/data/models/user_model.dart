import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String studentId;
  final String email;
  final String role;
  final String fullName;

  const UserModel({
    required this.id,
    required this.studentId,
    required this.email,
    required this.role,
    required this.fullName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      studentId: json['student_id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      fullName: json['full_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'email': email,
      'role': role,
      'full_name': fullName,
    };
  }

  @override
  List<Object?> get props => [id, studentId, email, role, fullName];
}