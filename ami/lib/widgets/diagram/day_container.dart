import 'dart:math';

import 'package:ami/models/activity.dart';
import 'package:ami/providers/activities.dart';
import 'package:ami/widgets/diagram/images.dart';
import 'package:ami/widgets/diagram/midnight.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

import 'activity_arc.dart';
import 'dayWidget.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

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

  double size = 400;
  listEl(Activity act) {
    if (act.start != 2) {
      return CustomPaint(
        painter: ActivityArc(
            act.start.toDouble(),
            act.end.toDouble(),
            toColor(act.color),
            Provider.of<Activities>(this.context, listen: false).rotation),
        size: Size(size, size),
      );
    } else {
      return SizedBox();
    }
  }

  imageList(Activity act) {
    if (act.start != 0) {
      return Images(act, size,
          Provider.of<Activities>(this.context, listen: false).rotation);
    } else {
      return SizedBox();
    }
  }

  midnight() {
    return CustomPaint(
      painter: ActivityArc(0.0, 2.0, Colors.black,
          Provider.of<Activities>(this.context, listen: false).rotation),
      size: Size(size, size),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: InteractiveViewer(
          child: Stack(
            alignment: Alignment.center,
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
                        for (var act in widget.activities) listEl(act),
                        for (var act in widget.activities) imageList(act),
                      ]))
                  : Spacer(),
              CustomPaint(
                painter: Midnight(),
                size: Size(size, size),
              ),
              Positioned(
                child: SleekCircularSlider(
                  appearance: CircularSliderAppearance(
                      animationEnabled: false,
                      customColors: CustomSliderColors(
                        progressBarColor: Color(0x00000000),
                        trackColor: Color(0x00000000),
                        hideShadow: true,
                      ),
                      infoProperties: InfoProperties(modifier: (_) => ''),
                      angleRange: 360,
                      startAngle: 270,
                      size: size * 0.65),
                  min: 0.0,
                  max: 1.0,
                  initialValue:
                      Provider.of<Activities>(this.context, listen: false)
                          .rotation,
                  onChange: (double value) async {
                    await Provider.of<Activities>(this.context, listen: false)
                        .updateRotation(value);
                    Provider.of<Activities>(this.context, listen: false)
                        .editDate();
                    Provider.of<Activities>(this.context, listen: false)
                        .addTime(
                            Provider.of<Activities>(this.context, listen: false)
                                .rotation);
                  },
                  // onChangeStart: (double startValue) async => {
                  //   await Provider.of<Activities>(this.context, listen: false)
                  //       .updateRotation(startValue)
                  // },
                  // onChangeEnd: (double endValue) async => {
                  //   await Provider.of<Activities>(this.context, listen: false)
                  //       .updateRotation(endValue)
                  // },
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
