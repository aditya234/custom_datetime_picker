import 'package:datetime_widget/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Function onSelect;

  const CustomTimePicker({Key key, this.startDate, this.endDate, this.onSelect}) : super(key: key);

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  bool isAm = true;

  int selectedHour;
  int selectedMinute;

  List<int> hourList;
  List<int> minuteList = List.generate(60, (index) => index);
  FixedExtentScrollController hourController;
  FixedExtentScrollController minuteController;
  double timeSelectorHeight = 40;
  Constants constants = Constants();

  @override
  void initState() {
    super.initState();
    selectedMinute = widget.startDate.minute;
    if (widget.startDate.hour < 12) {
      selectedHour = widget.startDate.hour;
      hourList = constants.firstHalfOfDay;
    } else {
      selectedHour = (widget.startDate.hour ~/ 12);
      hourList = constants.secondHalfOfDay;
      isAm = false;
    }

    hourController = FixedExtentScrollController(initialItem: selectedHour);
    minuteController = FixedExtentScrollController(initialItem: selectedMinute);
  }

  void _changeHalfOfDay(bool value) {
    setState(() {
      isAm = value;
      if (isAm) {
        hourList = constants.firstHalfOfDay;
      } else {
        hourList = constants.secondHalfOfDay;
      }
      select();
    });
  }

  void select() {
    int hour = hourList[hourController.selectedItem];

    // If selected PM
    if (!isAm && hour != 12) {
      hour += 12;
    }
    TimeOfDay selectedDate = TimeOfDay(hour: hour, minute: minuteList[minuteController.selectedItem]);
    widget.onSelect(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: constants.borderColor,
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
                  color: constants.borderColor,
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
                      decoration: BoxDecoration(
                        color: !isAm ? Colors.blueAccent : Colors.white,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(8)),
                      ),
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
                      // key: UniqueKey(),
                      itemExtent: timeSelectorHeight,
                      useMagnifier: true,
                      magnification: 1.5,
                      diameterRatio: 1.6,
                      controller: hourController,
                      overAndUnderCenterOpacity: 0.3,
                      onSelectedItemChanged: (selectedIndex) {
                        select();
                      },
                      children: <Widget>[
                        ...hourList.map((int hour) {
                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text("${(hour < 10) ? 0 : ''}${hour.toString()}"),
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
                      onSelectedItemChanged: (selectedIndex) {
                        select();
                      },
                      children: <Widget>[
                        ...minuteList.map((int minute) {
                          return Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text("${(minute < 10) ? 0 : ''}${minute.toString()}"),
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
    );
  }
}
