import 'package:ami/helpers/db_helper.dart';
import 'package:ami/models/activity.dart';
import 'package:ami/widgets/time_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WidgetList extends StatefulWidget {
  final List<String> items;

  WidgetList({Key key, @required this.items}) : super(key: key);

  @override
  _WidgetListState createState() => _WidgetListState();
}

class _WidgetListState extends State<WidgetList> {
  List<Activity> _act = [];

  Future<void> fetchAndSet() async {
    final datalist = await DBHelper.getData('activities');
    _act = datalist
        .map((activity) => Activity(
            id: activity['id'],
            name: activity['name'],
            title: activity['title'],
            start: activity['start'],
            end: activity['end']))
        .toList();
  }

  bool counter = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchAndSet(),
        builder: (context, snapshot) => ListView.builder(
              itemCount: _act.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(20, 136, 204, 100),
                      Color.fromRGBO(43, 50, 178, 100)
                    ]),
                  ),
                  height: counter ? 200 : 50,
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.height / 100),
                  margin:
                      EdgeInsets.all(MediaQuery.of(context).size.height / 1000),
                  child: !counter
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              Container(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width /
                                          10),
                                  child: _act[index].name != null
                                      ? Text(_act[index].name)
                                      : Text('Нет данных')),
                              FloatingActionButton(
                                backgroundColor:
                                    Color.fromRGBO(43, 50, 178, 100),
                                child: Icon(Icons.keyboard_arrow_down),
                                onPressed: () {
                                  setState(() {
                                    counter = !counter;
                                  });
                                },
                              )
                            ])
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: TimePicker(_act[index]),
                            ),
                            FloatingActionButton(
                              backgroundColor: Color.fromRGBO(43, 50, 178, 100),
                              child: Icon(Icons.keyboard_arrow_up),
                              onPressed: () {
                                setState(() {
                                  counter = !counter;
                                });
                              },
                            )
                          ],
                        ),
                );
              },
            ));
  }
}
