import 'package:ami/models/activity.dart';
import 'package:ami/providers/activities.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'activity_arc.dart';
import 'dayWidget.dart';

class DayContainer extends StatefulWidget {
  final MediaQueryData mediaQuery;
  final Activities activities;
  DayContainer(this.mediaQuery, this.activities);
  @override
  _DayContainerState createState() => _DayContainerState();
}

class _DayContainerState extends State<DayContainer> {
  listEl(Activity act) {
    return CustomPaint(
      painter: ActivityArc(
          act.start,
          act.end,
          Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(1.0)),
      size: Size(300, 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: widget.mediaQuery.size.height / 40),
      child: InteractiveViewer(
        child: Stack(
          children: [
            CustomPaint(
              painter: DayWidget(),
              size: Size(300, 300),
            ),
            widget.activities != null
                ? Container(
                    height: 300,
                    width: 300,
                    child: Stack(children: [
                      for (var act in widget.activities.activities) listEl(act)
                    ]))
                : Spacer(),
          ],
        ),
      ),
    );
  }
}
