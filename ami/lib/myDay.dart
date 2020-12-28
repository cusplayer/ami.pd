import 'package:ami/widgets/cupertino_picker.dart';
import 'package:ami/widgets/dayWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDay extends StatefulWidget {
  @override
  _MyDayState createState() => _MyDayState();
}

class _MyDayState extends State<MyDay> {
  MediaQueryData mediaQuery;
  var nightStart = 0.0 / 24.0;
  var nightEnd = 8 / 24;
  var time = DateFormat('HH:mm').format(DateTime.now());
  int selectedValue;
  showPicker() {}

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
          Container(
            padding: EdgeInsets.only(top: mediaQuery.size.height / 20),
            child: FlatButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              color: Colors.deepPurple,
              onPressed: showPicker,
              child: Text(
                'Изменить ночное время',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Picker(),
                Picker(),
                Text(':'),
                Picker(),
                Picker(),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
