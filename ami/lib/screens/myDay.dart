import 'package:ami/models/activity.dart';
import 'package:ami/widgets/day_widget.dart';
import 'package:ami/widgets/time_picker.dart';
import 'package:ami/widgets/widget_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDay extends StatefulWidget {
  @override
  _MyDayState createState() => _MyDayState();
}

class _MyDayState extends State<MyDay> {
  List<String> _items = ['1', '2', '3', '4', '5', '6'];
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              // height: 20,
              padding: EdgeInsets.only(top: mediaQuery.size.height / 30),
              child: Text(time, style: TextStyle(fontSize: 27)),
            ),
            Container(
              padding: EdgeInsets.only(top: mediaQuery.size.height / 20),
              child: InteractiveViewer(
                child: CustomPaint(
                  painter: DayWidget(nightStart, nightEnd),
                  size: Size(
                      mediaQuery.size.height / 3, mediaQuery.size.height / 3),
                ),
              ),
            ),
            Container(
              height: mediaQuery.size.height / 3,
              margin: EdgeInsets.only(top: mediaQuery.size.height / 20),
              child: WidgetList(
                items: _items,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
