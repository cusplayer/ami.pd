import 'package:ami/helpers/db_helper.dart';
import 'package:ami/models/activity.dart';
import 'package:ami/providers/activities.dart';
import 'package:ami/widgets/color_picker.dart';
import 'package:flutter/material.dart';

import 'package:ami/widgets/cupertino_picker.dart';
import 'package:provider/provider.dart';

class CommonPicker extends StatefulWidget {
  final MediaQueryData size;
  final Function callback;
  final String text;
  final Activity activity;
  CommonPicker(this.size, this.callback, this.text, this.activity);
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
  final _textController = TextEditingController();
  Color color;

  timeConverter(double time) {
    int hours = time ~/ (1 / 24);
    int minutes = ((time % (1 / 24)) * 1442).toInt();
    return [hours, minutes];
  }

  void callbackh1(String time) {
    setState(() {
      this.hour1 = time;
    });
  }

  toColor(colorString) {
    String valueString =
        colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
    int value = int.parse(valueString, radix: 16);
    return Color(value);
  }

  void callbackColor(Color color) {
    setState(() {
      this.color = color;
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

  void initState() {
    hour1 = timeConverter(widget.activity.start)[0].toString();
    minute1 = timeConverter(widget.activity.start)[1].toString();
    hour2 = timeConverter(widget.activity.end)[0].toString();
    minute2 = timeConverter(widget.activity.end)[1].toString();
    widget.activity.id != '0Adding0'
        ? setState(() {
            this.color = toColor(widget.activity.color);
          })
        : setState(() {
            this.color = Colors.white;
          });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isNight
        ? SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Spacer(),
                    widget.activity.id != '0Adding0'
                        ? Row(children: [
                            GestureDetector(
                              child: _textController.text == ''
                                  ? Text(
                                      widget.text,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    )
                                  : Text(
                                      _textController.text,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                              onTap: () => showModalBottomSheet(
                                  context: context,
                                  builder: (_) {
                                    return Container(
                                      height: 500,
                                      child: TextField(
                                        controller: _textController,
                                      ),
                                    );
                                  }),
                            ),
                            GestureDetector(
                              child: Container(
                                color: this.color,
                                height: 20,
                                width: 20,
                              ),
                              onTap: () => showModalBottomSheet(
                                  context: context,
                                  builder: (_) {
                                    return Container(
                                      height: 500,
                                      child:
                                          ColorPickerWidget(this.callbackColor),
                                    );
                                  }),
                            ),
                          ])
                        : Text(
                            widget.text,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
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
                      Picker(this.callbackh1, true,
                          timeConverter(widget.activity.start)[0]),
                      Picker(this.callbackm1, false,
                          timeConverter(widget.activity.start)[1]),
                      Text(':'),
                      Picker(this.callbackh2, true,
                          timeConverter(widget.activity.end)[0]),
                      Picker(this.callbackm2, false,
                          timeConverter(widget.activity.end)[1]),
                    ],
                  ),
                ),
                widget.activity.id == '0Adding0'
                    ? Column(children: [
                        GestureDetector(
                          child: _textController.text != ''
                              ? Text(_textController.text)
                              : Text('Введите название'),
                          onTap: () => showModalBottomSheet(
                              context: context,
                              builder: (_) {
                                return Container(
                                  height: 500,
                                  child: TextField(
                                    controller: _textController,
                                  ),
                                );
                              }),
                        ),
                        GestureDetector(
                          child: Container(
                            color: color,
                            height: 20,
                            width: 20,
                          ),
                          onTap: () => showModalBottomSheet(
                              context: context,
                              builder: (_) {
                                return Container(
                                  height: 500,
                                  child: ColorPickerWidget(this.callbackColor),
                                );
                              }),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.deepPurple),
                              ),
                              onPressed: () {
                                print(color);
                                setState(() {
                                  this.nightStart1 = double.parse(hour1) / 24 +
                                      double.parse(minute1) / 1440;
                                  this.nightEnd1 = double.parse(hour2) / 24 +
                                      double.parse(minute2) / 1440;
                                  this.widget.callback(
                                      this.nightStart1,
                                      this.nightEnd1,
                                      _textController.text,
                                      color,
                                      '${_textController.text} ${DateTime.now().year} ${DateTime.now().month} ${DateTime.now().day}');
                                });
                              },
                              child: Text(
                                'Добавить',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ])
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateColor.resolveWith(
                                  (states) => Colors.deepPurple),
                            ),
                            onPressed: () {
                              setState(() {
                                this.nightStart1 = double.parse(hour1) / 24 +
                                    double.parse(minute1) / 1440;
                                this.nightEnd1 = double.parse(hour2) / 24 +
                                    double.parse(minute2) / 1440;
                                this.widget.callback(
                                    this.nightStart1,
                                    this.nightEnd1,
                                    _textController.text != ''
                                        ? _textController.text
                                        : widget.activity.name,
                                    color,
                                    widget.activity.id);
                              });
                            },
                            child: Text(
                              'Изменить',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          TextButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith(
                                          (states) => Colors.red)),
                              // shape: new RoundedRectangleBorder(
                              //     borderRadius:
                              //         new BorderRadius.circular(30.0)),
                              child: Text(
                                'Удалить',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Provider.of<Activities>(this.context,
                                        listen: false)
                                    .deleteActivity(widget.activity.id);
                              })
                        ],
                      ),
              ],
            ),
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
