extension DateTimeExtensions on DateTime {
  bool isValid() {
    if (month > 12 || month < 1) return false;
    if (day < 1 || day > daysInMonth(month, year)) return false;
    if (year < 1810 || year > DateTime.now().year) return false;

    return true;
  }

  static int daysInMonth(int month, int year) {
    int days = 28 +
        (month + (month / 8).floor()) % 2 +
        2 % month +
        2 * (1 / month).floor();
    return (isLeapYear(year) && month == 2) ? 29 : days;
  }

  static bool isLeapYear(int year) =>
      ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0);
}
