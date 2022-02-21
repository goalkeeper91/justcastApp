
import 'package:flutter/material.dart';

const String baseURL = "http://10.0.2.2:8000/api/";
const Map<String,String> headers = {"Content-Type": "application/json"};
final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
String userAuth = "";
int userId = 0;
String userEmail = "";
String userPW = "";
int? casterId;
bool isCaster = false;
var textColor = Colors.white;
var buttonTxtColor = Colors.white;
var backgroundColor = Colors.white;
bool darkMode = false;
String text = "";

setTextColor(){
  if(darkMode == false){
    textColor = Colors.black;
  }else{
    textColor = Colors.white;
  }
}

errorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(text),
        duration: const Duration(),
      ));
}