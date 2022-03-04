import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:justcast_app/class/caster.dart';
import 'package:justcast_app/class/event.dart';
import 'package:justcast_app/class/game.dart';
import 'package:justcast_app/screen/legal/agb.dart';
import 'package:justcast_app/screen/legal/datasecure.dart';
import 'package:justcast_app/screen/legal/impressum.dart';
import 'package:justcast_app/widget/change_theme_button_widget.dart';
import 'package:justcast_app/widget/rounded_button.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:justcast_app/screen/dashboard.dart';
import 'package:justcast_app/services/globals.dart';
import 'package:justcast_app/services/match_services.dart';
import 'package:justcast_app/services/navigation_service.dart';
import 'package:smart_select/smart_select.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


class AddNewMatch extends StatefulWidget {
  const AddNewMatch({Key? key}) : super(key: key);

  @override
  _AddNewMatchState createState() => _AddNewMatchState();
}

class _AddNewMatchState extends State<AddNewMatch> {
  String _game = "";
  String _event = "";
  String _caster = "";
  String _team = "";
  String _enemy= "";
  String _matchlink = "";
  String _infos = "";
  DateTime _scheduledfor = DateTime.now();
  bool _isexclusive = false;
  var url = Uri.parse(baseURL+'request');
  List<S2Choice<String>> gameList = [];
  List<S2Choice<String>> eventList = [];
  List<S2Choice<String>> casterList = [];

  @override
    void initState() {
    getGameData();
    getEventData();
    getCasterData();
    super.initState();
  }

  Future getGameData() async {
    var response = await http.get(url);
    if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        List<dynamic> jsonData = map['games'];
        for (var e in jsonData) {
          Game game = Game(e['id'], e['name']);
          gameList.add(
              S2Choice<String>(value: game.id.toString(), title: game.name));
        }
        return gameList;

      }else {
      throw Exception('Daten konnten nicht geladen werden');
      }
  }

  Future getEventData() async {
    var response = await http.get(url);
    if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        List<dynamic> jsonData = map['events'];
        for (var e in jsonData) {
          Event event = Event(e['id'], e['name']);
          eventList.add(
              S2Choice<String>(value: event.id.toString(), title: event.name));
        }
        return eventList;
    }else {
      throw Exception('Daten konnten nicht geladen werden');
    }
  }

  Future getCasterData() async {
    var response = await http.get(url);
    if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        List<dynamic> jsonData = map['casters'];
        for (var c in jsonData) {
          Caster caster = Caster(c['id'], c['username'], c['chargeable']);
          casterList.add(
              S2Choice<String>(value: caster.id.toString(), title: caster.username));
        }
        return casterList;
    }else {
      throw Exception('Daten konnten nicht geladen werden');
    }
  }

  requestMatchPressed() async {
    if(_game.isNotEmpty && _event.isNotEmpty && _team.isNotEmpty && _enemy.isNotEmpty && _matchlink.isNotEmpty && _scheduledfor.isBefore(DateTime.now())) {
      http.Response response = await MatchServices.requestMatch(
          int.tryParse(_game),
          int.tryParse(_event),
          userId,
          _caster,
          _team,
          _enemy,
          _matchlink,
          _infos,
          _scheduledfor,
          _isexclusive);
      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(
                builder: (BuildContext context) => const Dashboard()
            ));
      } else {
        errorSnackBar(context, 'Match wurde bereits angefragt.');
      }
    } else {
      errorSnackBar(context, 'Bitte fülle die markierten Felder korrekt aus');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: Theme.of(context).backgroundColor,
          title:Row(
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
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text("Mein Profil"),
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
                            'Match Anfragen',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SmartSelect.single(
                                  title: 'Spiel auswählen*',
                                  value: _game,
                                  choiceItems: gameList,
                                  onChange: (state) => setState(() => _game = state.value.toString() ),
                                  modalConfig: const S2ModalConfig(
                                    type: S2ModalType.bottomSheet,
                                  ),
                                  modalStyle: const S2ModalStyle(
                                    backgroundColor: Colors.white
                                  )
                          ),
                          SmartSelect.single(
                                title: 'Liga auswählen*',
                                value: _event,
                                choiceItems: eventList,
                                onChange: (state) => setState(() => _event = state.value.toString()),
                                modalConfig: const S2ModalConfig(
                                type: S2ModalType.bottomSheet,
                                ),
                                modalStyle: const S2ModalStyle(
                                    backgroundColor: Colors.white
                                )
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                                hintText: 'Anfragendes Team*',
                            ),
                            onChanged: (value) {
                              _team = value;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                                hintText: 'Gegnerisches Team*',
                            ),
                            onChanged: (value) {
                              _enemy = value;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextField(decoration: const InputDecoration(
                                hintText: 'Matchlink*',
                            ),
                            onChanged: (value) {
                              _matchlink = value;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextButton(
                              onPressed: () {
                                DatePicker.showDateTimePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime(2018, 3, 5),
                                    maxTime: DateTime(2019, 6, 7), onChanged: (date) {
                                    }, onConfirm: (date) {
                                      _scheduledfor = date;
                                    }, currentTime: DateTime.now(), locale: LocaleType.de);
                              },
                              child: const Text(
                                'Datum und Uhrzeit auswählen*',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                ),
                              )
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SmartSelect.single(
                                title: '(Optional) Caster auswählen',
                                value: _caster,
                                choiceItems: casterList,
                                onChange: (state) => setState(() => _caster = state.value.toString()),
                                modalConfig: const S2ModalConfig(
                                  type: S2ModalType.bottomSheet,
                                ),
                                modalStyle: const S2ModalStyle(
                                    backgroundColor: Colors.white
                                )
                          ),
                          Row(
                          children: [
                            Checkbox(
                            activeColor: Colors.green,
                            checkColor: Colors.white,
                             value: _isexclusive,
                             onChanged: (bool? value) {
                              setState(() {
                                _isexclusive = value!;
                              });
                             }
                          ),
                            const Text(
                                'Exklusiver Cast'
                            ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextField(decoration: const InputDecoration(
                            hintText: 'Weitere Informationen',
                          ),
                            onChanged: (value) {
                              _infos = value;
                            },
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          RoundedButton(
                            btnText: 'Match Anfragen',
                            onBtnPressed: () => requestMatchPressed(),
                          ),
                          const SizedBox(
                            height: 40,
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

