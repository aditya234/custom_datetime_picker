import 'package:datetime_widget/utils/constants.dart';

extension DateTimeHelpers on DateTime {
  bool isToday() {
    DateTime today = DateTime.now();
    if (this.year == today.year && this.month == today.month && this.day == today.day) {
      return true;
    }
    return false;
  }

  Map<int, Map<String, List<int>>> generateCalender(DateTime endDate) {
    Constants constants = Constants();
    Map<int, Map<String, List<int>>> calender = {};
    for (int i = 0; i <= endDate.difference(this).inDays; i++) {
      DateTime date = this.add(Duration(days: i));
      //if contains this year
      if (calender.containsKey(date.year)) {
        if ((calender[date.year] ?? const {})[constants.monthMapping[date.month]] == null) {
          //for flutter version with null safety
          ////////////// calender[date.year]![constants.monthMapping[date.month]!] = [date.day];
          //for flutter version with no null safety
          calender[date.year][constants.monthMapping[date.month]] = [date.day];
        } else {
          //for flutter version with null safety
          ////////////// calender[date.year]![constants.monthMapping[date.month]!]!.add(date.day);
          //for flutter version with no null safety
          calender[date.year][constants.monthMapping[date.month]].add(date.day);
        }
      }
      //if doesnot contain the year
      else {
        calender[date.year] = {
          //for flutter version with null safety
          ////////////// constants.monthMapping[date.month]!: [date.day],
          //for flutter version with no null safety
          constants.monthMapping[date.month]: [date.day],
        };
      }
    }
    return calender;
  }
}
