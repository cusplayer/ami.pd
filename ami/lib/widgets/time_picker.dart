import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  TimeOfDay _selextedDate;
  TimeOfDay _firstTime;
  TimeOfDay _secondTime;
  final now = new DateTime.now();
  void _presentDatePicker(time) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        );
      },
      helpText: 'Выберите время',
      cancelText: 'Выйти',
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      if (time == 1) {
        setState(() {
          _firstTime = pickedDate;
        });
      } else if (time == 2) {
        setState(() {
          _secondTime = pickedDate;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 18,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: GestureDetector(
                    onTap: () => _presentDatePicker(1),
                    child: _firstTime != null
                        ? Text('Начальное время ${_firstTime.format(context)}')
                        : Text('Выберите начальное время'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: GestureDetector(
                    onTap: () => _presentDatePicker(2),
                    child: _secondTime != null
                        ? Text('Конечное время ${_secondTime.format(context)}')
                        : Text('Выберите конечное время'),
                  ),
                ),
              ],
            ),
          ),
          _secondTime != null && _firstTime != null
              ? Container(
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.all(10),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: GestureDetector(
                    onTap: () => _presentDatePicker(2),
                    child: Text('Сохранить'),
                  ),
                )
              : Divider(),
        ],
      ),
    );
  }
}
