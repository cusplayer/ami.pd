import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Picker extends StatefulWidget {
  final Function callback;
  Picker(this.callback);

  @override
  _PickerState createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  String yourParam;

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
        children: const [
          Text('0'),
          Text('1'),
          Text('2'),
          Text('3'),
          Text('4'),
          Text('5'),
          Text('6'),
          Text('7'),
          Text('8'),
          Text('9'),
          Text('10'),
          Text('11'),
          Text('12'),
          Text('13'),
          Text('14'),
          Text('15'),
          Text('16'),
          Text('17'),
          Text('18'),
          Text('19'),
          Text('20'),
          Text('21'),
          Text('22'),
          Text('23'),
        ],
      ),
    );
  }
}
