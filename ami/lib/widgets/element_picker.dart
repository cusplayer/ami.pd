import 'package:ami/models/activity.dart';
import 'package:ami/providers/activities.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'common_picker.dart';

class ElementPicker extends StatefulWidget {
  final MediaQueryData mediaQuery;
  final Activity activity;
  ElementPicker(this.mediaQuery, this.activity);
  @override
  _ElementPickerState createState() => _ElementPickerState();
}

class _ElementPickerState extends State<ElementPicker> {
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
      child: CommonPicker(widget.mediaQuery,
          '${widget.activity.name.toString()}', widget.activity),
    );
  }
}
