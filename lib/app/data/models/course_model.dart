import 'dart:convert';
import '../enums/year_enum.dart';

class Course {
  final String id;
  final String name;
  final String teacher;
  final String type;
  final YearEnum year;
  final String semester;
  final String courseCode;
  final List<String>? prerequisites;
  final bool isOpen;

  Course({
    required this.id,
    required this.name,
    required this.teacher,
    required this.type,
    required this.year,
    required this.semester,
    required this.courseCode,
    this.prerequisites,
    this.isOpen = false,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'teacher': teacher,
      'type': type,
      'year': year.value,
      'semester': semester,
      'courseCode': courseCode,
      'prerequisites': prerequisites,
      'isOpen': isOpen,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      teacher: map['teacher'] ?? '',
      type: map['type'] ?? '',
      year: YearEnum.fromInt(map['year'] ?? 1),
      semester: map['semester'] ?? '',
      courseCode: map['courseCode'] ?? '',
      prerequisites: List<String>.from(map['prerequisites'] ?? []),
      isOpen: map['isOpen'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Course.fromJson(String source) => Course.fromMap(json.decode(source));

  Course copyWith({
    String? id,
    String? name,
    String? teacher,
    String? type,
    YearEnum? year,
    String? semester,
    String? courseCode,
    List<String>? prerequisites,
    bool? isOpen,
  }) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      teacher: teacher ?? this.teacher,
      type: type ?? this.type,
      year: year ?? this.year,
      semester: semester ?? this.semester,
      courseCode: courseCode ?? this.courseCode,
      prerequisites: prerequisites ?? this.prerequisites,
      isOpen: isOpen ?? this.isOpen,
    );
  }

  @override
  String toString() {
    return 'Course(id: $id, name: $name, teacher: $teacher, type: $type, year: $year, semester: $semester, courseCode: $courseCode, prerequisites: $prerequisites, isOpen: $isOpen)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Course &&
        other.id == id &&
        other.name == name &&
        other.teacher == teacher &&
        other.type == type &&
        other.year == year &&
        other.semester == semester &&
        other.courseCode == courseCode &&
        other.isOpen == isOpen;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    teacher.hashCode ^
    type.hashCode ^
    year.hashCode ^
    semester.hashCode ^
    courseCode.hashCode ^
    isOpen.hashCode;
  }
}

class CreateCourseRequest {
  final String name;
  final String teacher;
  final String type;
  final YearEnum year;
  final String semester;
  final String courseCode;
  final List<String>? prerequisites;

  CreateCourseRequest({
    required this.name,
    required this.teacher,
    required this.type,
    required this.year,
    required this.semester,
    required this.courseCode,
    this.prerequisites,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'teacher': teacher,
      'type': type,
      'year': year.value,
      'semester': semester,
      'courseCode': courseCode,
      'prerequisites': prerequisites,
    };
  }

  String toJson() => json.encode(toMap());
}

class UpdateCourseRequest {
  final String? name;
  final String? teacher;
  final String? type;
  final YearEnum? year;
  final String? semester;
  final String? courseCode;
  final List<String>? prerequisites;
  final bool? isOpen;

  UpdateCourseRequest({
    this.name,
    this.teacher,
    this.type,
    this.year,
    this.semester,
    this.courseCode,
    this.prerequisites,
    this.isOpen,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};

    if(name != null) data['name'] = name;
    if(teacher != null) data['teacher'] = teacher;
    if(type != null) data['type'] = type;
    if(year != null) data['year'] = year!.value;
    if(semester != null) data['semester'] = semester;
    if(courseCode != null) data['courseCode'] = courseCode;
    if(prerequisites != null) data['prerequisites'] = prerequisites;
    if(isOpen != null) data['isOpen'] = isOpen;

    return data;
  }

  String toJson() => json.encode(toMap());
}