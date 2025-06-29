import 'dart:convert';
import '../enums/year_enum.dart';

class Student {
  final String id;
  final String name;
  final String major;
  final YearEnum year;
  final int universityId;

  Student({
    required this.id,
    required this.name,
    required this.major,
    required this.year,
    required this.universityId,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'major': major,
      'year': year.value,
      'universityId': universityId,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      major: map['major'] ?? '',
      year: YearEnum.fromInt(map['academicStatus'] ?? 1),
      universityId: map['universityId']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Student.fromJson(String source) => Student.fromMap(json.decode(source));

  Student copyWith({
    String? id,
    String? name,
    String? major,
    YearEnum? year,
    int? universityId,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      major: major ?? this.major,
      year: year ?? this.year,
      universityId: universityId ?? this.universityId,
    );
  }

  @override
  String toString() {
    return 'Student(id: $id, name: $name, major: $major, year: $year, universityId: $universityId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Student &&
        other.id == id &&
        other.name == name &&
        other.major == major &&
        other.year == year &&
        other.universityId == universityId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    major.hashCode ^
    year.hashCode ^
    universityId.hashCode;
  }
}

class CreateStudentRequest {
  final String name;
  final String major;
  final YearEnum year;
  final int universityId;
  final String password;

  CreateStudentRequest({
    required this.name,
    required this.major,
    required this.year,
    required this.universityId,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'major': major,
      'year': year.value,
      'universityId': universityId,
      'password': password,
    };
  }

  String toJson() => json.encode(toMap());
}

class UpdateStudentRequest {
  final String? name;
  final String? major;
  final YearEnum? year;
  final int? universityId;
  final String? password;

  UpdateStudentRequest({
    this.name,
    this.major,
    this.year,
    this.universityId,
    this.password,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};

    if(name != null) data['name'] = name;
    if(major != null) data['major'] = major;
    if(year != null) data['year'] = year!.value;
    if(universityId != null) data['universityId'] = universityId;
    if(password != null) data['password'] = password;

    return data;
  }

  String toJson() => json.encode(toMap());
}

class GpaResponse {
  final double gpa;
  final Map<String, dynamic>? details;

  GpaResponse({
    required this.gpa,
    this.details,
  });

  factory GpaResponse.fromMap(Map<String, dynamic> map) {
    return GpaResponse(
      gpa: map['gpa']?.toDouble() ?? 0.0,
      details: map['details'],
    );
  }

  factory GpaResponse.fromJson(String source) =>
      GpaResponse.fromMap(json.decode(source));
}