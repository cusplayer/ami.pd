import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Midnight extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY) * 0.9;
    var time = DateFormat('HH:mm').format(DateTime.now()).split(':');
    var angle = int.parse(time[0]) / 24 + int.parse(time[1]) / 60 / 24;
    var shift = angle * pi * 2;
    final midnightPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30.0;

    canvas.drawArc(
        new Rect.fromCenter(
            center: center, width: radius * 2, height: radius * 2),
        shift + pi,
        ((2 * pi * (0.01)) < 0)
            ? (2 * pi * (0.01) + pi * 2)
            : (2 * pi * (0.01)),
        false,
        midnightPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
