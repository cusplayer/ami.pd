// import 'package:flutter/material.dart';

// import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// class ColorPicker extends StatefulWidget {
//   @override
//   _ColorPickerState createState() => _ColorPickerState();
// }

// class _ColorPickerState extends State<ColorPicker> {
//   Color pickerColor = Color(0xff443a49);
//   Color currentColor = Color(0xff443a49);

// // ValueChanged<Color> callback
//   void changeColor(Color color) {
//     setState(() => pickerColor = color);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: Text('Нажми на меня'),
//       onTap: () => showDialog(
//         context: context,
//         child: AlertDialog(
//           title: const Text('Pick a color!'),
//           content: SingleChildScrollView(
//             child: ColorPicker(
//                 // pickerColor: pickerColor,
//                 // onColorChanged: changeColor,
//                 // showLabel: true,
//                 // pickerAreaHeightPercent: 0.8,
//                 ),
//             // Use Material color picker:
//             //
//             // child: MaterialPicker(
//             //   pickerColor: pickerColor,
//             //   onColorChanged: changeColor,
//             //   showLabel: true, // only on portrait mode
//             // ),
//             //
//             // Use Block color picker:
//             //
//             // child: BlockPicker(
//             //   pickerColor: currentColor,
//             //   onColorChanged: changeColor,
//             // ),
//             //
//             // child: MultipleChoiceBlockPicker(
//             //   pickerColors: currentColors,
//             //   onColorsChanged: changeColors,
//             // ),
//           ),
//           actions: <Widget>[
//             FlatButton(
//               child: const Text('Got it'),
//               onPressed: () {
//                 setState(() => currentColor = pickerColor);
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
