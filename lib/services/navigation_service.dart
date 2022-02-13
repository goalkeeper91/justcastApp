import 'package:flutter/material.dart';
import 'package:justcast_app/screen/dashboard.dart';
import 'package:justcast_app/screen/login.dart';

class NavigationService{

  static Future<void> onPressedDashboard(var context) async {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const Dashboard()
        ));
  }

  static Future<void> onPressedProfile(var context) async {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const Dashboard()
        ));
  }

  static Future<void> onPressedOption(var context) async {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const Dashboard()
        ));
  }

  static Future<void> onPressedLogout(var context) async {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const Login()
        ));
  }
}