import 'dart:convert';
import '../enums/mark_status_enum.dart';

class Mark {
  final String id;
  final String courseId;
  final String studentId;
  final double mark;
  final String type;
  final MarkStatus status;
  final String? courseName;
  final String? studentName;

  Mark({
    required this.id,
    required this.courseId,
    required this.studentId,
    required this.mark,
    required this.type,
    this.status = MarkStatus.NORMAL,
    this.courseName,
    this.studentName,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'courseId': courseId,
      'studentId': studentId,
      'mark': mark,
      'type': type,
      'status': status.toString(),
      'courseName': courseName,
      'studentName': studentName,
    };
  }

  factory Mark.fromMap(Map<String, dynamic> map) {
    return Mark(
      id: map['_id'] ?? '',
      courseId: map['courseId']?['_id'] ?? '',
      studentId: map['studentId']?['_id'] ?? '',
      mark: (map['mark'] is int)
          ? (map['mark'] as int).toDouble()
          : (map['mark'] is double)
          ? map['mark']
          : 0.0,
      type: map['type'] ?? '',
      status: MarkStatus.fromString(map['status'] ?? 'normal'),
      courseName: map['courseId'] != null ? map['courseId']['name'] : null,
      studentName: map['studentId'] != null ? map['studentId']['name'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Mark.fromJson(String source) => Mark.fromMap(json.decode(source));

  Mark copyWith({
    String? id,
    String? courseId,
    String? studentId,
    double? mark,
    String? type,
    MarkStatus? status,
    String? courseName,
    String? studentName,
  }) {
    return Mark(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      studentId: studentId ?? this.studentId,
      mark: mark ?? this.mark,
      type: type ?? this.type,
      status: status ?? this.status,
      courseName: courseName ?? this.courseName,
      studentName: studentName ?? this.studentName,
    );
  }

  @override
  String toString() {
    return 'Mark(id: $id, courseId: $courseId, studentId: $studentId, mark: $mark, type: $type, status: $status, courseName: $courseName, studentName: $studentName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Mark &&
        other.id == id &&
        other.courseId == courseId &&
        other.studentId == studentId &&
        other.mark == mark &&
        other.type == type &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    courseId.hashCode ^
    studentId.hashCode ^
    mark.hashCode ^
    type.hashCode ^
    status.hashCode;
  }
}

class BulkImportMarkRequest {
  final String courseId;
  final String studentId;
  final double mark;
  final String type;

  BulkImportMarkRequest({
    required this.courseId,
    required this.studentId,
    required this.mark,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'studentId': studentId,
      'mark': mark,
      'type': type,
    };
  }

  String toJson() => json.encode(toMap());
}

class UpdateMarkRequest {
  final double? mark;
  final String? type;
  final MarkStatus? status;

  UpdateMarkRequest({
    this.mark,
    this.type,
    this.status,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};

    if (mark != null) data['mark'] = mark;
    if (type != null) data['type'] = type;
    if (status != null) data['status'] = status.toString();

    return data;
  }

  String toJson() => json.encode(toMap());
}
