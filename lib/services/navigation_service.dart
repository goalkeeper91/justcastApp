import 'dart:async';

import 'package:flutter/material.dart';
import 'package:justcast_app/screen/caster_dashboard.dart';
import 'package:justcast_app/screen/dashboard.dart';
import 'package:justcast_app/screen/login.dart';
import 'package:justcast_app/screen/option.dart';
import 'package:justcast_app/screen/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationService{

  static Future<void> onPressedDashboard(var context) async {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const Dashboard()
        ));
  }

  static Future<void> onPressedProfile(var context) async {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const Profile()
        ));
  }

  static Future<void> onPressedOption(var context) async {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const Option()
        ));
  }

  static Future<void> onPressedLogout(var context) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('username');
    localStorage.remove('token');
    localStorage.remove('email');
    localStorage.remove('casterId');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const Login()
        ));
  }

  static Future<void> onPressedCasterDashboard(var context) async {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const CasterDashboard()
        ));
  }

  static Future<void> onPressedLogin(var context) async {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const Login()
        ));
  }
}