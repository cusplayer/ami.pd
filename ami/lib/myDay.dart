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
  var nightStart1;
  var nightEnd1;
  var isNight = false;
  @override
  void initState() {
    this.nightStart1 = double.parse(hour1) / 24 + double.parse(minute1) / 1440;
    this.nightEnd1 = double.parse(hour2) / 24 + double.parse(minute2) / 1440;
    super.initState();
  }

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
            Container(
              padding: EdgeInsets.only(top: mediaQuery.size.height / 40),
              child: Text(time, style: TextStyle(fontSize: 30)),
            ),
            Container(
              padding: EdgeInsets.only(top: mediaQuery.size.height / 40),
              child: InteractiveViewer(
                child: CustomPaint(
                  painter: DayWidget(this.nightStart1, this.nightEnd1),
                  size: Size(300, 300),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: mediaQuery.size.height / 30),
                color: Colors.blue,
                child: isNight
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Изменить ночное время',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              FloatingActionButton(
                                  child: Icon(Icons.expand_less),
                                  backgroundColor: Colors.lightBlue,
                                  onPressed: () {
                                    setState(() {
                                      this.isNight = !this.isNight;
                                    });
                                  }),
                            ],
                          ),
                          Container(
                            height: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Picker(this.callbackh1, true),
                                Picker(this.callbackm1, false),
                                Text(':'),
                                Picker(this.callbackh2, true),
                                Picker(this.callbackm2, false),
                              ],
                            ),
                          ),
                          FlatButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0)),
                            color: Colors.deepPurple,
                            onPressed: () {
                              setState(() {
                                this.nightStart1 = double.parse(hour1) / 24 +
                                    double.parse(minute1) / 1440;
                                this.nightEnd1 = double.parse(hour2) / 24 +
                                    double.parse(minute2) / 1440;
                              });
                            },
                            child: Text(
                              'Изменить',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Изменить ночное время',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          FloatingActionButton(
                              child: Icon(Icons.expand_more),
                              onPressed: () {
                                setState(() {
                                  this.isNight = !this.isNight;
                                });
                              }),
                        ],
                      )),
            Container(
              padding: EdgeInsets.only(top: mediaQuery.size.height / 20),
            ),
          ]),
        ),
      ),
    );
  }
}
