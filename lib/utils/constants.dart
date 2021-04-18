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
        12: "Dec"
      };

  List<String> get dayNames => ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  List<int> get firstHalfOfDay => List.generate(12, (index) => index);

  List<int> get secondHalfOfDay => [12] + List.generate(11, (index) => index + 1);
}
