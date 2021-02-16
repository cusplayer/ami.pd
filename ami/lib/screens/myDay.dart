import 'package:ami/models/activity.dart';
import 'package:ami/widgets/dayWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDay extends StatefulWidget {
  @override
  _MyDayState createState() => _MyDayState();
}

class _MyDayState extends State<MyDay> {
  List<Activity> _activities = [
    Activity(
      id: '1',
      title: 'Спать',
      time: DateTimeRange(
        start: DateTime.utc(1989, 11, 9),
        end: DateTime.utc(1989, 11, 10),
      ),
    ),
  ];
  MediaQueryData mediaQuery;
  var nightStart = 0.0;
  var nightEnd = 0.3;
  var time = DateFormat('HH:mm').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('ы'),
      ),
      body: Center(
        child: Column(children: [
          Container(
            padding: EdgeInsets.only(top: mediaQuery.size.height / 20),
            child: Text(time, style: TextStyle(fontSize: 30)),
          ),
          Container(
            padding: EdgeInsets.only(top: mediaQuery.size.height / 20),
            child: InteractiveViewer(
              child: CustomPaint(
                painter: DayWidget(nightStart, nightEnd),
                size: Size(300, 300),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
