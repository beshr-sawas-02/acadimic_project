import 'dart:convert';

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  String toJson() => json.encode(toMap());
}

class LoginResponse {
  final String accessToken;
  final Map<String, dynamic> user;

  LoginResponse({
    required this.accessToken,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return {
      'accessToken': accessToken,
      'user': user,
    };
  }

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      accessToken: map['access_token'] ?? '',
      user: Map<String, dynamic>.from(map['user'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromJson(String source) =>
      LoginResponse.fromMap(json.decode(source));
}

class LoginAdminRequest {
  final String email;
  final String password;

  LoginAdminRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  String toJson() => json.encode(toMap());
}