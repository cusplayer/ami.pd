import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Picker extends StatefulWidget {
  final Function callback;
  final bool isHours;
  Picker(this.callback, this.isHours);

  @override
  _PickerState createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  void initState() {
    arr = [];
    if (widget.isHours) {
      for (var i = 0; i <= 23; i++) {
        arr.add(Text('$i'));
      }
    } else {
      for (var i = 0; i <= 60; i++) {
        arr.add(Text('$i'));
      }
    }
    super.initState();
  }

  String yourParam;
  var arr = <Widget>[];
  int selectedValue;
  @override
  Widget build(BuildContext context) {
    print('selected value $selectedValue');
    var mediaQuery = MediaQuery.of(context);
    return Container(
      width: mediaQuery.size.width / 5,
      child: CupertinoPicker(
        backgroundColor: Colors.white,
        onSelectedItemChanged: (value) {
          setState(() {
            selectedValue = value;
            this.widget.callback(value.toString());
          });
        },
        itemExtent: 32.0,
        children: arr,
      ),
    );
  }
}
