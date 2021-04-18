import 'package:flutter/material.dart';

class Constants {
  Map<int, String> get monthMapping => {
        1: "Jan",
        2: "Feb",
        3: "Mar",
        4: "Apr",
        5: "May",
        6: "Jun",
        7: "Jul",
        8: "Aug",
        9: "Sep",
        10: "Oct",
        11: "Nov",
        12: "Dec",
      };

  Map<String, String> get monthNames => {
        "Jan": "January",
        "Feb": "February",
        "Mar": "March",
        "Apr": "April",
        "May": "May",
        "Jun": "June",
        "Jul": "July",
        "Aug": "August",
        "Sep": "September",
        "Oct": "October",
        "Nov": "November",
        "Dec": "December",
      };

  List<String> get dayNames => ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  List<int> get firstHalfOfDay => List.generate(12, (index) => index);

  List<int> get secondHalfOfDay => [12] + List.generate(11, (index) => index + 1);

  Color get borderColor => Color(0xffb5b3b3);
}
