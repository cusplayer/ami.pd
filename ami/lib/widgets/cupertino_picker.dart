import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Picker extends StatefulWidget {
  final Function callback;
  final bool isHours;
  final int time;

  Picker(this.callback, this.isHours, this.time);

  @override
  _PickerState createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  Text text;
  void initState() {
    arr = [];
    if (widget.isHours) {
      for (var i = 0; i < 24; i++) {
        if (i + widget.time <= 23) {
          arr.add(Text('${i + widget.time}'));
        } else {
          arr.add(Text('${i + widget.time - 24}'));
        }
      }
    } else {
      for (var i = 0; i < 60; i++) {
        if (i + widget.time <= 59) {
          arr.add(Text('${i + widget.time}'));
        } else {
          arr.add(Text('${i + widget.time - 60}'));
        }
      }
    }
    super.initState();
    print('Время ${widget.time.toString()}');
  }

  String yourParam;
  var arr = <Widget>[];
  String selectedValue;
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Container(
      width: mediaQuery.size.width / 5,
      child: CupertinoPicker(
        backgroundColor: Colors.white,
        onSelectedItemChanged: (value) {
          setState(() {
            text = arr[value];
            selectedValue = text.data;
            this.widget.callback(selectedValue);
          });
        },
        itemExtent: 32.0,
        children: arr,
        looping: true,
      ),
    );
  }
}
