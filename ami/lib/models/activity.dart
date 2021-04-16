import 'package:flutter/material.dart';

class Activity {
  final String id;
  final String name;
  final num start;
  final num end;
  final String color;
  final int isDone;

  const Activity({
    required this.id,
    required this.name,
    required this.start,
    required this.end,
    required this.color,
    required this.isDone,
  });
}
