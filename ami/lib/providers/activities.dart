import 'package:ami/helpers/db_helper.dart';
import 'package:ami/models/date.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../models/activity.dart';

class Activities with ChangeNotifier {
  List<Activity> _activities = [];

  final commentWidgets = <Widget>[];
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  Date date1 = Date(
      DateTime.now(), null, DateFormat('yyyy-MM-dd').format(DateTime.now()));
  var time = DateFormat('HH:mm').format(DateTime.now());
  DateTime initialDate = DateTime.now();
  double rotation = 0.0;
  bool subtract = false;
  bool add = false;
  Activity night = Activity(
      id: 'night',
      name: 'Сон',
      start: 0.8,
      end: 0.2,
      color: 'Color(0xff214883)',
      isDone: 0,
      date: 'all',
      serial: 10);
  ScrollPhysics physics = ScrollPhysics();

  late List<Activity> sortedActivities;

  List<Activity> get activities {
    return [..._activities];
  }

  bool isEditable = false;

  void tomorrow() {
    add = true;
    editDate();
  }

  void yesterday() {
    subtract = true;
    editDate();
  }

  void setNight(double start, double end) {
    night = Activity(
        id: night.id,
        name: night.name,
        start: start,
        end: end,
        color: night.color,
        isDone: night.isDone,
        date: night.date,
        serial: night.serial);
    notifyListeners();
  }

  Future<void> updateRotation(newRotation) async {
    if (newRotation < 1) {
      newRotation = newRotation + 1;
    }
    if (newRotation > 1) {
      newRotation = newRotation - 1;
    }
    rotation = newRotation;
    physics = NeverScrollableScrollPhysics();
    notifyListeners();
  }

  void scrollablePhysics() {
    physics = AlwaysScrollableScrollPhysics();
    notifyListeners();
  }

  isCurrentTime(start, end) {
    if (start != 2) {
      var _time = DateFormat('HH:mm').format(DateTime.now()).split(':');
      double _reverseRotation = 1 - rotation;
      double _relativeTimeDirty = int.parse(_time[0]) / 24 +
          int.parse(_time[1]) / 60 / 24 +
          _reverseRotation;
      var _relativeTime =
          _relativeTimeDirty < 1 ? _relativeTimeDirty : _relativeTimeDirty - 1;
      print('start: ' + start.toString() + ' end: ' + end.toString());
      print('rotation ' + rotation.toString());
      print('relativeTime ' + _relativeTime.toString());
      if (end != 2) {
        if (start < end) {
          if (_relativeTime > start && _relativeTime < end) {
            return true;
          }
        } else {
          if (_relativeTime > start || _relativeTime < end) {
            return true;
          }
        }
      } else {
        if (_relativeTime * 0.998 < start && _relativeTime * 1.002 > start) {
          return true;
        }
      }
    }
    return false;
  }

  getRotation() {
    var time = DateFormat('HH:mm').format(DateTime.now()).split(':');
    var angle = int.parse(time[0]) / 24 + int.parse(time[1]) / 60 / 24;
    return angle;
  }

  void editDate() {
    initializeDateFormatting();
    DateFormat formatterView = DateFormat.MMMd('ru');
    if (subtract) {
      date1.date = date1.date.subtract(Duration(days: 1));
      date1.dateLocalView = formatterView.format(date1.date);
      date1.dateView = formatter.format(date1.date);
      subtract = false;
      _activities = [];
      notifyListeners();
      fetchAndSet();
    } else if (add) {
      date1.date = date1.date.add(Duration(days: 1));
      date1.dateLocalView = formatterView.format(date1.date);
      date1.dateView = formatter.format(date1.date);
      add = false;
      _activities = [
        Activity(
            id: '',
            name: 'name',
            start: 0,
            end: 0,
            color: '',
            isDone: null,
            date: '',
            serial: null)
      ];
      notifyListeners();
      fetchAndSet();
    }
    notifyListeners();
  }

  Future refreshTime() async {
    time = DateFormat('HH:mm').format(DateTime.now());
    rotation = 0.0;
    notifyListeners();
  }

  void addTime(double timeToAdd) {
    var temporaryTime = DateTime.now().subtract(Duration(
        hours: (timeToAdd ~/ (1 / 24)),
        minutes: ((timeToAdd % (1 / 24)) * 1442).toInt()));
    time = DateFormat('HH:mm').format(temporaryTime);
    sortSerial();
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

  void changeEditable() {
    isEditable = !isEditable;
    notifyListeners();
  }

  getDateView() {
    initializeDateFormatting();
    DateFormat formatterView = DateFormat.MMMd('ru');
    this.date1.dateLocalView == null
        ? this.date1.dateLocalView = formatterView.format(DateTime.now())
        : null;
    print('localView + ${this.date1.dateLocalView}');
    if (this.date1.dateLocalView == formatterView.format(DateTime.now())) {
      this.date1.dateLocalView = 'Сегодня';
    }
    return this.date1.dateLocalView;
  }

  void updateDate(newDate) {
    DateFormat formatterView = DateFormat.MMMd('ru');
    initialDate = newDate;
    this.date1.dateView = formatter.format(newDate);
    this.date1.dateLocalView = formatterView.format(newDate);
    this.date1.date = newDate;
    calendar();
    fetchAndSet();
    // refreshTime();
    notifyListeners();
  }

  presentDatePicker(context, initialDate, dateCallback) async {
    showDatePicker(
            helpText: '',
            context: context,
            locale: const Locale("ru", "RU"),
            initialDate: initialDate,
            firstDate: DateTime.now().subtract(const Duration(days: 5000)),
            lastDate: DateTime.now().add(const Duration(days: 365)))
        .then((pickedDate) {
      if (pickedDate != null) {
        return dateCallback(pickedDate);
      }
    });
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
              date: activity['date'],
              serial: 0),
        )
        .toList();
    _activities.removeWhere((activity) => (activity.date) != initialDate);
    notifyListeners();
  }

  void sortActivities() {
    _activities.sort((a, b) => a.start.compareTo(b.start));
    // _activities.sort((a, b) => a.serial!.compareTo(b.serial!));
  }

  void sortSerial() {
    _activities.sort((a, b) => a.serial!.compareTo(b.serial!));
    for (int i = 0; i < _activities.length; i++) {
      _activities[i].serial = i;
      DBHelper.update('activities', {'serial': i}, _activities[i].id);
    }
    notifyListeners();
  }

  void changePosition(oldIndex, newIndex) {
    if (oldIndex < newIndex) {
      for (var activity in _activities) {
        if (activity.serial! >= newIndex) {
          activity.serial = activity.serial! + 1;
        }
      }
      if (newIndex + 1 >= _activities.length) {
        _activities.add(Activity(
            id: _activities[oldIndex].id,
            name: _activities[oldIndex].name,
            start: _activities[oldIndex].start,
            end: _activities[oldIndex].end,
            color: _activities[oldIndex].color,
            isDone: _activities[oldIndex].isDone,
            date: _activities[oldIndex].date,
            serial: newIndex + 1));
        _activities.removeWhere((element) => element.serial == oldIndex);
      } else
        _activities[oldIndex].serial = _activities[newIndex + 1].serial;
    } else {
      var oldActivity = _activities[oldIndex];
      _activities.removeAt(oldIndex);
      for (var activity in _activities) {
        if (activity.serial! >= newIndex) {
          activity.serial = activity.serial! + 1;
        }
      }
      oldActivity.serial = newIndex;
      _activities.add(oldActivity);
    }
    sortSerial();
  }

  void addActivity(
      String id, String name, num start, num end, Color color, String date) {
    final newActivity = Activity(
        id: id,
        name: name,
        start: start,
        end: end,
        color: color.toString(),
        isDone: 0,
        date: date,
        serial: 0);
    notifyListeners();
    DBHelper.insert('activities', {
      'id': newActivity.id,
      'name': newActivity.name,
      'start': newActivity.start,
      'end': newActivity.end,
      'color': newActivity.color,
      'isDone': 0,
      'date': newActivity.date,
      'serial': 0
    });
    fetchAndSet();
    refreshTime();
  }

  void editActivity(String id, String name, num start, num end, Color color,
      int isDone, String date) {
    DBHelper.update(
        'activities',
        {
          'id': id,
          'name': name,
          'start': start,
          'end': end,
          'color': color.toString(),
          'isDone': isDone,
          'date': date
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
    _activities
        .removeWhere((activity) => (activity.date) != this.date1.dateView);
  }

  Future isAllowed(num activityStart, num activityEnd, id) async {
    var isAllowedVar = true;
    if (activityStart != 2) {
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
    }
    return isAllowedVar;
  }

  Future<void> fetchAndSet() async {
    final datalist = await DBHelper.getData('activities');
    _activities = datalist
        .map((activity) => Activity(
            id: activity['id'],
            name: activity['name'],
            start: activity['start'],
            end: activity['end'],
            color: activity['color'],
            isDone: activity['isDone'],
            date: activity['date'],
            serial: activity['serial']))
        .toList();
    calendar();
    sortActivities();
    sortSerial();
    notifyListeners();
  }
}
