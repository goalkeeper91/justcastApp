import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:justcast_app/class/caster.dart';
import 'package:justcast_app/class/event.dart';
import 'package:justcast_app/class/game.dart';
import 'package:justcast_app/screen/add_new_match.dart';
import 'package:justcast_app/screen/detail_match.dart';
import 'package:justcast_app/services/dashboard_service.dart';
import 'package:justcast_app/services/globals.dart';
import 'package:justcast_app/class/match.dart';
import 'package:justcast_app/services/navigation_service.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  
  var url = Uri.parse(baseURL+'auth/dashboard');
  List<Match> _matches = [];
  List<Game> _games = [];
  List<Event> _events = [];
  List<Caster> _casters = [];
  int index = 0;
  AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  void initState() {
    getGameData();
    getEventData();
    getCasterData();
    initializeDateFormatting('de_DE', null);
    super.initState();
  }

  Future getMatches() async {
    http.Response response = await DashboardService.dashboard(userAuth);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      var jsonData = map['matches'];
      for (var e in jsonData) {
        Match match = Match(
          e['id'],
          e['user_id'],
          e['game_id'],
          e['event_id'],
          e['caster_id'],
          e['team'],
          e['enemy'],
          e['matchlink'],
          e['scheduled_for'.toString()],
          e['is_exclusive'],
          e['infos'],
          e['status'],
          e['stream'],
          e['caster_accepted'],
        );
        _matches.add(match);
      }
      return _matches;
    }else {
      throw Exception('Daten konnten nicht geladen werden');
    }
  }

  Future getGameData() async {
    http.Response response = await DashboardService.dashboard(userAuth);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      List<dynamic> jsonData = map['games'];
      for (var e in jsonData) {
        Game game = Game(e['id'], e['name']);
        _games.add(game);
      }
      return _games;

    }else {
      throw Exception('Daten konnten nicht geladen werden');
    }
  }

  Future getEventData() async {
    http.Response response = await DashboardService.dashboard(userAuth);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      List<dynamic> jsonData = map['events'];
      for (var e in jsonData) {
        Event event = Event(e['id'], e['name']);
        _events.add(event);
      }
      return _events;
    }else {
      throw Exception('Daten konnten nicht geladen werden');
    }
  }

  Future getCasterData() async {
    http.Response response = await DashboardService.dashboard(userAuth);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      List<dynamic> jsonData = map['casters'];
      for (var c in jsonData) {
        Caster caster = Caster(c['id'], c['username']);
        _casters.add(caster);
      }
      return _casters;
    }else {
      throw Exception('Daten konnten nicht geladen werden');
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
                NavigationService.onPressedDashboard(context);
              }else if(value == 1) {
                print("Mein Profil");
              }else if(value == 2) {
                print("Optionen ausgewählt");
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFAFAF8EB),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Column(
                        children: const [
                          Text(
                            'Meine Anfragen',
                            style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            ),
                          ),
                          ]
                      ),
                    ),
              ),
                        const SizedBox(
                          height:  5,
                        ),
                        Column(
                            children: [ FutureBuilder(
                              future: this._memoizer.runOnce(() => getMatches()),
                              builder: (context, AsyncSnapshot snapshot){
                                if(snapshot.data != null) {
                                 return ListView.builder(
                                     physics: const NeverScrollableScrollPhysics(),
                                     scrollDirection: Axis.vertical,
                                     shrinkWrap: true,
                                     itemCount: _matches.length,
                                     itemBuilder: (context, i) {
                                         return Card(
                                              color: (_matches[i].status == 'accepted') ? Colors.greenAccent[700] : Colors.blueGrey[50],
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                    ('assets/images/games/'+_matches[i].game.toString()+'.png'),
                                                ),
                                                ),
                                                title: TextButton(
                                                    style: TextButton.styleFrom(
                                                      textStyle: const TextStyle(
                                                          fontSize: 15,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pushReplacement(context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext context) => DetailMatch(id: _matches[i].id, event: _matches[i].event, game: _matches[i].game)
                                                        ));
                                                    },
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                    child: Text(
                                                        _matches[i].team + '\n vs. ' + '\n'+_matches[i].enemy,
                                                      textAlign: TextAlign.center,
                                                      style: const TextStyle(
                                                        decoration: TextDecoration.underline,
                                                      color: Colors.black,
                                                    ),
                                                    ))),
                                                subtitle:
                                                    Column(
                                                      children: [Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                        CircleAvatar(
                                                          radius: 12,
                                                          backgroundImage: AssetImage(
                                                          ('assets/images/events/'+_matches[i].game.toString()+'/'+_matches[i].event.toString()+'.png'),
                                                        ),
                                                        ),
                                                        Text(' '+_events[snapshot.data[i].event].name,
                                                          style: const TextStyle(
                                                          fontSize: 12,
                                                        )
                                                        ),
                                                        ]
                                                      ),
                                                       Row(
                                                         mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                        Icon(
                                                          Icons.access_time
                                                        ),
                                                        Text(' '+
                                                        DateFormat('EEEE, dd.MM.yyyy HH:mm', 'de_DE').format(DateTime.parse(_matches[i].scheduledFor))+ ' Uhr',
                                                        style: const TextStyle(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                    ],
                                                    ),
                                                ],
                                                ),
                                           ),
                                         );
                                     }
                                 );
                                }
                                else {return const Text('Lädt....');}
                              },
                            )
              ]
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Ink(
                          decoration: const ShapeDecoration(
                          color: Colors.white,
                          shape: CircleBorder()),
                            child: IconButton(
                              iconSize: 35,
                              onPressed: () {
                              Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (BuildContext context) => const AddNewMatch()
                              ));
                              },
                              icon: const Icon(Icons.add)),
                  ),
                ),
    ]
              ),
    ),
    ),
      ),
    );
  }
}
