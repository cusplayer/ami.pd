import 'dart:ffi';

import 'package:ami/models/activity.dart';
import 'package:ami/providers/activities.dart';
import 'package:ami/widgets/color_picker.dart';
import 'package:ami/widgets/cupertino_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'dart:math';

import 'package:uuid/uuid.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  Color color = Colors.white;
  var hour1 = '0';
  var minute1 = '0';
  var hour2 = '0';
  var minute2 = '0';
  var nightStart1;
  var nightEnd1;
  bool isAllowed;
  bool isOneTime = true;
  var uuid = Uuid();
  final _textController = TextEditingController();
  final month = DateTime.now().month < 10
      ? '0${DateTime.now().month}'
      : DateTime.now().month;
  final day =
      DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day;
  void callbackColor(Color color) {
    setState(() {
      this.color = color;
    });
  }

  timeConverter(double time) {
    int hours = time ~/ (1 / 24);
    int minutes = ((time % (1 / 24)) * 1442).toInt();
    return [hours, minutes];
  }

  toColor(colorString) {
    String valueString =
        colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
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
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      onPanelClosed: () =>
          Provider.of<Activities>(this.context, listen: false).clear(),
      defaultPanelState: PanelState.OPEN,
      backdropEnabled: true,
      maxHeight: MediaQuery.of(context).size.height * 0.7,
      panel: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.width / 8),
              width: MediaQuery.of(context).size.width,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Positioned(
                    child: GestureDetector(
                      child: _textController.text != ''
                          ? Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(width: 2, color: Colors.black),
                                ),
                              ),
                              child: Text(
                                _textController.text,
                                style: TextStyle(fontSize: 25),
                              ),
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(width: 2, color: Colors.black),
                                ),
                              ),
                              child: Text(
                                'Введите название',
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                      onTap: () => showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                            title: Text('Название'),
                            content: TextField(
                              autofocus: true,
                              controller: _textController,
                              onSubmitted: (_) => setState(() {}),
                            ),
                            actions: []),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width / 15,
                    ),
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: color,
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        height: MediaQuery.of(context).size.width / 10,
                        width: MediaQuery.of(context).size.width / 10,
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
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width / 8),
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Picker(this.callbackh1, true, 0),
                  Picker(this.callbackm1, false, 0),
                  GestureDetector(
                    child: Text(
                      ':',
                      style: TextStyle(fontSize: 20),
                    ),
                    onTap: () => setState(() {
                      isOneTime = !isOneTime;
                    }),
                  ),
                  !isOneTime
                      ? Row(children: [
                          Picker(this.callbackh2, true, 0),
                          Picker(this.callbackm2, false, 0)
                        ])
                      : Container()
                ],
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.deepPurple),
              ),
              onPressed: () async {
                isAllowed = await Provider.of<Activities>(this.context,
                        listen: false)
                    .isAllowed(
                        double.parse(hour1) / 24 + double.parse(minute1) / 1440,
                        double.parse(hour2) / 24 + double.parse(minute2) / 1440,
                        '${uuid.v1()} ${DateTime.now().year}-$month-$day');

                if (isAllowed) {
                  if (_textController.text == '') {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Введите название'),
                      ),
                    );
                    return;
                  } else if (isOneTime) {
                    Provider.of<Activities>(this.context, listen: false)
                        .addActivity(
                            '${Random().nextInt(1000000)} ${DateTime.now().year}-$month-$day',
                            _textController.text,
                            double.parse(hour1) / 24 +
                                double.parse(minute1) / 1440,
                            2.0,
                            color);
                    Provider.of<Activities>(this.context, listen: false)
                        .clear();
                  } else if (!isOneTime) {
                    Provider.of<Activities>(this.context, listen: false)
                        .addActivity(
                            '${Random().nextInt(1000000)} ${DateTime.now().year}-$month-$day',
                            _textController.text,
                            double.parse(hour1) / 24 +
                                double.parse(minute1) / 1440,
                            double.parse(hour2) / 24 +
                                double.parse(minute2) / 1440,
                            color);
                    Provider.of<Activities>(this.context, listen: false)
                        .clear();
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Выбранный промежуток недопустим'),
                    ),
                  );
                }
              },
              child: Text(
                'Добавить',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
