import 'package:flutter/material.dart';
import 'package:justcast_app/class/appColors.dart';
import 'package:justcast_app/screen/legal/agb.dart';
import 'package:justcast_app/screen/dashboard.dart';
import 'package:justcast_app/screen/legal/datasecure.dart';
import 'package:justcast_app/screen/legal/impressum.dart';
import 'package:justcast_app/screen/login.dart';
import 'package:justcast_app/services/auth_services.dart';
import 'package:justcast_app/services/globals.dart';
import 'package:justcast_app/services/navigation_service.dart';
import 'package:justcast_app/widget/change_theme_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? _username = userAuth;
  String _password = "";
  String _passwordCheck = "";
  String? _email = userEmail;
  var _buttonColor;

  safePressed() async {
    if (_email != null) {
      if (_password.isEmpty) {
        http.Response response = await AuthServices.update(
            userAuth, _username, _email, _password);
        if (response.statusCode == 200) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const Dashboard()
              ));
        }
        } else if (_password == _passwordCheck) {
          http.Response response = await AuthServices.update(
              userAuth, _username, _email, _password);
          if (response.statusCode == 200) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(
                    builder: (BuildContext context) => const Dashboard()
                ));
          }
        }else {
            errorSnackBar(context, 'Passwörter stimmen nicht überein');
          }
      }else {
        errorSnackBar(context, 'Bitte fülle alle Felder aus');
      }
    }

    deletePressed() async {
      http.Response response = await AuthServices.delete(userAuth);
      if(response.statusCode == 200) {
        userAuth = "";
          Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(context,
            MaterialPageRoute(
            builder: (BuildContext context) => const Login()
        ));
      }
    }

  showAlertDialog() async {
    Widget okButton = TextButton(
      child: const Text('OK'),
      onPressed: () {
        deletePressed();
        },
    );
    Widget cancelButton = TextButton(
      child: const Text('Abbrechen'),
      onPressed:  () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text('Profil Löschen'),
      content: const Text('Möchtest du dein Profil wirklich löschen?'),
      actions: [
        okButton,
        cancelButton
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  getButtonColor() async {
    _buttonColor = Colors.white;
    return _buttonColor;
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
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("Meine Anfragen"),
                  ),
                  if(isCaster == true)
                    const PopupMenuItem<int>(
                      value: 4,
                      child: Text("Angefragte Spiele"),
                    ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Column(
                        children: [
                          ChangeThemeButtonWidget(),
                        ]
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 3,
                    child: Text("Logout"),
                  ),
                ];
              },
              onSelected: (value) {
                if(value == 0) {
                  NavigationService.onPressedDashboard(context);
                }else if(value == 4) {
                  NavigationService.onPressedCasterDashboard(context);
                }else if(value == 1) {
                  NavigationService.onPressedProfile(context);
                }else if(value == 2) {
                  ;
                }else if(value == 3) {
                  userAuth = "";
                  NavigationService.onPressedLogout(context);
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
                            'Accountinformationen',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: TextEditingController(text: userAuth),
                            decoration: const InputDecoration(
                              hintText: 'Benutzername',
                            ),
                            onChanged: (value) {
                              _username = value;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextField(
                            controller: TextEditingController(text: userEmail),
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
                            height: 15,
                          ),
                          TextField(
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: 'Passwort wiederholen',
                            ),
                            onChanged: (value) {
                              _passwordCheck = value;
                            },
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blueAccent
                                ),
                              child: Text('Speichern',
                                style: TxtStyle(),
                              ),
                              onPressed: safePressed,
                            ),
                              const SizedBox(
                                width: 20,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red
                                ),
                                child: Text('Profil Löschen',
                                  style: TxtStyle(),
                                ),
                                onPressed: () {showAlertDialog();},
                              ),
                          ]
                          ),
                        ],
                      ),
                    )
                )
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
