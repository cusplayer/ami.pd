import 'package:ami/helpers/db_helper.dart';
import 'package:ami/screens/add_screen.dart';
import 'package:ami/screens/edit_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../models/activity.dart';

class Activities with ChangeNotifier {
  List<Activity> _activities = [];
  final commentWidgets = <Widget>[];

  DateFormat formatter = DateFormat('yyyy-MM-dd');

  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());

  List<Activity> get activities {
    return [..._activities];
  }

  bool isEditable = false;

  void clear() {
    commentWidgets.clear();
    notifyListeners();
  }

  void returnAdd() {
    if (commentWidgets.isEmpty) {
      commentWidgets.add(AddScreen());
    }
    notifyListeners();
  }

  void returnEdit(activity) {
    if (commentWidgets.isEmpty) {
      commentWidgets.add(EditScreen(activity));
    }
    notifyListeners();
  }

  void changeEditable() {
    isEditable = !isEditable;
    notifyListeners();
  }

  void updateDate(newDate) {
    this.date = formatter.format(newDate);
    calendar();
    fetchAndSet();
    notifyListeners();
  }

  void addActivity(String id, String name, num start, num end, Color color) {
    final newActivity = Activity(
        id: id, name: name, start: start, end: end, color: color.toString());
    // if ((_activities.contains((el) => el.id == newActivity.id))) {
    //   _activities.add(newActivity);
    // }
    notifyListeners();
    DBHelper.insert('activities', {
      'id': newActivity.id,
      'name': newActivity.name,
      'start': newActivity.start,
      'end': newActivity.end,
      'color': newActivity.color
    });
    fetchAndSet();
  }

  void editActivity(String id, String name, num start, num end, Color color) {
    DBHelper.update(
        'activities',
        {
          'id': id,
          'name': name,
          'start': start,
          'end': end,
          'color': color.toString()
        },
        id);
    fetchAndSet();
    notifyListeners();
  }

  void deleteActivity(String id) {
    _activities.removeWhere((act) => act.id == id);
    DBHelper.delete(id);
    notifyListeners();
  }

  void calendar() {
    _activities.removeWhere((activity) =>
        (activity.id.substring(activity.id.indexOf(' ') + 1)) != date);
  }

  Future isAllowed(num activityStart, num activityEnd, id) async {
    var isAllowedVar = true;
    _activities.forEach((element) {
      if (id != element.id) {
        if (element.start > element.end) {
          if (activityStart > element.start ||
              activityEnd > element.start ||
              activityStart < element.end ||
              activityEnd < element.end ||
              (activityStart < element.start &&
                  activityEnd > element.end &&
                  activityStart > activityEnd)) {
            isAllowedVar = false;
          }
        } else if (element.start < element.end) {
          if (activityStart > element.start && activityStart < element.end ||
              activityEnd < element.end && activityEnd > element.start ||
              (activityStart < element.start && activityEnd > element.end)) {
            isAllowedVar = false;
          }
        }
      }
    });
    return isAllowedVar;
  }

  Future<void> fetchAndSet() async {
    final datalist = await DBHelper.getData('activities');
    _activities = datalist
        .map(
          (activity) => Activity(
            id: activity['id'],
            name: activity['name'],
            start: activity['start'],
            end: activity['end'],
            color: activity['color'],
          ),
        )
        .toList();
    _activities.removeWhere((activity) =>
        (activity.id.substring(activity.id.indexOf(' ') + 1)) != date);
    notifyListeners();
  }
}
