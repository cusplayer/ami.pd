import 'package:ami/providers/activities.dart';
import 'package:ami/screens/add_screen.dart';
import 'package:ami/screens/edit_screen.dart';
import 'package:ami/screens/myDay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Activities(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => MyDay(),
          AddScreen.routeName: (ctx) => AddScreen(),
        },
      ),
    );
  }
}
