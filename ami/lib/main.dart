import 'package:ami/providers/activities.dart';
import 'package:ami/screens/add_screen.dart';
import 'package:ami/screens/edit_screen.dart';
import 'package:ami/screens/myDay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: [const Locale('en'), const Locale('ru')],
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Bloggersans',
        ),
        initialRoute: '/',
        routes: {
          '/': (ctx) => MyDay(),
        },
      ),
    );
  }
}
