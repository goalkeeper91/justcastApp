import 'package:flutter/material.dart';
import 'package:justcast_app/services/globals.dart';

class TxtStyle extends TextStyle {
  Color color = Colors.white;

  btnTxtStyle() {
    this.color = buttonTxtColor;
  }
}