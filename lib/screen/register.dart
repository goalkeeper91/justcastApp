import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:justcast_app/screen/agb.dart';
import 'package:justcast_app/screen/datasecure.dart';
import 'package:justcast_app/screen/impressum.dart';
import 'package:justcast_app/widget/change_theme_button_widget.dart';
import 'package:justcast_app/widget/rounded_button.dart';
import 'package:justcast_app/screen/dashboard.dart';
import 'package:justcast_app/screen/login.dart';
import 'package:justcast_app/services/auth_services.dart';
import 'package:http/http.dart' as http;
import 'package:justcast_app/services/globals.dart';
import 'package:url_launcher/url_launcher.dart';


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
        userId = responseMap['user']['id'];
        userEmail = responseMap['user']['email'];
        casterId = responseMap['caster']?['id'];
        userAuth = responseMap['user']['username'];
        Navigator.pushReplacement(context,
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: Theme.of(context).backgroundColor,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () async {
                    launch('https://discord.gg/WYfmfzskwr');
                  },
                  icon: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: AssetImage('assets/images/discord.png')),),),
                ),
                const SizedBox(
                  width: 50,
                ),
                Image.asset(
                  isDarkMode
                      ? 'assets/images/logo_white.png'
                      : 'assets/images/logo_black.png',
                  fit: BoxFit.contain,
                  height: 80,
                ),
                  ]
              ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Column(
                      children: [
                        ChangeThemeButtonWidget(),
                      ]
                  ),
                ),
              ];
            },
            onSelected: (value) {if(value == 0) {
              ;
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
          color: Theme.of(context).primaryColor,
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
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const Login(),
                      ));
                },
                child:  const Text(
                  'Login',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          )
          )
        ),
      )
      ),
      persistentFooterButtons: [
        GestureDetector(
          onTap: (){
            Navigator.pushReplacement(context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const AGB(),
                ));
          },
          child:  const Text(
            'AGB',
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            Navigator.pushReplacement(context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const DataSecure(),
                ));
          },
          child:  const Text(
            'Datenschutz',
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        GestureDetector(
          onTap: (){
            Navigator.pushReplacement(context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const Impressum(),
                ));
          },
          child:  const Text(
            'Impressum',
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
