// Define the Role enum to match backend
enum Role {
  ADMIN("admin"),
  STUDENT("student"),
  EMP("emp");

  final String value;

  const Role(this.value);

  factory Role.fromString(String value) {
    return Role.values.firstWhere(
          (e) => e.value == value,
      orElse: () => Role.EMP,
    );
  }

  @override
  String toString() => value;
}