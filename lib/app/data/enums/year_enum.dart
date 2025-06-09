// Define the YearEnum to match backend
enum YearEnum {
  FIRST(1),
  SECOUND(2),
  THIRD(3),
  FOURTH(4),
  FIFTH(5),
  OF_GRADUATES(6),
  GRADUATED(7);

  final int value;

  const YearEnum(this.value);

  factory YearEnum.fromInt(int value) {
    return YearEnum.values.firstWhere(
          (e) => e.value == value,
      orElse: () => YearEnum.FIRST,
    );
  }

  @override
  String toString() => value.toString();
}