import 'package:intl/intl.dart';

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

  String timeAgo(DateTime other, {DateFormat? formatter}) {
    formatter ??= DateFormat('M/dd/yyyy');
    final _difference = other.difference(this);
    String _description;
    if (_difference > Duration(days: 30)) {
      _description = formatter.format(this);
    } else if (_difference > Duration(days: 1) &&
        _difference < Duration(days: 30)) {
      _description =
          '${_difference.inDays} ${Intl.plural(_difference.inDays, one: 'day', other: 'days')} ago';
    } else if (_difference < Duration(hours: 24) &&
        _difference > Duration(hours: 1)) {
      _description =
          '${_difference.inHours} ${Intl.plural(_difference.inHours, one: 'hour', other: 'hours')} ago';
    } else if (_difference < Duration(minutes: 60) &&
        _difference > Duration(minutes: 1)) {
      _description =
          '${_difference.inMinutes} ${Intl.plural(_difference.inMinutes, one: 'min', other: 'mins')} ago';
    } else {
      _description = '< 1 min ago';
    }

    return _description;
  }

  String timeAgoShortHand(DateTime other) {
    final _difference = other.difference(this);
    String _description;
    if (_difference > Duration(days: 30)) {
      _description = '${_difference.inDays ~/ 7}w';
    } else if (_difference > Duration(days: 1) &&
        _difference < Duration(days: 30)) {
      _description = '${_difference.inDays}d';
    } else if (_difference < Duration(hours: 24) &&
        _difference > Duration(hours: 1)) {
      _description = '${_difference.inHours}h';
    } else if (_difference < Duration(minutes: 60) &&
        _difference > Duration(minutes: 1)) {
      _description = '${_difference.inMinutes}m';
    } else {
      _description = '< 1m';
    }

    return _description;
  }

  int weekNumber() {
    int dayOfYear = int.parse(DateFormat('D').format(this));
    int woy = ((dayOfYear - weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = numOfWeeksInYear(year - 1);
    } else if (woy > numOfWeeksInYear(year)) {
      woy = 1;
    }
    return woy;
  }
}

int numOfWeeksInYear(int year) {
  DateTime dec28 = DateTime(year, 12, 28);
  int dayOfDec28 = int.parse(DateFormat('D').format(dec28));
  return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
}


int currentTimestamp() {
  return DateTime.now().millisecondsSinceEpoch ~/ 1000;
}

int descendingSorter(DateTime? d1, DateTime? d2) =>
    d1 != null && d2 != null ? d2.compareTo(d1) : 0;

int ascendingSorter(DateTime? d1, DateTime? d2) =>
    d1 != null && d2 != null ? d1.compareTo(d2) : 0;