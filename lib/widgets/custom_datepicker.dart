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

  @override
  void initState() {
    super.initState();
    calender = widget.startDate.getDaysInBetween(widget.endDate);
    years = calender.keys.toList();
    // Since initially first year is selected, we get the months in first year, and days in that month
    months = calender[years.first].keys.toList();
    days = calender[years.first][months.first];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    orientation = MediaQuery.of(context).orientation;
  }

  getCalenderDateTimes() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [

            ],
          )
        ],
      )
      // child: GridView.builder(
      //   itemCount: days.length,
      //   gridDelegate:
      //       SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (orientation == Orientation.portrait) ? 3 : 4),
      //   itemBuilder: (context, index) {
      //     return InkWell(
      //       onTap: () {
      //         setState(() {
      //           selectedDateIndex = index;
      //           widget.onSelect(days[selectedDateIndex]);
      //         });
      //       },
      //       child: Card(
      //         color: selectedDateIndex == index
      //             ? Colors.blueAccent
      //             : days[index].isToday()
      //                 ? Colors.grey[300]
      //                 : Colors.white,
      //         child: Container(
      //           padding: EdgeInsets.all(2),
      //           child: GridTile(
      //             header: Center(
      //               child: Text(
      //                 "${days[index].year}",
      //                 style: TextStyle(
      //                   fontSize: 8,
      //                   color: (selectedDateIndex == index) ? Colors.white : Colors.black,
      //                 ),
      //               ),
      //             ),
      //             footer: Center(
      //               child: Text(
      //                 constants.dayNames[days[index].weekday],
      //                 style: TextStyle(
      //                   fontSize: 8,
      //                   color: (selectedDateIndex == index) ? Colors.white : Colors.black,
      //                 ),
      //               ),
      //             ),
      //             child: Center(
      //               child: Text(
      //                 "${constants.monthMapping[days[index].month]} ${days[index].day}",
      //                 style: TextStyle(
      //                     fontWeight: FontWeight.bold,
      //                     color: (selectedDateIndex == index) ? Colors.white : Colors.black,
      //                     fontSize: 12),
      //               ),
      //             ), //just for testing, will fill with image later
      //           ),
      //         ),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
