import 'package:flutter/material.dart';

class Activity {
  final String id;
  final String name;
  final String title;
  final int start;
  final int end;

  const Activity(
      {@required this.id,
      @required this.name,
      @required this.title,
      @required this.start,
      @required this.end});
}
