import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:justcast_app/widget/change_theme_button_widget.dart';
import 'package:justcast_app/widget/rounded_button.dart';
import 'package:justcast_app/screen/dashboard.dart';
import 'package:justcast_app/screen/register.dart';
import 'package:http/http.dart' as http;
import 'package:justcast_app/services/auth_services.dart';
import 'package:justcast_app/services/globals.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String _email = '';
  String _password = '';

  loginPressed() async {
    if(_email.isNotEmpty && _password.isNotEmpty) {
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
      }
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Passwort',
                ),
                onChanged: (value) {
                  _password = value;
                },
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
              )
            ],
          ),
        )
        )
        )
        )
    );
  }
}