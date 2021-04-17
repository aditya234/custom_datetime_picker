import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDatetimeWidget extends StatefulWidget {
  final Function onSelect;
  final DateTime startDate;
  final DateTime endDate;

  const CustomDatetimeWidget({Key key, this.onSelect, this.startDate, this.endDate}) : super(key: key);

  @override
  _CustomDatetimeWidgetState createState() => _CustomDatetimeWidgetState();
}

class _CustomDatetimeWidgetState extends State<CustomDatetimeWidget> {
  bool showLoader = true;
  List<DateTime> days = [];
  List<String> dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
  Map<int, String> monthMapping = {
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

  bool isAm = true;

  int selectedDateIndex;
  int selectedHour;
  int selectedMinute;

  List<int> hourList;
  List<int> minuteList = List.generate(60, (index) => index);
  FixedExtentScrollController hourController;
  FixedExtentScrollController minuteController;
  double timeSelectorHeight = 40;
  Orientation orientation;

  @override
  void initState() {
    super.initState();
    getDaysInBetween(widget.startDate, widget.endDate);
    reset();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    orientation = MediaQuery.of(context).orientation;
  }

  void reset() {
    selectedDateIndex = null;
    selectedMinute = widget.startDate.minute;
    if (widget.startDate.hour <= 12) {
      selectedHour = widget.startDate.hour;
      hourList = List.generate(12, (index) => index + 1);
    } else {
      selectedHour = (widget.startDate.hour ~/ 12);
      hourList = List.generate(11, (index) => index + 1);
      isAm = false;
    }

    if (hourController == null && minuteController == null) {
      hourController = FixedExtentScrollController(initialItem: selectedHour);
      minuteController = FixedExtentScrollController(initialItem: selectedMinute);
    } else {
      hourController.animateToItem(selectedHour, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      minuteController.animateToItem(selectedMinute, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      setState(() {});
    }
  }

  void select() {
    DateTime selectedDate;
    DateTime today = DateTime.now();
    int hour = hourList[hourController.selectedItem];

    // If selected PM
    if (!isAm) {
      hour += 12;
    }

    if (selectedDateIndex == null) {
      selectedDate = DateTime(today.year, today.month, today.day, hour, minuteList[minuteController.selectedItem]);
    } else {
      selectedDate = DateTime(days[selectedDateIndex].year, days[selectedDateIndex].month, days[selectedDateIndex].day,
          hour, minuteList[minuteController.selectedItem]);
    }

    widget.onSelect(selectedDate);
    Navigator.pop(context);
  }

  void _changeHalfOfDay(bool value) {
    setState(() {
      isAm = value;
      if (isAm) {
        hourList = List.generate(12, (index) => index + 1);
      } else {
        hourList = List.generate(11, (index) => index + 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(8),
        ),
        constraints: BoxConstraints(maxHeight: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLoader) ...[
              Center(
                child: CircularProgressIndicator(),
              ),
            ] else ...[
              SizedBox(
                height: 350,
                child: Row(
                  children: [
                    _drawCalender(context),
                    _drawTimeSelector(context),
                  ],
                ),
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          reset();
                        },
                        child: Container(
                          color: Colors.grey[300],
                          child: Center(
                            child: Text("Reset"),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: select,
                        child: Container(
                          color: Colors.lightGreen,
                          child: Center(
                            child: Text(
                              "Select",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  getDaysInBetween(DateTime startDate, DateTime endDate) {
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    setState(() {
      showLoader = false;
    });
  }

  _drawCalender(BuildContext context) {
    return Flexible(
      flex: 2,
      fit: FlexFit.tight,
      child: Container(
        height: 350,
        padding: EdgeInsets.all(8),
        child: GridView.builder(
          itemCount: days.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (orientation == Orientation.portrait) ? 3 : 4),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                setState(() {
                  selectedDateIndex = index;
                });
              },
              child: Card(
                color: selectedDateIndex == index
                    ? Colors.blueAccent
                    : days[index].isToday()
                        ? Colors.grey[300]
                        : Colors.white,
                child: Container(
                  padding: EdgeInsets.all(2),
                  child: GridTile(
                    header: Center(
                      child: Text(
                        "${days[index].year}",
                        style: TextStyle(
                          fontSize: 8,
                          color: (selectedDateIndex == index) ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    footer: Center(
                      child: Text(
                        dayNames[days[index].weekday],
                        style: TextStyle(
                          fontSize: 8,
                          color: (selectedDateIndex == index) ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "${monthMapping[days[index].month]} ${days[index].day}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: (selectedDateIndex == index) ? Colors.white : Colors.black,
                            fontSize: 12),
                      ),
                    ), //just for testing, will fill with image later
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _drawTimeSelector(BuildContext context) {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: Container(
        height: 350,
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: Color(0xffb5b3b3),
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xffb5b3b3),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _changeHalfOfDay(true);
                      },
                      child: Container(
                        color: isAm ? Colors.blueAccent : Colors.white,
                        child: Center(
                          child: Text(
                            "AM",
                            style: TextStyle(
                              color: isAm ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _changeHalfOfDay(false);
                      },
                      child: Container(
                        color: !isAm ? Colors.blueAccent : Colors.white,
                        child: Center(
                          child: Text(
                            "PM",
                            style: TextStyle(
                              color: !isAm ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: 300,
              padding: EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: ListWheelScrollView(
                        key: UniqueKey(),
                        itemExtent: timeSelectorHeight,
                        useMagnifier: true,
                        magnification: 1.5,
                        diameterRatio: 1.6,
                        controller: hourController,
                        overAndUnderCenterOpacity: 0.3,
                        children: <Widget>[
                          ...hourList.map((int hour) {
                            return Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              child: Center(
                                child: Text(hour.toString()),
                              ),
                            );
                          })
                        ]),
                  ),
                  Expanded(
                    child: ListWheelScrollView(
                        itemExtent: timeSelectorHeight,
                        useMagnifier: true,
                        magnification: 1.5,
                        diameterRatio: 1.6,
                        controller: minuteController,
                        overAndUnderCenterOpacity: 0.3,
                        children: <Widget>[
                          ...minuteList.map((int minute) {
                            return Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              child: Center(
                                child: Text(minute.toString()),
                              ),
                            );
                          })
                        ]),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

extension DateTimeHelpers on DateTime {
  bool isToday() {
    DateTime today = DateTime.now();
    if (this.year == today.year && this.month == today.month && this.day == today.day) {
      return true;
    }
    return false;
  }
}
