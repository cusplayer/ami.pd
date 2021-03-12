import 'package:ami/helpers/db_helper.dart';
import 'package:flutter/foundation.dart';

import '../models/activity.dart';

class Activities with ChangeNotifier {
  List<Activity> _activities = [
    Activity(id: 'id', name: 'name', start: 0, end: 1)
  ];

  List<Activity> get activities {
    return [..._activities];
  }

  void addActivity(String id, String name, num start, num end) {
    final newActivity = Activity(id: id, name: name, start: start, end: end);
    // if ((_activities.contains((el) => el.id == newActivity.id))) {
    //   _activities.add(newActivity);
    // }
    notifyListeners();
    DBHelper.insert('activities', {
      'id': newActivity.id,
      'name': newActivity.name,
      'start': newActivity.start,
      'end': newActivity.end
    });
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
          ),
        )
        .toList();
    notifyListeners();
  }
}
