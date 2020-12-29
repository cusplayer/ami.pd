import 'package:flutter/material.dart';

import 'package:ami/widgets/cupertino_picker.dart';

class CommonPicker extends StatefulWidget {
  final MediaQueryData size;
  final Function callback;
  final String text;
  CommonPicker(this.size, this.callback, this.text);
  @override
  _CommonPickerState createState() => _CommonPickerState();
}

class _CommonPickerState extends State<CommonPicker> {
  var isNight = false;
  var hour1 = '0';
  var minute1 = '0';
  var hour2 = '0';
  var minute2 = '0';
  var nightStart1;
  var nightEnd1;
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
  Widget build(BuildContext context) {
    return isNight
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  Text(
                    widget.text,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Spacer(),
                  FloatingActionButton(
                      child: Icon(Icons.expand_less),
                      backgroundColor: Colors.lightBlue,
                      onPressed: () {
                        setState(() {
                          this.isNight = !this.isNight;
                        });
                      }),
                ],
              ),
              Container(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Picker(this.callbackh1, true),
                    Picker(this.callbackm1, false),
                    Text(':'),
                    Picker(this.callbackh2, true),
                    Picker(this.callbackm2, false),
                  ],
                ),
              ),
              FlatButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                color: Colors.deepPurple,
                onPressed: () {
                  setState(() {
                    this.nightStart1 =
                        double.parse(hour1) / 24 + double.parse(minute1) / 1440;
                    this.nightEnd1 =
                        double.parse(hour2) / 24 + double.parse(minute2) / 1440;
                    this.widget.callback(
                          this.nightStart1,
                          this.nightEnd1,
                        );
                  });
                },
                child: Text(
                  'Изменить',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          )
        : Container(
            height: widget.size.size.height / 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                Text(
                  widget.text,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Spacer(),
                FloatingActionButton(
                    child: Icon(Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        this.isNight = !this.isNight;
                      });
                    }),
              ],
            ),
          );
  }
}
