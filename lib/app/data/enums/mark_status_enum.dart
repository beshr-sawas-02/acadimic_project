// Define the MarkStatus enum to match backend
enum MarkStatus {
  DEPRIVED("deprived"),
  WITHDRAW("with_draw"),
  PATCHY("patchy"),
  NORMAL("normal");

  final String value;

  const MarkStatus(this.value);

  factory MarkStatus.fromString(String value) {
    return MarkStatus.values.firstWhere(
          (e) => e.value == value,
      orElse: () => MarkStatus.NORMAL,
    );
  }

  @override
  String toString() => value;
}