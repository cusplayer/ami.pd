import 'package:ami/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'common_picker.dart';

class ElementPicker extends StatefulWidget {
  final MediaQueryData mediaQuery;
  final Function callback;
  Activity activity;
  ElementPicker(this.mediaQuery, this.callback, this.activity);
  @override
  _ElementPickerState createState() => _ElementPickerState();
}

class _ElementPickerState extends State<ElementPicker> {
  var activityStart;
  var activityEnd;
  void pickerCallback(double ns1, double ne1) {
    setState(() {
      this.widget.callback(
            ns1,
            ne1,
          );
      this.activityStart = ns1;
      this.activityEnd = ne1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: widget.mediaQuery.size.height / 30),
      decoration: BoxDecoration(
        color: Colors.blue,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: CommonPicker(
          widget.mediaQuery, pickerCallback, widget.activity.end.toString()),
    );
  }
}
