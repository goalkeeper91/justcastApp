import 'package:flutter/material.dart';
import 'package:justcast_app/services/globals.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

  bool get isDarkMode => themeMode == ThemeMode.dark;

 void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.blue.shade900,
    primaryColor: Colors.grey.shade900,
    iconTheme: const IconThemeData(color: Colors.white),
    backgroundColor: Colors.black,
    colorScheme: const ColorScheme.dark(),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.blue.shade600,
    primaryColor: Colors.grey.shade100,
    iconTheme: const IconThemeData(color: Colors.black),
    backgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(),
  );
}