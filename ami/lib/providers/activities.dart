import 'package:ami/helpers/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../models/activity.dart';

class Activities with ChangeNotifier {
  List<Activity> _activities = [];

  DateFormat formatter = DateFormat('yyyy-MM-dd');

  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());

  List<Activity> get activities {
    return [..._activities];
  }

  void updateDate(newDate) {
    this.date = formatter.format(newDate);
    notifyListeners();
    print(date);
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
    notifyListeners();
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
  }

  void deleteActivity(String id) {
    _activities.removeWhere((act) => act.id == id);
    DBHelper.delete(id);
    notifyListeners();
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
    notifyListeners();
  }
}
