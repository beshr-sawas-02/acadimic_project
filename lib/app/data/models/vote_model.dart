import 'dart:convert';
class CourseVote {
  final String courseId;
  final String courseName;
  final String courseCode;
  final int voteCount;
  final int graduatingVotersCount;
  final List<VoterInfo> voters;

  CourseVote({
    required this.courseId,
    required this.courseName,
    required this.courseCode,
    required this.voteCount,
    required this.graduatingVotersCount,
    required this.voters,
  });

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'courseName': courseName,
      'courseCode': courseCode,
      'voteCount': voteCount,
      'graduatingVotersCount': graduatingVotersCount,
      'voters': voters.map((voter) => voter.toMap()).toList(),
    };
  }

  factory CourseVote.fromMap(Map<String, dynamic> map) {
    return CourseVote(
      courseId: map['courseId'] ?? '',
      courseName: map['courseName'] ?? '',
      courseCode: map['courseCode'] ?? '',
      voteCount: map['voteCount'] ?? 0,
      graduatingVotersCount: map['graduatingVotersCount'] ?? 0,
      voters: (map['voters'] as List<dynamic>?)
          ?.map((voter) => VoterInfo.fromMap(voter))
          .toList() ??
          [],
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseVote.fromJson(String source) =>
      CourseVote.fromMap(json.decode(source));
}

class VoterInfo {
  final String studentId;
  final String name;
  final int universityId;
  final bool isGraduating;

  VoterInfo({
    required this.studentId,
    required this.name,
    required this.universityId,
    required this.isGraduating,
  });

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'name': name,
      'universityId': universityId,
      'isGraduating': isGraduating,
    };
  }

  factory VoterInfo.fromMap(Map<String, dynamic> map) {
    return VoterInfo(
      studentId: map['studentId'] ?? '',
      name: map['name'] ?? '',
      universityId: map['universityId'] ?? 0,
      isGraduating: map['isGraduating'] ?? false,
    );
  }
}

// Keep the existing Vote, CreateVoteRequest, UpdateVoteRequest, OpenVotingRequest, and CourseVotesParams classes as they are, as they are still relevant for other operations.
class Vote {
  final String id;
  final String studentId;
  final String courseId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? student;
  final Map<String, dynamic>? course;

  Vote({
    required this.id,
    required this.studentId,
    required this.courseId,
    required this.createdAt,
    required this.updatedAt,
    this.student,
    this.course,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'studentId': studentId,
      'courseId': courseId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'student': student,
      'course': course,
    };
  }

  factory Vote.fromMap(Map<String, dynamic> map) {
    return Vote(
      id: map['_id'] ?? '',
      studentId: map['studentId']["_id"] ?? '',
      courseId: map['courseId']["_id"],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toIso8601String()),
      student: map['studentId'],
      course:  map['courseId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Vote.fromJson(String source) => Vote.fromMap(json.decode(source));


  Vote copyWith({
    String? id,
    String? studentId,
    String? courseId,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? student,
    Map<String, dynamic>? course,
  }) {
    return Vote(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      courseId: courseId ?? this.courseId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      student: student ?? this.student,
      course: course ?? this.course,
    );
  }

  @override
  String toString() {
    return 'Vote(id: $id, studentId: $studentId, courseId: $courseId, createdAt: $createdAt, updatedAt: $updatedAt, student: $student, course: $course)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Vote &&
        other.id == id &&
        other.studentId == studentId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    studentId.hashCode ^
    courseId.hashCode ^
    createdAt.hashCode ^
    updatedAt.hashCode;
  }
}

class CreateVoteRequest {
  final List<String> courseId;

  CreateVoteRequest({
    required this.courseId,
  });

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
    };
  }

  String toJson() => json.encode(toMap());
}

class UpdateVoteRequest {
  final List<String> courseId;

  UpdateVoteRequest({
    required this.courseId,
  });

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
    };
  }

  String toJson() => json.encode(toMap());
}

class OpenVotingRequest {
  final DateTime startDate;
  final DateTime endDate;

  OpenVotingRequest({
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());
}

class CourseVotesParams {
  final String courseId;
  final DateTime startDate;
  final DateTime endDate;

  CourseVotesParams({
    required this.courseId,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}