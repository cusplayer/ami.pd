import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
// import 'package:intl/intl_browser.dart';

class DayWidget extends CustomPainter {
  final double startNight;
  final double endNight;
  final double startActivity;
  final double endActivity;
  const DayWidget(
      this.startNight, this.endNight, this.startActivity, this.endActivity);
  @override
  void paint(Canvas canvas, Size size) {
    var time = DateFormat('HH:mm').format(DateTime.now()).split(':');
    print(DateTime.now());
    print(startNight);
    print(endNight);
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);
    var angle = int.parse(time[0]) / 24 + int.parse(time[1]) / 60 / 24;
    var shift = angle * pi * 2;
    var endPointX = (centerX + radius * cos((pi / 2 * 3) + (angle * pi * 2))) +
        15 * cos((pi / 2 * 3) + (angle * pi * 2));
    var endPointY = centerY +
        radius * sin((pi / 2 * 3) + (angle * pi * 2)) +
        15 * sin((pi / 2 * 3) + shift);
    var startPointX =
        centerX + (endPointX - centerX) - 30 * cos((pi / 2 * 3) + shift);
    var startPointY =
        centerY + (endPointY - centerY) - 30 * sin((pi / 2 * 3) + shift);
    var startPoint = Offset(startPointX, startPointY);
    final circlePaint = Paint()
      ..color = Color.fromRGBO(0, 188, 180, 1.0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30.0;
    final nightPaint = Paint()
      ..color = Color.fromRGBO(33, 72, 131, 1.0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30.0;
    final activityPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30.0;
    final trianglePaint = Paint()
      ..color = Color.fromRGBO(233, 118, 91, 1.0)
      ..style = PaintingStyle.fill
      ..strokeWidth = 30.0;
    Path getTrianglePath(double x, double y) {
      return Path()
        ..moveTo(x / 2.3, y / 8)
        ..lineTo(x / 2, 0)
        ..lineTo(x * 1.3 / 2.3, y / 8)
        ..lineTo(0, y / 8);
    }

    canvas.drawCircle(center, radius, circlePaint);
    canvas.drawArc(
        new Rect.fromCenter(
            center: center, width: radius * 2, height: radius * 2),
        (startNight * 2 * pi - pi / 2) - shift,
        (2 * pi * (endNight - startNight)),
        false,
        nightPaint);
    canvas.drawArc(
        new Rect.fromCenter(
            center: center, width: radius * 2, height: radius * 2),
        (startActivity * 2 * pi - pi / 2) - shift,
        (2 * pi * (endActivity - startActivity)),
        false,
        activityPaint);

    canvas.drawPath(getTrianglePath(size.width, size.height), trianglePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
