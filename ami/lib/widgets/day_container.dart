import 'package:ami/models/activity.dart';
import 'package:ami/providers/activities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'activity_arc.dart';
import 'dayWidget.dart';

class DayContainer extends StatefulWidget {
  final MediaQueryData mediaQuery;
  final List<Activity> activities;
  DayContainer(this.mediaQuery, this.activities);
  @override
  _DayContainerState createState() => _DayContainerState();
}

class _DayContainerState extends State<DayContainer> {
  // @override
  // void initState() {
  //   Provider.of<Activities>(this.context, listen: false).sortedActivities =
  //       Provider.of<Activities>(this.context, listen: false)
  //           .sortForArc(widget.activities.activities);
  //   super.initState();
  // }

  toColor(colorString) {
    String valueString =
        colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
    int value = int.parse(valueString, radix: 16);
    return Color(value);
  }

  double size = 300;
  listEl(Activity act) {
    return CustomPaint(
      painter: ActivityArc(
          act.start.toDouble(), act.end.toDouble(), toColor(act.color)),
      size: Size(size, size),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InteractiveViewer(
        child: Stack(
          children: [
            CustomPaint(
              painter: DayWidget(),
              size: Size(size, size),
            ),
            widget.activities != null
                ? Container(
                    height: size,
                    width: size,
                    child: Stack(children: [
                      for (var act in widget.activities) listEl(act)
                    ]))
                : Spacer(),
          ],
        ),
      ),
    );
  }
}
