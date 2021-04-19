import 'package:ami/models/activity.dart';
import 'package:ami/providers/activities.dart';
import 'package:ami/widgets/color_picker.dart';
import 'package:ami/widgets/cupertino_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
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
  late bool isAllowed;
  var uuid = Uuid();
  var isSelected = [true, false];
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

  // void showModal() {
  //   showModalBottomSheet<void>(
  //       isDismissible: false,
  //       context: context,
  //       builder: (BuildContext context) {
  //       });
  // }

  // @override
  // void initState() {
  //   Future.delayed(Duration.zero, () {
  //     showModal();
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.width / 15),
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
                              height: 300,
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
                  bottom: MediaQuery.of(context).size.width / 16),
              child: ToggleButtons(
                  children: [
                    Container(
                      padding: EdgeInsets.all(3),
                      child: Text(
                        'Активность',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(3),
                      child: Text(
                        'Задача',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                  onPressed: (int index) {
                    setState(() {
                      for (int buttonIndex = 0;
                          buttonIndex < isSelected.length;
                          buttonIndex++) {
                        if (buttonIndex == index) {
                          isSelected[buttonIndex] = true;
                        } else {
                          isSelected[buttonIndex] = false;
                        }
                      }
                    });
                  },
                  isSelected: isSelected),
            ),
            Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width / 16),
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Picker(this.callbackh1, true, 0),
                  Picker(this.callbackm1, false, 0),
                  !isSelected[0]
                      ? Row(children: [
                          Text(
                            ':',
                            style: TextStyle(fontSize: 20),
                          ),
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
                        isSelected[0]
                            ? 2
                            : double.parse(hour2) / 24 +
                                double.parse(minute2) / 1440,
                        '${uuid.v1()} ${DateTime.now().year}-$month-$day');

                if (isAllowed) {
                  if (color != Colors.white) {
                    if (_textController.text == '') {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('Введите название'),
                        ),
                      );
                      return;
                    } else if (isSelected[0]) {
                      Navigator.pop(context);
                      Provider.of<Activities>(this.context, listen: false)
                          .addActivity(
                              '${Random().nextInt(1000000)} ${DateTime.now().year}-$month-$day',
                              _textController.text,
                              double.parse(hour1) / 24 +
                                  double.parse(minute1) / 1440,
                              2,
                              color);
                      // Provider.of<Activities>(this.context, listen: false)
                      //     .clear();
                    } else if (isSelected[1]) {
                      Navigator.pop(context);
                      Provider.of<Activities>(this.context, listen: false)
                          .addActivity(
                              '${Random().nextInt(1000000)} ${DateTime.now().year}-$month-$day',
                              _textController.text,
                              double.parse(hour1) / 24 +
                                  double.parse(minute1) / 1440,
                              double.parse(hour2) / 24 +
                                  double.parse(minute2) / 1440,
                              color);
                      // Provider.of<Activities>(this.context, listen: false)
                      //     .clear();
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Выберите цвет'),
                      ),
                    );
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text('Выбранное время недопустимо'),
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
