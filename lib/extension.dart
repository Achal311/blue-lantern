extension DateTimeExtension on DateTime {
  DateTime startOfDay() {
    return DateTime(this.year, this.month, this.day);
  }
}
