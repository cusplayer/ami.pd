import 'dart:math';

import 'package:ami/widgets/pick_time.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:ami/models/activity.dart';
import 'package:ami/providers/activities.dart';
import 'package:ami/widgets/color_picker.dart';
import 'package:ami/widgets/cupertino_picker.dart';

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
  var isTime = false;
  late bool isAllowed;
  var uuid = Uuid();
  final _textController = TextEditingController();
  DateTime date = DateTime.now();
  var isSelected = [true, false];
  void callbackColor(Color color) {
    setState(() {
      this.color = color;
    });
  }

  month(DateTime date) {
    return date.month < 10 ? '0${date.month}' : date.month;
  }

  day(DateTime date) {
    return date.day < 10 ? '0${date.day}' : date.day;
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

  void dateCallback(DateTime date) {
    setState(() {
      this.date = date;
    });
  }

  void isSelectedCallback(bool isSelected, int index) {
    setState(() {
      this.isSelected[index] = isSelected;
    });
  }

  // void showModal() {
  //   showModalBottomSheet<void>(
  //       isDismissible: false,
  //       context: context,
  //       builder: (BuildContext context) {
  //       });
  // }
  //   void _presentDatePicker() {
  void _presentDatePicker() {
    showDatePicker(
            helpText: '',
            context: context,
            locale: const Locale("ru", "RU"),
            initialDate: Provider.of<Activities>(this.context, listen: false)
                .initialDate,
            firstDate: DateTime(2020),
            lastDate: DateTime.now().add(const Duration(days: 365)))
        .then((pickedDate) {
      if (pickedDate != null) {
        Provider.of<Activities>(this.context, listen: false)
            .updateDate(pickedDate);
      }
    });
  }

  @override
  void initState() {
    this.date =
        Provider.of<Activities>(this.context, listen: false).initialDate;
    initializeDateFormatting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, Colors.white],
              begin: Alignment.topRight,
              end: Alignment.center,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.width / 15),
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Positioned(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 60),
                            child: TextField(
                              maxLines: 5,
                              style: TextStyle(fontSize: 24),
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              autofocus: true,
                              controller: _textController,
                              onSubmitted: (_) => setState(() {}),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
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
                                      child:
                                          ColorPickerWidget(this.callbackColor),
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: GestureDetector(
                      child: Container(
                        height: 45,
                        width: 45,
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Image.asset(
                          'assets/images/time.png',
                          width: MediaQuery.of(context).size.width / 15,
                          scale: 1.5,
                        ),
                      ),
                      onTap: () => setState(() {
                            isTime = true;
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                content: PickTime(
                                  callbackh1: callbackh1,
                                  callbackm1: callbackm1,
                                  callbackh2: callbackh2,
                                  callbackm2: callbackm2,
                                  isSelectedCallback: isSelectedCallback,
                                  isSelected: isSelected,
                                ),
                              ),
                            );
                          })),
                ),
                GestureDetector(
                  onTap: () async {
                    isAllowed = isTime
                        ? await Provider.of<Activities>(this.context,
                                listen: false)
                            .isAllowed(
                            double.parse(hour1) / 24 +
                                double.parse(minute1) / 1440,
                            isSelected[0]
                                ? 2
                                : double.parse(hour2) / 24 +
                                    double.parse(minute2) / 1440,
                            '${uuid.v1()}',
                          )
                        : await Provider.of<Activities>(this.context,
                                listen: false)
                            .isAllowed(2, 2, '${uuid.v1()}');

                    if (isAllowed) {
                      if (color != Colors.white || !isTime) {
                        if (_textController.text == '') {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('Введите название'),
                            ),
                          );
                          return;
                        }
                        if (!isTime) {
                          Navigator.pop(context);
                          Provider.of<Activities>(this.context, listen: false)
                              .addActivity(
                                  '${uuid.v1()}',
                                  _textController.text,
                                  2,
                                  2,
                                  color,
                                  '${date.year}-${(month(date))}-${day(date)}');
                        } else if (isSelected[0]) {
                          Navigator.pop(context);
                          Provider.of<Activities>(this.context, listen: false)
                              .addActivity(
                                  '${uuid.v1()}',
                                  _textController.text,
                                  double.parse(hour1) / 24 +
                                      double.parse(minute1) / 1440,
                                  2,
                                  color,
                                  '${date.year}-${(month(date))}-${day(date)}');
                          // Provider.of<Activities>(this.context, listen: false)
                          //     .clear();
                        } else if (isSelected[1]) {
                          Navigator.pop(context);
                          Provider.of<Activities>(this.context, listen: false)
                              .addActivity(
                                  '${uuid.v1()}',
                                  _textController.text,
                                  double.parse(hour1) / 24 +
                                      double.parse(minute1) / 1440,
                                  double.parse(hour2) / 24 +
                                      double.parse(minute2) / 1440,
                                  color,
                                  '${date.year}-${(month(date))}-${day(date)}');
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
                  child: Container(
                      width: 80,
                      height: 80,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Image.asset('assets/images/arrow.png')),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: GestureDetector(
                    onTap: _presentDatePicker,
                    child: Container(
                      padding: EdgeInsets.all(3),
                      height: 45,
                      width: 45,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        Provider.of<Activities>(this.context, listen: true)
                            .getDateView()
                            .split(" ")[0],
                        style:
                            TextStyle(color: Color(0xfffddbb8), fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
