import 'package:datetime_widget/custom_datetime_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime _chosenDateTime;
  String start = '2016-01-10 14:40:00.000';
  String end = '2021-04-30 00:00:00.000';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Datetime Picker"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return CustomDatetimeWidget(
                    startDate: DateTime.parse(start),
                    endDate: DateTime.parse(end),
                    onSelect: (DateTime selectedDate) {
                      setState(() {
                        _chosenDateTime = selectedDate;
                        start = selectedDate.toString();
                      });
                    },
                  );
                },
              );
            },
            child: Text("Choose a Date time"),
          ),
          SizedBox(height: 50),
          Center(
            child: Text((_chosenDateTime ?? '').toString()),
          ),
        ],
      ),
    );
  }
}
