import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:justcast_app/class/caster.dart';
import 'package:justcast_app/class/event.dart';
import 'package:justcast_app/class/game.dart';
import 'package:justcast_app/rounded_button.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:justcast_app/screen/dashboard.dart';
import 'package:justcast_app/services/globals.dart';
import 'package:justcast_app/services/match_services.dart';
import 'package:justcast_app/services/navigation_service.dart';
import 'package:smart_select/smart_select.dart';
import 'package:http/http.dart' as http;


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
  final String _user = userAuth;
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
          Caster caster = Caster(c['id'], c['username']);
          casterList.add(
              S2Choice<String>(value: caster.id.toString(), title: caster.username));
        }
        return casterList;
    }else {
      throw Exception('Daten konnten nicht geladen werden');
    }
  }

  requestMatchPressed() async {
    http.Response response = await MatchServices.requestMatch(int.tryParse(_game), int.tryParse(_event), _user, _caster, _team, _enemy, _matchlink, _infos, _scheduledfor, _isexclusive);
    Map responseMap = jsonDecode(response.body);
    if(response.statusCode==200){
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => const Dashboard()
          ));
    }else{
      errorSnackBar(context, 'Match wurde bereits angefragt.');
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
                    child: Text("Meine Anfragen"),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text("Mein Profil"),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Text("Optionen"),
                  ),
                  PopupMenuItem<int>(
                    value: 3,
                    child: Text("Logout"),
                  ),
                ];
              },
              onSelected: (value) {
                if(value == 0) {
                  NavigationService.onPressedDashboard(this.context);
                }else if(value == 1) {
                  print("Mein Profil");
                }else if(value == 2) {
                  print("Optionen ausgewählt");
                }else if(value == 3) {
                  userAuth = "";
                  NavigationService.onPressedLogout(this.context);
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
                                  title: 'Spiel auswählen',
                                  value: _game,
                                  choiceItems: gameList,
                                  onChange: (state) => setState(() => _game = state.value.toString() ),
                                  modalConfig: S2ModalConfig(
                                    type: S2ModalType.bottomSheet,
                                  ),
                                  modalStyle: S2ModalStyle(
                                    backgroundColor: Colors.white
                                  )
                          ),
                          SmartSelect.single(
                                title: 'Liga auswählen',
                                value: _event,
                                choiceItems: eventList,
                                onChange: (state) => setState(() => _event = state.value.toString()),
                                modalConfig: S2ModalConfig(
                                type: S2ModalType.bottomSheet,
                                ),
                                modalStyle: S2ModalStyle(
                                    backgroundColor: Colors.white
                                )
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            decoration: const InputDecoration(
                                hintText: 'Anfragendes Team',
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
                                hintText: 'Gegnerisches Team',
                            ),
                            onChanged: (value) {
                              _enemy = value;
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextField(decoration: const InputDecoration(
                                hintText: 'Matchlink',
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
                                      print('change $date');
                                    }, onConfirm: (date) {
                                      print('confirm $date');
                                    }, currentTime: DateTime.now(), locale: LocaleType.de);
                              },
                              child: Text(
                                'Datum und Uhrzeit auswählen',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 21,
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
                                modalConfig: S2ModalConfig(
                                  type: S2ModalType.bottomSheet,
                                ),
                                modalStyle: S2ModalStyle(
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
                            Text(
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
        )
    );
  }
}
