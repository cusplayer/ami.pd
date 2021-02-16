import 'package:flutter/material.dart';

class Activity {
  final String id;
  final String title;
  final DateTimeRange time;

  const Activity({@required this.id, @required this.title, this.time});
}
