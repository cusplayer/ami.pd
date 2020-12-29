import 'package:ami/widgets/common_picker.dart';
import 'package:ami/widgets/dayWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyDay extends StatefulWidget {
  @override
  _MyDayState createState() => _MyDayState();
}

class _MyDayState extends State<MyDay> {
  var nightStart1;
  var nightEnd1;
  var activityStart;
  var activityEnd;
  void callbackN(double ns1, double ne1) {
    setState(() {
      this.nightStart1 = ns1;
      this.nightEnd1 = ne1;
    });
  }

  void callbackA(double ns1, double ne1) {
    setState(() {
      this.activityStart = ns1;
      this.activityEnd = ne1;
    });
  }

  @override
  void initState() {
    this.nightStart1 = 0.0;
    this.nightEnd1 = 0.0;
    this.activityStart = 0.0;
    this.activityEnd = 0.0;
    super.initState();
  }

  MediaQueryData mediaQuery;
  var time = DateFormat('HH:mm').format(DateTime.now());
  int selectedValue;
  showPicker() {}

  @override
  Widget build(BuildContext context) {
    print(this.nightStart1);
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('ы'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            Container(
              padding: EdgeInsets.only(top: mediaQuery.size.height / 40),
              child: Text(time, style: TextStyle(fontSize: 30)),
            ),
            Container(
              padding: EdgeInsets.only(top: mediaQuery.size.height / 40),
              child: InteractiveViewer(
                child: CustomPaint(
                  painter: DayWidget(this.nightStart1, this.nightEnd1,
                      this.activityStart, this.activityEnd),
                  size: Size(300, 300),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: mediaQuery.size.height / 30),
              decoration: BoxDecoration(
                color: Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: CommonPicker(
                  mediaQuery, this.callbackN, 'Изменить ночное время'),
            ),
            Container(
              margin: EdgeInsets.only(top: mediaQuery.size.height / 60),
              decoration: BoxDecoration(
                color: Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: CommonPicker(
                  mediaQuery, this.callbackA, 'Изменить время активности'),
            ),
          ]),
        ),
      ),
    );
  }
}
