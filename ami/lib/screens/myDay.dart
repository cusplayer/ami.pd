import 'package:ami/models/activity.dart';
import 'package:ami/widgets/dayWidget.dart';
import 'package:ami/widgets/element_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/db_helper.dart';

class MyDay extends StatefulWidget {
  @override
  _MyDayState createState() => _MyDayState();
}

class _MyDayState extends State<MyDay> {
  num nightStart1;
  num nightEnd1;
  var activityStart;
  var activityEnd;
  List<Activity> _act = [];
  Future<void> callbackN(num ns1, num ne1) async {
    setState(() {
      this.nightStart1 = ns1;
      this.nightEnd1 = ne1;
      DBHelper.insert('activities', {
        'id':
            'sleep ${DateTime.now().year} ${DateTime.now().month} ${DateTime.now().day}',
        'name': 'sleep',
        'start': ns1,
        'end': ne1
      }).then((_) async {
        final datalist = await DBHelper.getData('activities');
        _act = datalist
            .map(
              (activity) => Activity(
                id: activity['id'],
                name: activity['name'],
                start: activity['start'],
                end: activity['end'],
              ),
            )
            .toList();
        print('ы ${_act[2].id}');
      });
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
    // print()
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
            ElementPicker(mediaQuery, this.callbackN),
            ElementPicker(mediaQuery, this.callbackA),
            // FlatButton(
            //     onPressed: () {
            //       Navigator.of(context).pushNamed('/day');
            //     },
            //     child: Text('э'))
          ]),
        ),
      ),
    );
  }
}
