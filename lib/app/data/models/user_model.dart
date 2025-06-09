import 'dart:convert';
import '../enums/role_enum.dart';

class User {
  final String id;
  final String name;
  final Role role;
  final String? email;
  final String? dob;

  User({
    required this.id,
    required this.name,
    required this.role,
    this.email,
    this.dob,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'role': role.toString(),
      'email': email,
      'dob': dob,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      role: Role.fromString(map['role'] ?? 'emp'),
      email: map['email'],
      dob: map['dob'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  User copyWith({
    String? id,
    String? name,
    Role? role,
    String? email,
    String? dob,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      email: email ?? this.email,
      dob: dob ?? this.dob,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, role: $role, email: $email, dob: $dob)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.role == role &&
        other.email == email &&
        other.dob == dob;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    role.hashCode ^
    email.hashCode ^
    dob.hashCode;
  }
}