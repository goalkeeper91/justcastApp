import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:justcast_app/screen/add_new_match.dart';
import 'package:justcast_app/screen/login.dart';
import 'package:justcast_app/screen/register.dart';

const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JustCast',
      theme: ThemeData(
        primarySwatch: white,
        scaffoldBackgroundColor: Colors.blue[800],
      ),
      home: Login(),
    );
  }
}