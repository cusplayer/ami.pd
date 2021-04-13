import 'package:ami/helpers/db_helper.dart';
import 'package:ami/models/activity.dart';
import 'package:ami/providers/activities.dart';
import 'package:ami/screens/edit_screen.dart';
import 'package:ami/widgets/color_picker.dart';
import 'package:flutter/material.dart';

import 'package:ami/widgets/cupertino_picker.dart';
import 'package:provider/provider.dart';

class CommonPicker extends StatefulWidget {
  final MediaQueryData size;
  // final Function callback;
  final Activity activity;
  CommonPicker(this.size, this.activity);
  @override
  _CommonPickerState createState() => _CommonPickerState();
}

class _CommonPickerState extends State<CommonPicker> {
  var isNight = false;
  var hour1;
  var minute1;
  var hour2;
  var minute2;
  var nightStart1;
  var nightEnd1;
  Color color;

  final month = DateTime.now().month < 10
      ? '0${DateTime.now().month}'
      : DateTime.now().month;
  final day =
      DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day;

  timeConverter(double time) {
    int hours = time ~/ (1 / 24);
    int minutes = ((time % (1 / 24)) * 1442).toInt();
    return [hours, minutes];
  }

  toColor(colorString) {
    String valueString = colorString.split('(0x')[1].split(')')[0];
    int value = int.parse(valueString, radix: 16);
    return Color(value);
  }

  void callbackh1(String time) {
    setState(() {
      this.hour1 = time;
    });
  }

  void callbackm1(String time) {
    setState(() {
      this.minute1 = time;
    });
  }

  void callbackh2(String time) {
    setState(() {
      this.hour2 = time;
    });
  }

  void callbackm2(String time) {
    setState(() {
      this.minute2 = time;
    });
  }

  @override
  void initState() {
    this.hour1 = timeConverter(widget.activity.start)[0].toString();
    this.minute1 = timeConverter(widget.activity.start)[1].toString();
    this.hour2 = timeConverter(widget.activity.end)[0].toString();
    this.minute2 = timeConverter(widget.activity.end)[1].toString();

    if (widget.activity.id != '0Adding0') {
      print(
          'id ${widget.activity.id.substring(widget.activity.id.indexOf(' ') + 1)}');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        height: widget.size.size.height / 15,
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height / 100,
              left: MediaQuery.of(context).size.width / 10,
              child: Text(
                widget.activity.name,
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            Provider.of<Activities>(this.context, listen: false).isEditable
                ? Positioned(
                    top: MediaQuery.of(context).size.height / 100,
                    right: MediaQuery.of(context).size.width / 13,
                    child: GestureDetector(
                      child: Image.asset(
                        'assets/images/vector.png',
                        width: MediaQuery.of(context).size.width / 15,
                      ),
                      onTap: () =>
                          Provider.of<Activities>(this.context, listen: false)
                              .returnEdit(widget.activity),
                    ),
                  )
                : Container(),
            Positioned(
              top: MediaQuery.of(context).size.height / 100,
              right: MediaQuery.of(context).size.width / 5,
              child: Container(
                decoration: BoxDecoration(
                  color: toColor(widget.activity.color),
                  border: Border.all(color: Colors.black),
                ),
                height: 20,
                width: 20,
              ),
            )
          ],
        ));
  }
}
