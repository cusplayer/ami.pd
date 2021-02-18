import 'dart:math';

import 'package:ami/models/activity.dart';
import 'package:flutter/material.dart';

import '../helpers/db_helper.dart';

class TimePicker extends StatefulWidget {
  final Activity _act;
  TimePicker(this._act);
  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  // List<Activity> _activities = [
  //   Activity(
  //       id: 'gd1ghghgfh',
  //       name: '1',
  //       title: 'Спать',
  //       start: 1613583148,
  //       end: 1613583255),
  // ];
  final _nameController = TextEditingController();
  Activity sleep;
  String activityName;
  TimeOfDay _firstTime;
  TimeOfDay _secondTime;
  final now = new DateTime.now();
  void _presentDatePicker(time) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
      helpText: 'Выберите время',
      cancelText: 'Выйти',
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      if (time == 1) {
        setState(() {
          _firstTime = pickedDate;
        });
      } else if (time == 2) {
        setState(() {
          _secondTime = pickedDate;
        });
      }
    });
  }

  void _setValue() {
    DateTime dayNow = DateTime.now();
    setState(() {
      sleep = Activity(
        id: Random().nextInt(4294967296).toString(),
        name: activityName,
        title: 'Сколько вы спали',
        start: DateTime(dayNow.year, dayNow.month, dayNow.day, _firstTime.hour,
                _firstTime.minute)
            .millisecondsSinceEpoch,
        end: DateTime(dayNow.year, dayNow.month, dayNow.day, _secondTime.hour,
                _secondTime.minute)
            .millisecondsSinceEpoch,
      );
      // _activities.add(sleep);
    });
    DBHelper.insert('activities', {
      'id': sleep.id,
      'name': sleep.name,
      'title': sleep.title,
      'start': sleep.start,
      'end': sleep.end
    });
    // print('Сон ${_activities[1].title}');
  }

  // Future<void> fetchAndSet() async {
  //   final datalist = await DBHelper.getData('activities');
  //   _act = datalist
  //       .map((activity) => Activity(
  //           id: activity['id'],
  //           name: activity['name'],
  //           title: activity['title'],
  //           start: activity['start'],
  //           end: activity['end']))
  //       .toList();
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextField(
            style: TextStyle(fontSize: 13),
            decoration: InputDecoration(labelText: 'Name'),
            controller: _nameController,
            onSubmitted: (_) => (activityName = _nameController.text),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 18,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: GestureDetector(
                    onTap: () => _presentDatePicker(1),
                    child: _firstTime != null
                        ? Text('${_firstTime.format(context)}')
                        : Text('Начальное время'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: GestureDetector(
                    onTap: () => _presentDatePicker(2),
                    child: _secondTime != null
                        ? Text('${_secondTime.format(context)}')
                        : Text('Конечное время'),
                  ),
                ),
                _secondTime != null && _firstTime != null
                    ? FloatingActionButton(
                        onPressed: () => {
                          _setValue(),
                          // fetchAndSet().then(
                          //   (_) => {
                          //     for (var a in _act)
                          //       {
                          //         print('fff ${a.name}'),
                          //       }
                          //   },
                          // ),
                        },
                        child: Icon(Icons.check),
                      )
                    : SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
