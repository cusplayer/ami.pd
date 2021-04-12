import 'package:ami/models/activity.dart';
import 'package:ami/providers/activities.dart';
import 'package:ami/screens/add_screen.dart';
import 'package:ami/widgets/activity_arc.dart';
import 'package:ami/widgets/day_container.dart';
import 'package:ami/widgets/element_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class MyDay extends StatefulWidget {
  @override
  _MyDayState createState() => _MyDayState();
}

class _MyDayState extends State<MyDay> {
  num nightStart1;
  num nightEnd1;
  var activityStart;
  var activityEnd;
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
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      } else {
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
        appBar: AppBar(
          title: Text('ы'),
        ),
        body: FutureBuilder(
          future: fetchAndSetFuture,
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : Consumer<Activities>(
                  child: Center(
                    child: const Text('ниче нет'),
                  ),
                  builder: (context, activities, ch) => SingleChildScrollView(
                    child: Center(
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No date'),
                            TextButton(
                              onPressed: _presentDatePicker,
                              child: Text('Выберите дату'),
                            )
                          ],
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(top: mediaQuery.size.height / 40),
                          child: Text(time, style: TextStyle(fontSize: 30)),
                        ),
                        DayContainer(mediaQuery, activities),
                        Container(
                          height: MediaQuery.of(context).size.height / 2,
                          child: SingleChildScrollView(
                            physics: ScrollPhysics(),
                            child: Column(
                              children: <Widget>[
                                // Костыльная кнопка, чтобы удалять поломанные элементы
                                // FloatingActionButton(
                                //   onPressed: () {
                                //     Provider.of<Activities>(this.context,
                                //             listen: false)
                                //         .deleteActivity(
                                //             activities.activities[1].id);
                                //   },
                                //   child: Text('Тыкни'),
                                // ),
                                ListView.builder(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: activities.activities.length,
                                    itemBuilder: (context, index) {
                                      return ElementPicker(
                                          mediaQuery,
                                          // this.callbackN,
                                          activities.activities[index]);
                                    }),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                ),
                              ],
                            ),
                          ),
                        ), //Developer button
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed('/add-screen');
                          },
                          child: Icon(Icons.add),
                        ),
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
        ));
  }
}
