import 'package:ami/models/activity.dart';
import 'package:ami/providers/activities.dart';
import 'package:ami/screens/add_screen.dart';
import 'package:ami/utils/present_date_picker.dart';
import 'package:ami/widgets/diagram/day_container.dart';
import 'package:ami/widgets/drag_and_drop.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class MyDay extends StatefulWidget {
  @override
  _MyDayState createState() => _MyDayState();
}

class _MyDayState extends State<MyDay> {
  late num nightStart1;
  late num nightEnd1;
  var activityStart;
  var activityEnd;
  List<Widget> widgetList = [];
  late Future fetchAndSetFuture;
  late List<Activity> _activities;

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
    fetchAndSetFuture =
        Provider.of<Activities>(context, listen: false).fetchAndSet();
    super.initState();
  }

  late MediaQueryData mediaQuery;
  late int selectedValue;

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
        future: fetchAndSetFuture,
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Consumer<Activities>(
                builder: (context, activities, ch) => RefreshIndicator(
                  onRefresh: () =>
                      Provider.of<Activities>(this.context, listen: false)
                          .refreshTime(),
                  child: SingleChildScrollView(
                    physics:
                        Provider.of<Activities>(this.context, listen: false)
                            .physics,
                    child: Center(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: mediaQuery.size.height / 15),
                            child: Text(
                                Provider.of<Activities>(this.context,
                                        listen: false)
                                    .time,
                                style: TextStyle(fontSize: 30)),
                          ),
                          DayContainer(
                              mediaQuery,
                              activities.activities.length != 0
                                  ? activities.activities[0].id != ''
                                      ? Provider.of<Activities>(this.context,
                                              listen: true)
                                          .sortForArc(activities.activities)
                                      : []
                                  : []),
                          Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width / 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Spacer(),
                                TextButton(
                                  onPressed: () => presentDatePicker(context),
                                  child: Text(
                                    Provider.of<Activities>(this.context,
                                            listen: true)
                                        .getDateView(),
                                    style: TextStyle(fontSize: 32),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: GestureDetector(
                                    child: Image(
                                      width: MediaQuery.of(context).size.width /
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
                          activities.activities.length != 0
                              ? activities.activities[0].id != ''
                                  ? DragAndDrop()
                                  : CircularProgressIndicator()
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
      floatingActionButton: Transform.scale(
        scale: 1.2,
        child: FloatingActionButton(
          onPressed: () => showModalBottomSheet(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              elevation: 20.0,
              context: context,
              builder: (BuildContext context) {
                return AddScreen();
              }),
          child: Transform.scale(scale: 2, child: Icon(Icons.add)),
        ),
      ),
    );
  }
}
