import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivityArc extends CustomPainter {
  final double startActivity;
  final double endActivity;
  final Color color;
  const ActivityArc(this.startActivity, this.endActivity, this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final activityPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30.0;
    var time = DateFormat('HH:mm').format(DateTime.now()).split(':');
    var angle = int.parse(time[0]) / 24 + int.parse(time[1]) / 60 / 24;
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var shift = angle * pi * 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY) * 0.9;
    canvas.drawArc(
        new Rect.fromCenter(
            center: center, width: radius * 2, height: radius * 2),
        (startActivity * 2 * pi - pi / 2) - shift,
        ((2 * pi * (endActivity - startActivity)) < 0)
            ? (2 * pi * (endActivity - startActivity) + pi * 2)
            : (2 * pi * (endActivity - startActivity)),
        false,
        activityPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
