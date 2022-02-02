import 'package:ami/widgets/cupertino_picker.dart';
import 'package:flutter/material.dart';

class PickTime extends StatefulWidget {
  final Function callbackh1;
  final Function callbackm1;
  final Function callbackh2;
  final Function callbackm2;
  final Function isSelectedCallback;
  final List<bool> isSelected;
  const PickTime({
    Key? key,
    required this.callbackh1,
    required this.callbackm1,
    required this.callbackh2,
    required this.callbackm2,
    required this.isSelectedCallback,
    required this.isSelected,
  }) : super(key: key);

  @override
  _PickTimeState createState() => _PickTimeState();
}

class _PickTimeState extends State<PickTime> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width / 16),
              child: ToggleButtons(
                  children: [
                    Container(
                      child: Text(
                        'Активность',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                    Container(
                      child: Text(
                        'Задача',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                  onPressed: (int index) {
                    setState(() {
                      if (index == 0) {
                        widget.isSelectedCallback(true, 0);
                        widget.isSelectedCallback(false, 1);
                      } else {
                        widget.isSelectedCallback(false, 0);
                        widget.isSelectedCallback(true, 1);
                      }
                      // for (int buttonIndex = 0;
                      //     buttonIndex < isSelected.length;
                      //     buttonIndex++) {
                      //   if (buttonIndex == index) {
                      //     isSelected[buttonIndex] = true;
                      //     widget.isSelectedCallback(true, index);
                      //   } else {
                      //     isSelected[buttonIndex] = false;
                      //     widget.isSelectedCallback(false, index);
                      //   }
                      // }
                    });
                  },
                  isSelected: widget.isSelected),
            ),
          ]),
          Container(
            margin:
                EdgeInsets.only(bottom: MediaQuery.of(context).size.width / 16),
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Picker(widget.callbackh1, true, 0),
                Picker(widget.callbackm1, false, 0),
                !widget.isSelected[0]
                    ? Row(children: [
                        Text(
                          ':',
                          style: TextStyle(fontSize: 20),
                        ),
                        Picker(widget.callbackh2, true, 0),
                        Picker(widget.callbackm2, false, 0)
                      ])
                    : Container()
              ],
            ),
          )
        ],
      ),
    );
  }
}
