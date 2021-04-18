import 'package:datetime_widget/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:datetime_widget/utils/helpers.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Function onSelect;

  const CustomDatePicker({Key key, this.startDate, this.endDate, this.onSelect}) : super(key: key);

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
  int selectedItemIndex = 0;

  @override
  void initState() {
    super.initState();
    calender = widget.startDate.generateCalender(widget.endDate);
    years = calender.keys.toList();
    getCalenderDateTimes();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    orientation = MediaQuery.of(context).orientation;
  }

  getCalenderDateTimes({int yearIndex, int monthIndex}) {
    // Since initially first year is selected, we get the months in first year, and days in that month
    if (yearIndex == null && monthIndex == null) {
      months = calender[years.first].keys.toList();
      days = calender[years.first][months.first];
    } else {
      selectedYearIndex = yearIndex ?? selectedYearIndex;
      months = calender[years[selectedYearIndex]].keys.toList();

      // checking if the selected month index is present
      if (months.length > monthIndex) {
        selectedMonthIndex = monthIndex;
      } else {
        selectedMonthIndex = 0;
      }
      days = calender[years[selectedYearIndex]][months[selectedMonthIndex]];
      //checking if selected day is present in the days list
      if (days.length <= selectedDayIndex) {
        selectedDayIndex = 0;
      }
      setState(() {});
    }
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
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: "Year: ",
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                                text: years[selectedYearIndex].toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
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
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: "Month: ",
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            TextSpan(
                                text: months[selectedMonthIndex].toString(),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
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
    bool isToday = false;
    if (years[selectedYearIndex] == today.year &&
        (selectedMonthIndex + 1) == today.month &&
        (selectedDayIndex + 1) == today.day) {
      isToday = true;
    }
    List dataList = (selectorIndex == 0
        ? days
        : selectorIndex == 1
            ? months
            : years);
    return SizedBox(
      height: 280,
      child: GridView.builder(
        itemCount: dataList.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (orientation == Orientation.portrait) ? 4 : 5),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              // setState(() {
              //   selectedDateIndex = index;
              //   widget.onSelect(days[selectedDateIndex]);
              // });
            },
            child: Card(
              color: selectedItemIndex == index
                  ? Colors.blueAccent
                  : isToday
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
}
