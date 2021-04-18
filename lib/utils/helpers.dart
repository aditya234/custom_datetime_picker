extension DateTimeHelpers on DateTime {
  bool isToday() {
    DateTime today = DateTime.now();
    if (this.year == today.year && this.month == today.month && this.day == today.day) {
      return true;
    }
    return false;
  }

  List<DateTime> getDaysInBetween(DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(this).inDays; i++) {
      days.add(this.add(Duration(days: i)));
    }
    return days;
  }
}
