import 'package:flutter/material.dart';
import 'package:justcast_app/screen/legal/agb.dart';
import 'package:justcast_app/screen/legal/datasecure.dart';
import 'package:justcast_app/screen/legal/impressum.dart';
import 'package:justcast_app/services/globals.dart';
import 'package:justcast_app/services/navigation_service.dart';
import 'package:url_launcher/url_launcher.dart';

class Option extends StatefulWidget {
  const Option({Key? key}) : super(key: key);

  @override
  _OptionState createState() => _OptionState();
}

class _OptionState extends State<Option> {

  safePressed() async {

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
                  if(userAuth != "")
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text("Meine Anfragen"),
                  ),
                  if(userAuth != "")
                    const PopupMenuItem<int>(
                      value: 4,
                      child: Text("Angefragte Spiele"),
                    ),
                  if(userAuth != "")
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text("Mein Profil"),
                  ),
                  if(userAuth != "")
                  const PopupMenuItem<int>(
                    value: 3,
                    child: Text("Logout"),
                  ),
                  if(userAuth == "")
                  const PopupMenuItem<int>(
                    value: 5,
                    child: Text("Login"),
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
                }else if(value == 3) {
                  userAuth = "";
                  NavigationService.onPressedLogout(context);
                }else if(value == 5) {
                  NavigationService.onPressedLogin(context);
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
                        children: const [
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              hintText: 'Email',
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Passwort',
                            ),
                          ),
                          SizedBox(
                            height: 40,
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