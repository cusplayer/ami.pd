import 'package:ami/helpers/db_helper.dart';
import 'package:ami/models/activity.dart';
import 'package:ami/providers/activities.dart';
import 'package:ami/screens/edit_screen.dart';
import 'package:ami/widgets/color_picker.dart';
import 'package:flutter/material.dart';

import 'package:ami/widgets/cupertino_picker.dart';
import 'package:provider/provider.dart';

class CommonPicker extends StatefulWidget {
  final MediaQueryData size;
  // final Function callback;
  final Activity activity;
  CommonPicker(this.size, this.activity);
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

  final month = DateTime.now().month < 10
      ? '0${DateTime.now().month}'
      : DateTime.now().month;
  final day =
      DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day;

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

  void callbackColor(Color color) {
    setState(() {
      this.color = color;
    });
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
  void initState() {
    this.hour1 = timeConverter(widget.activity.start)[0].toString();
    this.minute1 = timeConverter(widget.activity.start)[1].toString();
    this.hour2 = timeConverter(widget.activity.end)[0].toString();
    this.minute2 = timeConverter(widget.activity.end)[1].toString();
    setState(() {
      this.color = toColor(widget.activity.color);
    });

    if (widget.activity.id != '0Adding0') {
      print(
          'id ${widget.activity.id.substring(widget.activity.id.indexOf(' ') + 1)}');
    }
    // print(widget.activity.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
        // ? SingleChildScrollView(
        //     child: Column(
        //       children: [
        //         Row(
        //           children: [
        //             Spacer(),
        //             widget.activity.id != '0Adding0'
        //                 ? Container(
        //                     width: MediaQuery.of(context).size.width / 1.3,
        //                     child: Row(children: [
        //                       Spacer(),
        //                       GestureDetector(
        //                         child: _textController.text == ''
        //                             ? Text(
        //                                 widget.activity.name,
        //                                 style: TextStyle(
        //                                   color: Colors.white,
        //                                   fontSize: 20,
        //                                   fontStyle: FontStyle.italic,
        //                                 ),
        //                               )
        //                             : Text(
        //                                 _textController.text,
        //                                 style: TextStyle(
        //                                   color: Colors.white,
        //                                   fontSize: 20,
        //                                   fontStyle: FontStyle.italic,
        //                                 ),
        //                               ),
        //                         onTap: () => showDialog(
        //                           context: context,
        //                           builder: (ctx) => AlertDialog(
        //                               title: Text('Изменить название'),
        //                               content: TextField(
        //                                 controller: _textController,
        //                               ),
        //                               actions: []),
        //                         ),
        //                       ),
        //                       Spacer(),
        //                       GestureDetector(
        //                         child: Container(
        //                           color: this.color,
        //                           height: 20,
        //                           width: 20,
        //                         ),
        //                         onTap: () => showModalBottomSheet(
        //                             context: context,
        //                             builder: (_) {
        //                               return Container(
        //                                 height:
        //                                     MediaQuery.of(context).size.height,
        //                                 child: ColorPickerWidget(
        //                                     this.callbackColor),
        //                               );
        //                             }),
        //                       ),
        //                     ]),
        //                   )
        //                 : Text(
        //                     widget.activity.name,
        //                     style: TextStyle(
        //                       color: Colors.white,
        //                       fontSize: 20,
        //                     ),
        //                   ),
        //             Spacer(),
        //             FloatingActionButton(
        //                 heroTag: 'less',
        //                 child: Icon(Icons.expand_less),
        //                 backgroundColor: Colors.lightBlue,
        //                 onPressed: () {
        //                   setState(() {
        //                     this.isNight = !this.isNight;
        //                     print(widget.activity.color);
        //                   });
        //                 }),
        //           ],
        //         ),
        //         Container(
        //           height: 100,
        //           child: Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceAround,
        //             children: [
        //               Picker(this.callbackh1, true,
        //                   timeConverter(widget.activity.start)[0]),
        //               Picker(this.callbackm1, false,
        //                   timeConverter(widget.activity.start)[1]),
        //               Text(':'),
        //               Picker(this.callbackh2, true,
        //                   timeConverter(widget.activity.end)[0]),
        //               Picker(this.callbackm2, false,
        //                   timeConverter(widget.activity.end)[1]),
        //             ],
        //           ),
        //         ),
        //         widget.activity.id == '0Adding0'
        //             ? Column(children: [
        //                 GestureDetector(
        //                   child: _textController.text != ''
        //                       ? Text(_textController.text)
        //                       : Text('Введите название'),
        //                   onTap: () => showDialog(
        //                     context: context,
        //                     builder: (ctx) => AlertDialog(
        //                         title: Text('Название'),
        //                         content: TextField(
        //                           controller: _textController,
        //                         ),
        //                         actions: []),
        //                   ),
        //                 ),
        //                 GestureDetector(
        //                   child: Container(
        //                     color: color,
        //                     height: 20,
        //                     width: 20,
        //                   ),
        //                   onTap: () => showModalBottomSheet(
        //                       context: context,
        //                       builder: (_) {
        //                         return Container(
        //                           height: 500,
        //                           child: ColorPickerWidget(this.callbackColor),
        //                         );
        //                       }),
        //                 ),
        //                 Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                   children: [
        //                     TextButton(
        //                       style: ButtonStyle(
        //                         backgroundColor:
        //                             MaterialStateProperty.all<Color>(
        //                                 Colors.deepPurple),
        //                       ),
        //                       onPressed: () {
        //                         print(color);
        //                         setState(() {
        //                           this.nightStart1 = double.parse(hour1) / 24 +
        //                               double.parse(minute1) / 1440;
        //                           this.nightEnd1 = double.parse(hour2) / 24 +
        //                               double.parse(minute2) / 1440;
        //                           // this.widget.callback(
        //                           //     this.nightStart1,
        //                           //     this.nightEnd1,
        //                           //     _textController.text,
        //                           //     color,
        //                           //     '${_textController.text} ${DateTime.now().year} ${DateTime.now().month} ${DateTime.now().day}');
        //                           Provider.of<Activities>(this.context,
        //                                   listen: false)
        //                               .addActivity(
        //                                   '${_textController.text} ${DateTime.now().year}-$month-$day',
        //                                   _textController.text,
        //                                   double.parse(hour1) / 24 +
        //                                       double.parse(minute1) / 1440,
        //                                   nightEnd1 = double.parse(hour2) / 24 +
        //                                       double.parse(minute2) / 1440,
        //                                   color);
        //                         });
        //                       },
        //                       child: Text(
        //                         'Добавить',
        //                         style: TextStyle(color: Colors.white),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //               ])
        //             : Row(
        //                 mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                 children: [
        //                   TextButton(
        //                     style: ButtonStyle(
        //                       backgroundColor: MaterialStateColor.resolveWith(
        //                           (states) => Colors.deepPurple),
        //                     ),
        //                     onPressed: () {
        //                       // this.widget.callback(
        //                       //     double.parse(hour1) / 24 +
        //                       //         double.parse(minute1) / 1440,
        //                       //     nightEnd1 = double.parse(hour2) / 24 +
        //                       //         double.parse(minute2) / 1440,
        //                       //     _textController.text != ''
        //                       //         ? _textController.text
        //                       //         : widget.activity.name,
        //                       //     color,
        //                       //     widget.activity.id);
        //                       Provider.of<Activities>(this.context,
        //                               listen: false)
        //                           .editActivity(
        //                               widget.activity.id,
        //                               _textController.text != ''
        //                                   ? _textController.text
        //                                   : widget.activity.name,
        //                               double.parse(hour1) / 24 +
        //                                   double.parse(minute1) / 1440,
        //                               nightEnd1 = double.parse(hour2) / 24 +
        //                                   double.parse(minute2) / 1440,
        //                               color);
        //                       setState(() {
        //                         this.nightStart1 = 0;
        //                         this.nightEnd1 = 0;

        //                         isNight = !isNight;
        //                         _textController.text = '';
        //                       });
        //                     },
        //                     child: Text(
        //                       'Изменить',
        //                       style: TextStyle(color: Colors.white),
        //                     ),
        //                   ),
        //                   TextButton(
        //                       style: ButtonStyle(
        //                           backgroundColor:
        //                               MaterialStateColor.resolveWith(
        //                                   (states) => Colors.red)),
        //                       // shape: new RoundedRectangleBorder(
        //                       //     borderRadius:
        //                       //         new BorderRadius.circular(30.0)),
        //                       child: Text(
        //                         'Удалить',
        //                         style: TextStyle(color: Colors.white),
        //                       ),
        //                       onPressed: () {
        //                         Provider.of<Activities>(this.context,
        //                                 listen: false)
        //                             .deleteActivity(widget.activity.id);
        //                       })
        //                 ],
        //               ),
        //       ],
        //     ),
        //   )
        Container(
            color: Colors.white,
            height: widget.size.size.height / 15,
            child: Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height / 100,
                  left: MediaQuery.of(context).size.width / 10,
                  child: Text(
                    widget.activity.name,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
                Provider.of<Activities>(this.context, listen: false).isEditable
                    ? Positioned(
                        top: MediaQuery.of(context).size.height / 100,
                        right: MediaQuery.of(context).size.width / 13,
                        child: GestureDetector(
                          child: Image.asset(
                            'assets/images/vector.png',
                            width: MediaQuery.of(context).size.width / 15,
                          ),
                          onTap: () => Provider.of<Activities>(this.context,
                                  listen: false)
                              .returnEdit(widget.activity),
                        ),
                      )
                    : Container(),
                Positioned(
                  top: MediaQuery.of(context).size.height / 100,
                  right: MediaQuery.of(context).size.width / 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: this.color,
                      border: Border.all(color: Colors.black),
                    ),
                    height: 20,
                    width: 20,
                  ),
                )

                // FloatingActionButton(
                //     heroTag: 'more',
                //     child: Icon(Icons.expand_more),
                //     onPressed: () {
                //       setState(() {
                //         this.isNight = !this.isNight;
                //         print(widget.activity.color);
                //       });
                //     }),
              ],
            ));
  }
}
