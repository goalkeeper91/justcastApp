import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:justcast_app/screen/legal/agb.dart';
import 'package:justcast_app/screen/legal/datasecure.dart';
import 'package:justcast_app/screen/legal/impressum.dart';
import 'package:justcast_app/widget/change_theme_button_widget.dart';
import 'package:justcast_app/widget/rounded_button.dart';
import 'package:justcast_app/screen/dashboard.dart';
import 'package:justcast_app/screen/register.dart';
import 'package:http/http.dart' as http;
import 'package:justcast_app/services/auth_services.dart';
import 'package:justcast_app/services/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email = '';
  String _password = '';
  bool isAuth = false;
  bool rememberMe = false;
  bool hidePassword = true;

  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if(token != null) {
      setState(() {
        isAuth = true;
      });
    }
    if(isAuth){
        final prefs = await SharedPreferences.getInstance();
        userAuth = prefs.getString('username');
        casterId = prefs.getInt('casterId');
        userEmail = prefs.getString('email');
        if(casterId != null){
          isCaster = true;
        }
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => const Dashboard()
          ));
    }
  }

  loginPressed() async {
    if(_email.isNotEmpty && _password.isNotEmpty) {
      if(rememberMe == true) {
        http.Response response = await AuthServices.login(_email, _password);
        Map responseMap = jsonDecode(response.body);
        if(response.statusCode==200) {
          userAuth = responseMap['user']['username'];
          userId = responseMap['user']['id'];
          userEmail = responseMap['user']['email'];
          casterId = responseMap['caster']?['id'];
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('username', responseMap['user']['username']);
          prefs.setInt('casterId', responseMap['caster']?['id']);
          prefs.setString('email', responseMap['user']['email']);
          prefs.setString('token', responseMap['token']);
          if(casterId != null){
            isCaster = true;
          }
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) => const Dashboard()
              ));
        }else{
          errorSnackBar(context, responseMap.values.first);
        }
      }else{
      http.Response response = await AuthServices.login(_email, _password);
      Map responseMap = jsonDecode(response.body);
      if(response.statusCode==200) {
          userAuth = responseMap['user']['username'];
          userId = responseMap['user']['id'];
          userEmail = responseMap['user']['email'];
          casterId = responseMap['caster']?['id'];
          if(casterId != null){
            isCaster = true;
          }
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => const Dashboard()
            ));
      }else{
        errorSnackBar(context, responseMap.values.first);
      }}
    }else {
      errorSnackBar(context, 'Bitte fülle alle Felder aus');
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
                Expanded(
                  flex: 1,
                   child: Image.asset(
                        isDarkMode
                        ? 'assets/images/logo_white.png'
                        : 'assets/images/logo_black.png',
                        fit: BoxFit.contain,
                        height: 80,
                      ),
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
                           const ChangeThemeButtonWidget(),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).primaryColor,
            ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
              const Text(
                'Login',
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
                  prefixIcon: Icon(Icons.email),
                  hintText: 'Email',
                ),
                onChanged: (value) {
                  _email = value;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                obscureText: hidePassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: 'Passwort',
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      icon: Icon(hidePassword? Icons.visibility_off : Icons.visibility),
                  )
                ),
                onChanged: (value) {
                  _password = value;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    checkColor: Theme.of(context).backgroundColor,
                    value: rememberMe,
                    onChanged: (bool? value) {
                      setState(() {
                        rememberMe = value!;
                      });
                    },
                ),
                  Text(
                    'Remember Me',
                    style: TextStyle(
                      color: Colors.grey.shade400
                    )
                  ),
                ]
              ),
              const SizedBox(
                height: 40,
              ),
              RoundedButton(
                btnText: 'Login',
                onBtnPressed: () => loginPressed(),
              ),
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const Register(),
                      ));
                },
                child:  const Text(
                  'Registrieren',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
        ),
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
