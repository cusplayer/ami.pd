import 'package:ami/helpers/db_helper.dart';
import 'package:ami/screens/add_screen.dart';
import 'package:ami/screens/edit_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../models/activity.dart';

class Activities with ChangeNotifier {
  List<Activity> _activities = [];

  final commentWidgets = <Widget>[];
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  DateFormat formatterView = DateFormat('MMMd');
  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String dateView = DateFormat('MMMd').format(DateTime.now());
  var time = DateFormat('HH:mm').format(DateTime.now());

  late List<Activity> sortedActivities;

  List<Activity> get activities {
    return [..._activities];
  }

  bool isEditable = false;

  // void clear() {
  //   commentWidgets.clear();
  //   notifyListeners();
  // }

  Future refreshTime() async {
    time = DateFormat('HH:mm').format(DateTime.now());
    notifyListeners();
  }

  int sortFunction(a, b) {
    if (a == 2 && b == 2 || a != 2 && b != 2) {
      return 0;
    } else if (a == 2 && b != 2) {
      return 1;
    } else {
      return -1;
    }
  }

  List<Activity> sortForArc(activity) {
    activity.sort((a, b) => sortFunction(a.end, b.end));
    return activity;
  }

  // void returnAdd() {
  //   if (commentWidgets.isEmpty) {
  //     commentWidgets.add(AddScreen());
  //   }
  //   notifyListeners();
  // }

  // void returnEdit(activity) {
  //   if (commentWidgets.isEmpty) {
  //     commentWidgets.add(EditScreen(activity));
  //   }
  //   notifyListeners();
  // }

  void changeEditable() {
    isEditable = !isEditable;
    notifyListeners();
  }

  void updateDate(newDate) {
    this.date = formatter.format(newDate);
    this.dateView = formatterView.format(newDate);
    calendar();
    fetchAndSet();
    refreshTime();
    notifyListeners();
  }

  void sortActivities() {
    _activities.sort((a, b) => a.start.compareTo(b.start));
  }

  void addActivity(String id, String name, num start, num end, Color color) {
    final newActivity = Activity(
        id: id,
        name: name,
        start: start,
        end: end,
        color: color.toString(),
        isDone: 0);
    notifyListeners();
    DBHelper.insert('activities', {
      'id': newActivity.id,
      'name': newActivity.name,
      'start': newActivity.start,
      'end': newActivity.end,
      'color': newActivity.color,
      'isDone': 0
    });
    fetchAndSet();
    refreshTime();
  }

  void editActivity(
      String id, String name, num start, num end, Color color, int isDone) {
    DBHelper.update(
        'activities',
        {
          'id': id,
          'name': name,
          'start': start,
          'end': end,
          'color': color.toString(),
          'isDone': isDone
        },
        id);
    refreshTime();
    fetchAndSet();
    notifyListeners();
  }

  void deleteActivity(String id) {
    _activities.removeWhere((act) => act.id == id);
    DBHelper.delete(id);
    refreshTime();
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
        if (activityEnd != 2) {
          if (element.end != 2) {
            if (element.start > element.end) {
              if (activityStart > element.start ||
                  activityEnd > element.start ||
                  activityStart < element.end ||
                  activityEnd < element.end ||
                  (activityStart < element.start &&
                      activityEnd > element.end &&
                      activityStart > activityEnd) ||
                  activityStart == element.start) {
                isAllowedVar = false;
              }
            } else if (element.start < element.end) {
              if (activityStart > element.start &&
                      activityStart < element.end ||
                  activityEnd < element.end && activityEnd > element.start ||
                  (activityStart < element.start &&
                      activityEnd > element.end) ||
                  activityStart == element.start) {
                isAllowedVar = false;
              }
            }
          } else {
            if (activityStart < activityEnd) {
              if (activityStart < element.start &&
                  activityEnd > element.start) {
                isAllowedVar = false;
              }
            }
            if (activityStart > activityEnd) {
              if (activityStart < element.start ||
                  element.start < activityEnd) {
                isAllowedVar = false;
              }
            }
          }
        } else {
          if (element.end != 2) {
            if (element.start < element.end) {
              if (activityStart > element.start &&
                  activityStart < element.end) {
                isAllowedVar = false;
              }
            } else {
              if (activityStart > element.start ||
                  activityStart < element.end) {
                isAllowedVar = false;
              }
            }
          } else {
            if (element.start == activityStart) {
              isAllowedVar = false;
            }
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
            isDone: activity['isDone'],
          ),
        )
        .toList();
    _activities.removeWhere((activity) =>
        (activity.id.substring(activity.id.indexOf(' ') + 1)) != date);
    sortActivities();
    notifyListeners();
  }
}
