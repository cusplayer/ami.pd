import 'package:ami/models/activity.dart';
import 'package:ami/providers/activities.dart';
import 'package:ami/screens/add_screen.dart';
import 'package:ami/widgets/diagram/activity_arc.dart';
import 'package:ami/widgets/common_picker.dart';
import 'package:ami/widgets/diagram/day_container.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list_interface.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/cupertino.dart';
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
  List<DragAndDropList> _contents = [];
  late List<Activity> _activities;

  void callbackA(double ns1, double ne1) {
    setState(() {
      this.activityStart = ns1;
      this.activityEnd = ne1;
    });
  }

  void _presentDatePicker() {
    showDatePicker(
            helpText: '',
            context: context,
            locale: const Locale("ru", "RU"),
            initialDate: Provider.of<Activities>(this.context, listen: false)
                .initialDate,
            firstDate: DateTime(2020),
            lastDate: DateTime.now().add(const Duration(days: 365)))
        .then((pickedDate) {
      if (pickedDate != null) {
        Provider.of<Activities>(this.context, listen: false)
            .updateDate(pickedDate);
      }
    });
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    // setState(() {
    //   var movedItem = _contents[oldListIndex].children.removeAt(oldItemIndex);
    //   _contents[newListIndex].children.insert(newItemIndex, movedItem);
    // });
    Provider.of<Activities>(this.context, listen: false)
        .changePosition(oldItemIndex, newItemIndex);
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    // Provider.of<Activities>(this.context, listen: false)
    //     .changePosition(oldListIndex, newListIndex);
    // setState(() {
    //   var movedList = _contents.removeAt(oldListIndex);
    //   _contents.insert(newListIndex, movedList);
    // });
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
                        child: const Text(''),
                      ),
                      builder: (context, activities, ch) => RefreshIndicator(
                        onRefresh: () =>
                            Provider.of<Activities>(this.context, listen: false)
                                .refreshTime(),
                        child: SingleChildScrollView(
                          child: Center(
                            child: Column(children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: mediaQuery.size.height / 15),
                                child: Text(
                                    Provider.of<Activities>(this.context,
                                            listen: false)
                                        .time,
                                    style: TextStyle(fontSize: 40)),
                              ),
                              Container(
                                child: DayContainer(
                                    mediaQuery,
                                    Provider.of<Activities>(this.context,
                                            listen: true)
                                        .sortForArc(activities.activities)),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top:
                                        MediaQuery.of(context).size.width / 50),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Spacer(),
                                    TextButton(
                                      onPressed: _presentDatePicker,
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
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
                                  padding: EdgeInsets.all(0),
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  child: DragAndDropLists(
                                    contentsWhenEmpty: Text(''),
                                    itemSizeAnimationDurationMilliseconds: 0,
                                    listPadding: EdgeInsets.all(0),
                                    children: _contents = [
                                      DragAndDropList(
                                        contentsWhenEmpty: Text(''),
                                        canDrag: false,
                                        children: <DragAndDropItem>[
                                          for (var i = 0;
                                              i < activities.activities.length;
                                              i++)
                                            DragAndDropItem(
                                              canDrag: activities.activities[i]
                                                          .start ==
                                                      2 &&
                                                  Provider.of<Activities>(
                                                          this.context,
                                                          listen: false)
                                                      .isDraggable &&
                                                  Provider.of<Activities>(
                                                          this.context,
                                                          listen: false)
                                                      .isEditable,
                                              child: CommonPicker(mediaQuery,
                                                  activities.activities[i]),
                                            ),
                                        ],
                                      )
                                    ],
                                    onItemReorder: _onItemReorder,
                                    onListReorder: _onListReorder,
                                  )),
                              // Container(
                              //   height: MediaQuery.of(context).size.height / 2,
                              //   child: SingleChildScrollView(
                              //     physics: ScrollPhysics(),
                              //     child: Column(
                              //       children: <Widget>[
                              //         ListView.builder(
                              //             padding: EdgeInsets.all(0),
                              //             physics: ScrollPhysics(),
                              //             shrinkWrap: true,
                              //             itemCount:
                              //                 activities.activities.length,
                              //             itemBuilder: (context, index) {
                              //               return CommonPicker(mediaQuery,
                              //                   activities.activities[index]);
                              //             }),
                              //         SizedBox(
                              //           height:
                              //               MediaQuery.of(context).size.height /
                              //                   2,
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ), //Developer button
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
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 1.12,
              left: MediaQuery.of(context).size.width / 1.25,
              child: Transform.scale(
                scale: 1.2,
                child: FloatingActionButton(
                  onPressed: () =>
                      // Provider.of<Activities>(this.context, listen: false)
                      //     .returnAdd(),
                      showModalBottomSheet(
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
                  child: Transform.scale(scale: 1.5, child: Icon(Icons.add)),
                ),
              ),
            ),
            ...Provider.of<Activities>(this.context, listen: false)
                .commentWidgets,
          ],
        ));
  }
}
