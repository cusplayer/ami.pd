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
  void callbackh1(String time) {
    setState(() {
      this.hour1 = time;
    });
  }

  void callbackm1(String time) {
    setState(() {
      this.minute1 = time;
    });
  }

  void callbackh2(String time) {
    setState(() {
      this.hour2 = time;
    });
  }

  void callbackm2(String time) {
    setState(() {
      this.minute2 = time;
    });
  }

  MediaQueryData mediaQuery;
  var nightStart = 0.0 / 24.0;
  var nightEnd = 8 / 24;
  var hour1 = '0';
  var minute1 = '0';
  var hour2 = '0';
  var minute2 = '0';
  var time = DateFormat('HH:mm').format(DateTime.now());
  int selectedValue;
  showPicker() {}

  @override
  Widget build(BuildContext context) {
    print('hour $hour1');
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('ы'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(top: mediaQuery.size.height / 20),
                  child: Text(hour1, style: TextStyle(fontSize: 30)),
                ),
                Container(
                  padding: EdgeInsets.only(top: mediaQuery.size.height / 20),
                  child: Text(minute1, style: TextStyle(fontSize: 30)),
                ),
                Container(
                  padding: EdgeInsets.only(top: mediaQuery.size.height / 20),
                  child: Text(hour2, style: TextStyle(fontSize: 30)),
                ),
                Container(
                  padding: EdgeInsets.only(top: mediaQuery.size.height / 20),
                  child: Text(minute2, style: TextStyle(fontSize: 30)),
                ),
              ],
            ),
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
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Picker(this.callbackh1),
                  Picker(this.callbackm1),
                  Text(':'),
                  Picker(this.callbackh2),
                  Picker(this.callbackm2),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: mediaQuery.size.height / 20),
              child: FlatButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                color: Colors.deepPurple,
                onPressed: () {
                  setState(() {});
                },
                child: Text(
                  'Изменить ночное время',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
