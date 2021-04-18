import 'package:datetime_widget/utils/constants.dart';

extension DateTimeHelpers on DateTime {
  bool isToday() {
    DateTime today = DateTime.now();
    if (this.year == today.year && this.month == today.month && this.day == today.day) {
      return true;
    }
    return false;
  }

  Map<int, Map<String, List<int>>> getDaysInBetween(DateTime endDate) {
    Constants constants = Constants();
    Map<int, Map<String, List<int>>> calender = {};
    calender[this.year] = {
      constants.monthMapping[this.month]: [this.day],
    };
    for (int i = 0; i <= endDate.difference(this).inDays; i++) {
      // days.add(this.add(Duration(days: i)));
      DateTime date = this.add(Duration(days: i));
      if (calender.containsKey(date.year)) {
        if (calender[date.year].containsKey(constants.monthMapping[this.month])) {
          calender[date.year][constants.monthMapping[date.month]].add(date.day);
        } else {
          calender[date.year][constants.monthMapping[date.month]] = [date.day];
        }
      } else {
        calender[date.year] = {
          constants.monthMapping[date.month]: [date.day],
        };
      }
    }
    return calender;
  }
}
