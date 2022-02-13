import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:justcast_app/class/user.dart';
import 'package:justcast_app/rounded_button.dart';
import 'package:justcast_app/screen/dashboard.dart';
import 'package:justcast_app/services/auth_services.dart';
import 'package:http/http.dart' as http;
import 'package:justcast_app/services/globals.dart';


class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String _email = '';
  String _password = '';
  String _username = '';

  createAccountPressed() async {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email);
    if(emailValid){
      http.Response response = await AuthServices.register(_username, _email, _password);
      Map responseMap = jsonDecode(response.body);
      if(response.statusCode==200){
        User user = User(int.parse('id'), 'username', 'email');
        userAuth = user.username;
        Navigator.push(context, 
            MaterialPageRoute(builder: (BuildContext context) => const Dashboard()
            ));
      }else{
        errorSnackBar(context, responseMap.values.first[0]);
      }
    }else {
      errorSnackBar(context, 'Bitte eine korrekte Email eintragen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network('https://www.justcast.org/images/logo.png',
              fit: BoxFit.contain,
              height: 46,
            ),
          ],
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Text("Mein Profil"),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Text("Optionen"),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Text("Logout"),
                ),
              ];
            },
            onSelected: (value) {
              if(value == 0) {
                print("Mein Profil ausgewählt");
              }else if(value == 1) {
                print("Optionen ausgewählt");
              }else if(value == 2) {
                print("Ausgeloggt");
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 15),
        child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xFAFAF8EB),
        ),
        child: Padding(
            padding: new EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
            children: [
                const Text(
              'Registration',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
                const SizedBox(
              height: 20,
            ),
                TextField(
              decoration: const InputDecoration(
                hintText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(4.0))
                )
              ),
              onChanged: (value) {
                _username = value;
              },
              ),
                const SizedBox(
              height: 15,
            ),
                TextField(
              decoration: const InputDecoration(
                hintText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(4.0))
                  )
              ),
              onChanged: (value) {
                _email = value;
              },
            ),
                const SizedBox(
              height: 15,
            ),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                  hintText: 'Passwort',
                  border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(4.0))
                  )
              ),
              onChanged: (value) {
                _password = value;
              },
            ),
                const SizedBox(
              height: 40,
            ),
                RoundedButton(
              btnText: 'Account erstellen',
              onBtnPressed: () => createAccountPressed(),
            ),
                const SizedBox(
              height: 40,
            ),
            ],
          )
          )
        ),
      )
      )
    );
  }
}
