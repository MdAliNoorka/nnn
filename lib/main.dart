import 'package:flutter/material.dart';
import 'Activities/Home.dart';

void main() {

  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
    themeMode: ThemeMode.system,
    theme: ThemeData(
      brightness: Brightness.light,
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
    ),
  ));
}
