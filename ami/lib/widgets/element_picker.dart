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
  dateName() {
    if (widget.activity.id != '0Adding0') {
      return widget.activity.id
              .substring(widget.activity.id.indexOf(' ') + 1) ==
          Provider.of<Activities>(context, listen: true).date;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return dateName()
        ? Container(
            margin: EdgeInsets.only(top: widget.mediaQuery.size.height / 70),
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
          )
        : SizedBox();
  }
}
