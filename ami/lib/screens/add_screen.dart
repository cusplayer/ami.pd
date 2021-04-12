import 'package:ami/models/activity.dart';
import 'package:ami/providers/activities.dart';
import 'package:ami/widgets/color_picker.dart';
import 'package:ami/widgets/cupertino_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatefulWidget {
  static const routeName = '/add-screen';
  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  Color color = Colors.black;
  var hour1 = '0';
  var minute1 = '0';
  var hour2 = '0';
  var minute2 = '0';
  var nightStart1;
  var nightEnd1;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('ы'),
      ),
      body: Column(
        children: [
          GestureDetector(
            child: _textController.text != ''
                ? Text(_textController.text)
                : Text('Введите название'),
            onTap: () => showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                  title: Text('Название'),
                  content: TextField(
                    controller: _textController,
                    onSubmitted: (_) => setState(() {}),
                  ),
                  actions: []),
            ),
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
            children: [],
          ),
          Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Picker(this.callbackh1, true, 0),
                Picker(this.callbackm1, false, 0),
                Text(':'),
                Picker(this.callbackh2, true, 0),
                Picker(this.callbackm2, false, 0),
              ],
            ),
          ),
          TextButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.deepPurple),
            ),
            onPressed: () {
              Provider.of<Activities>(this.context, listen: false).addActivity(
                  '${_textController.text} ${DateTime.now().year}-$month-$day',
                  _textController.text,
                  double.parse(hour1) / 24 + double.parse(minute1) / 1440,
                  nightEnd1 =
                      double.parse(hour2) / 24 + double.parse(minute2) / 1440,
                  color);
            },
            child: Text(
              'Добавить',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
