import 'dart:convert';
import '../enums/role_enum.dart';

class Employee {
  final String id;
  final String name;
  final String email;
  final String dob;
  final Role role;
  final bool? isActive;
  final String? endDate;
  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.dob,
    this.role = Role.EMP,
    this.isActive=true,
    this.endDate
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'dob': dob,
      'role': role.toString(),
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      dob: map['dob'] ?? '',
      role: Role.fromString(map['role'] ?? 'emp'),
      endDate: map['endDate'],
      isActive: map["isActive"] ?? true
    );
  }

  String toJson() => json.encode(toMap());

  factory Employee.fromJson(String source) => Employee.fromMap(json.decode(source));

  Employee copyWith({
    String? id,
    String? name,
    String? email,
    String? dob,
    Role? role,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      role: role ?? this.role,
    );
  }

  @override
  String toString() {
    return 'Employee(id: $id, name: $name, email: $email, dob: $dob, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Employee &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.dob == dob &&
        other.role == role;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    email.hashCode ^
    dob.hashCode ^
    role.hashCode;
  }
}

class CreateEmployeeRequest {
  final String name;
  final String email;
  final String dob;
  final String password;

  CreateEmployeeRequest({
    required this.name,
    required this.email,
    required this.dob,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'dob': dob,
      'password': password,
    };
  }

  String toJson() => json.encode(toMap());
}

class UpdateEmployeeRequest {
  final String? name;
  final String? email;
  final String? dob;
  final String? password;

  UpdateEmployeeRequest({
    this.name,
    this.email,
    this.dob,
    this.password,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};

    if(name != null) data['name'] = name;
    if(email != null) data['email'] = email;
    if(dob != null) data['dob'] = dob;
    if(password != null) data['password'] = password;

    return data;
  }

  String toJson() => json.encode(toMap());
}