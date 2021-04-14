import 'package:ami/models/activity.dart';
import 'package:ami/providers/activities.dart';
import 'package:ami/screens/add_screen.dart';
import 'package:ami/widgets/activity_arc.dart';
import 'package:ami/widgets/common_picker.dart';
import 'package:ami/widgets/day_container.dart';
import 'package:ami/widgets/element_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'package:sliding_up_panel/sliding_up_panel.dart';

class MyDay extends StatefulWidget {
  @override
  _MyDayState createState() => _MyDayState();
}

class _MyDayState extends State<MyDay> {
  num nightStart1;
  num nightEnd1;
  var activityStart;
  var activityEnd;
  DateTime initialDate = DateTime.now();
  List<Widget> widgetList = [];
  Future fetchAndSetFuture;

  // Future<void> callbackN(num ns1, num ne1) async {
  //   setState(() {
  //     this.nightStart1 = ns1;
  //     this.nightEnd1 = ne1;
  //   });
  // }

  void callbackA(double ns1, double ne1) {
    setState(() {
      this.activityStart = ns1;
      this.activityEnd = ne1;
    });
  }

  listEl(Activity act) {
    return CustomPaint(
      painter: ActivityArc(
          act.start,
          act.end,
          Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(1.0)),
      size: Size(300, 300),
    );
  }

  void _presentDatePicker() {
    showDatePicker(
            helpText: '',
            context: context,
            locale: const Locale("ru", "RU"),
            initialDate: this.initialDate,
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
        this.initialDate = pickedDate;
        Provider.of<Activities>(this.context, listen: false)
            .updateDate(pickedDate);
      }
    });
  }

  @override
  void initState() {
    this.nightStart1 = 0.0;
    this.nightEnd1 = 0.0;
    this.activityStart = 0.0;
    this.activityEnd = 0.0;
    fetchAndSetFuture =
        Provider.of<Activities>(context, listen: false).fetchAndSet();

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
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            FutureBuilder(
              future: fetchAndSetFuture,
              builder: (context, snapshot) => snapshot.connectionState ==
                      ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : Consumer<Activities>(
                      child: Center(
                        child: const Text('ниче нет'),
                      ),
                      builder: (context, activities, ch) =>
                          SingleChildScrollView(
                        child: Center(
                          child: Column(children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: mediaQuery.size.height / 15),
                              child: Text(time, style: TextStyle(fontSize: 40)),
                            ),
                            DayContainer(
                                mediaQuery,
                                Provider.of<Activities>(this.context,
                                        listen: true)
                                    .sortForArc(activities.activities)),
                            Container(
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.width / 50),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Spacer(),
                                  TextButton(
                                    onPressed: _presentDatePicker,
                                    child: Text(
                                      Provider.of<Activities>(this.context,
                                              listen: true)
                                          .dateView,
                                      style: TextStyle(fontSize: 32),
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    padding: EdgeInsets.only(bottom: 4),
                                    child: GestureDetector(
                                      child: Image(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                15,
                                        image: AssetImage(
                                            'assets/images/vector.png'),
                                      ),
                                      onTap: () => Provider.of<Activities>(
                                              this.context,
                                              listen: false)
                                          .changeEditable(),
                                    ),
                                  ),
                                  Spacer(
                                    flex: 20,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 2,
                              child: SingleChildScrollView(
                                physics: ScrollPhysics(),
                                child: Column(
                                  children: <Widget>[
                                    ListView.builder(
                                        padding: EdgeInsets.all(0),
                                        physics: ScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: activities.activities.length,
                                        itemBuilder: (context, index) {
                                          return CommonPicker(mediaQuery,
                                              activities.activities[index]);
                                        }),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2,
                                    ),
                                  ],
                                ),
                              ),
                            ), //Developer button
                            // ElementPicker(mediaQuery, this.callbackA),
                            // FlatButton(
                            //     onPressed: () {
                            //       Navigator.of(context).pushNamed('/day');
                            //     },
                            //     child: Text('э'))
                          ]),
                        ),
                      ),
                    ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 1.12,
              left: MediaQuery.of(context).size.width / 1.25,
              child: FloatingActionButton(
                onPressed: () =>
                    Provider.of<Activities>(this.context, listen: false)
                        .returnAdd(),
                child: Icon(Icons.add),
              ),
            ),
            ...Provider.of<Activities>(this.context, listen: false)
                .commentWidgets,
          ],
        ));
  }
}
