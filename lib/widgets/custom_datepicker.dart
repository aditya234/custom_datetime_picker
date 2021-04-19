import 'package:datetime_widget/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:datetime_widget/utils/helpers.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final DateTime chosenDate;
  final Function onSelect;

  const CustomDatePicker({Key key, this.startDate, this.endDate, this.onSelect, this.chosenDate}) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  int selectedDateIndex;
  Orientation orientation;
  Constants constants = Constants();
  Map<int, Map<String, List<int>>> calender;
  List<int> days = [];
  List<String> months = [];
  List<int> years = [];
  int selectedYearIndex = 0;
  int selectedMonthIndex = 0;
  int selectedDayIndex = 0;

  /// 0=> day selector
  /// 1=> month selector
  /// 2=> year selector
  int selectorIndex = 0;

  @override
  void initState() {
    super.initState();
    calender = widget.startDate.generateCalender(widget.endDate);
    years = calender.keys.toList();
    if (widget.chosenDate == null) {
      getCalenderDateTimes();
    } else {
      //setting chosen date if there's any
      selectedYearIndex = years.indexOf(widget.chosenDate.year) ?? 0;
      months = calender[years[selectedYearIndex]].keys.toList();
      selectedMonthIndex = (months.length > (widget.chosenDate.month - 1))
          ? months.indexOf(constants.monthMapping[widget.chosenDate.month])
          : 0;
      days = calender[years[selectedYearIndex]][months[selectedMonthIndex]];
      selectedDayIndex = days.contains(widget.chosenDate.day) ? days.indexOf(widget.chosenDate.day) : 0;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    orientation = MediaQuery.of(context).orientation;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      //open year selector
                      setState(() {
                        selectorIndex = 2;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Year:",
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(width: 2),
                          Text(
                            years[selectedYearIndex].toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // open month selector
                      setState(() {
                        selectorIndex = 1;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Month:",
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(width: 2),
                          Text(
                            months[selectedMonthIndex].toString(),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          _createPicker(context),
        ],
      ),
    );
  }

  _createPicker(BuildContext context) {
    DateTime today = DateTime.now();

    List dataList = [];

    int selectedItemIndex = 0;
    switch (selectorIndex) {
      case 0:
        selectedItemIndex = selectedDayIndex;
        dataList = days;
        break;
      case 1:
        selectedItemIndex = selectedMonthIndex;
        dataList = months;
        break;
      case 2:
        selectedItemIndex = selectedYearIndex;
        dataList = years;
        break;
    }
    return SizedBox(
      height: 280,
      child: GridView.builder(
        itemCount: dataList.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (orientation == Orientation.portrait) ? 4 : 5),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              _onPickerTap(index);
            },
            child: Card(
              color: selectedItemIndex == index
                  ? Colors.blueAccent
                  : (selectorIndex == 0 &&
                          today.day == days[index] &&
                          (getMonthIndex() == today.month) &&
                          (years[selectedYearIndex] == today.year))
                      ? Colors.grey[300]
                      : Colors.white,
              child: Container(
                padding: EdgeInsets.all(2),
                child: Center(
                  child: Text(
                    dataList[index].toString(),
                    // "${constants.monthMapping[days[index].month]} ${days[index].day}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: (selectedDateIndex == index) ? Colors.white : Colors.black,
                        fontSize: 12),
                  ),
                ),
              ),
            ),
            // ),
          );
        },
      ),
    );
  }

  void _onPickerTap(int index) {
    switch (selectorIndex) {
      case 0:
        selectedDayIndex = index;
        break;
      case 1:
        selectedMonthIndex = index;
        selectorIndex = 0;
        selectedDayIndex = 0;
        getCalenderDateTimes();
        break;
      case 2:
        selectedYearIndex = index;
        selectorIndex = 1;
        selectedMonthIndex = 0;
        selectedDayIndex = 0;
        getCalenderDateTimes();
        break;
    }

    widget.onSelect(DateTime(years[selectedYearIndex], getMonthIndex(), days[selectedDayIndex]));
    setState(() {});
  }

  getCalenderDateTimes() {
    months = calender[years[selectedYearIndex]].keys.toList();
    days = calender[years[selectedYearIndex]][months[selectedMonthIndex]];
  }

  getMonthIndex() {
    int selectedMonth = 0;
    constants.monthMapping.forEach((key, value) {
      if (months[selectedMonthIndex] == value) {
        selectedMonth = key;
      }
    });
    return selectedMonth;
  }
}
