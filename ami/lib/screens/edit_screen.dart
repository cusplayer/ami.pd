import 'package:ami/models/activity.dart';
import 'package:ami/providers/activities.dart';
import 'package:ami/widgets/color_picker.dart';
import 'package:ami/widgets/cupertino_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatefulWidget {
  final Activity activity;
  EditScreen(this.activity);
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  var hour1;
  var minute1;
  var hour2;
  var minute2;
  final _textController = TextEditingController();
  toColor(colorString) {
    String valueString =
        colorString.split('(0x')[1].split(')')[0]; // kind of hacky..
    int value = int.parse(valueString, radix: 16);
    return Color(value);
  }

  timeConverter(double time) {
    int hours = time ~/ (1 / 24);
    int minutes = ((time % (1 / 24)) * 1442).toInt();
    return [hours, minutes];
  }

  Color color;
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
    color = toColor(widget.activity.color);
    // print(widget.activity.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ы')),
      body: Container(
        // width: MediaQuery.of(context).size.width / 1.3,
        child: Column(children: [
          Row(children: [
            Spacer(),
            GestureDetector(
              child: _textController.text == ''
                  ? Text(
                      widget.activity.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  : Text(
                      _textController.text,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
              onTap: () => showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                    title: Text('Изменить название'),
                    content: TextField(
                      controller: _textController,
                      onSubmitted: (_) => setState(() {}),
                    ),
                    actions: []),
              ),
            ),
            Spacer(),
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: this.color,
                  border: Border.all(color: Colors.black),
                ),
                height: 20,
                width: 20,
              ),
              onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (_) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      child: ColorPickerWidget(this.callbackColor),
                    );
                  }),
            ),
          ]),
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
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextButton(
              onPressed: () => {
                Provider.of<Activities>(this.context, listen: false)
                    .editActivity(
                        widget.activity.id,
                        _textController.text != ''
                            ? _textController.text
                            : widget.activity.name,
                        double.parse(hour1) / 24 + double.parse(minute1) / 1440,
                        double.parse(hour2) / 24 + double.parse(minute2) / 1440,
                        color),
                Navigator.of(context).pop()
              },
              child: Text('Изменить'),
            ),
            TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateColor.resolveWith((states) => Colors.red)),
                // shape: new RoundedRectangleBorder(
                //     borderRadius:
                //         new BorderRadius.circular(30.0)),
                child: Text(
                  'Удалить',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Provider.of<Activities>(this.context, listen: false)
                      .deleteActivity(widget.activity.id);
                  Navigator.of(context).pop();
                })
          ])
        ]),
      ),
    );
  }
}
