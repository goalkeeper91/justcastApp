import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:justcast_app/class/event.dart';
import 'package:justcast_app/class/game.dart';
import 'package:justcast_app/screen/add_new_match.dart';
import 'package:justcast_app/screen/agb.dart';
import 'package:justcast_app/screen/datasecure.dart';
import 'package:justcast_app/screen/detail_match.dart';
import 'package:justcast_app/screen/impressum.dart';
import 'package:justcast_app/services/dashboard_service.dart';
import 'package:justcast_app/services/globals.dart';
import 'package:justcast_app/class/match.dart';
import 'package:justcast_app/services/navigation_service.dart';
import 'package:http/http.dart' as http;
import 'package:justcast_app/widget/change_theme_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

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
  int index = 0;
  var i = 1;
  AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  void initState() {
    getGameData();
    getEventData();
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

  detailMatch(int i) {
    var j = 0;
    if(_matches[i].event < 8){
      j = 1;
    }else if(_matches[i].event > 8){
      j = 2;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => DetailMatch(match: _matches[i],game: _games[_matches[i].game-1],event: _events[_matches[i].event-j])
    ));
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
                if(isCaster == true)
                  const PopupMenuItem<int>(
                  value: 4,
                  child: Text("Zu übertragende Spiele"),
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).primaryColor,
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
                                if(_matches.isNotEmpty) {
                                  if (snapshot.data != null) {
                                    return ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: _matches.length,
                                        itemBuilder: (context, i) {
                                          return Card(
                                            color: (_matches[i].status ==
                                                'accepted') ? Colors
                                                .greenAccent[700] : Theme
                                                .of(context)
                                                .primaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(10),
                                            ),
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                backgroundImage: AssetImage(
                                                  ('assets/images/games/' +
                                                      _matches[i].game
                                                          .toString() + '.png'),
                                                ),
                                              ),
                                              title: TextButton(
                                                  style: TextButton.styleFrom(
                                                    textStyle: const TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  onPressed: () => detailMatch(i),
                                                  child: Align(
                                                      alignment: Alignment
                                                          .center,
                                                      child: Text(
                                                        _matches[i].team +
                                                            '\n vs. ' + '\n' +
                                                            _matches[i].enemy,
                                                        textAlign: TextAlign
                                                            .center,
                                                        style: TextStyle(
                                                          decoration: TextDecoration
                                                              .underline,
                                                          color: (_matches[i]
                                                              .status ==
                                                              'accepted')
                                                              ? Colors.black
                                                              : Colors.blue
                                                              .shade600,
                                                        ),
                                                      ))),
                                              subtitle:
                                              Column(
                                                children: [Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .start,
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 12,
                                                        backgroundImage: AssetImage(
                                                          ('assets/images/events/' +
                                                              _matches[i].game
                                                                  .toString() +
                                                              '/' +
                                                              _matches[i].event
                                                                  .toString() +
                                                              '.png'),
                                                        ),
                                                      ),
                                                      if(_matches[i].event < 8)
                                                        Text(' '+_events[_matches[i].event-1].name,
                                                            style: const TextStyle(
                                                              fontSize: 12,
                                                            )
                                                        ),
                                                      if(_matches[i].event > 8)
                                                        Text(' '+_events[_matches[i].event-2].name,
                                                            style: const TextStyle(
                                                              fontSize: 12,
                                                            )
                                                        ),
                                                    ]
                                                ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .start,
                                                    children: [
                                                      const Icon(
                                                          Icons.access_time
                                                      ),
                                                      Text(' ' +
                                                          DateFormat(
                                                              'EEEE, dd.MM.yyyy HH:mm',
                                                              'de_DE').format(
                                                              DateTime.parse(
                                                                  _matches[i]
                                                                      .scheduledFor)) +
                                                          ' Uhr',
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
                                  else {
                                    return const Text('Lädt....');
                                  }
                                }
                                else {return Card(
                                  color: Theme.of(context).primaryColor,
                                  shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    child: Text('Du hast noch keine Spiele angefragt!'),));}
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
                          decoration: ShapeDecoration(
                          color: Theme.of(context).backgroundColor,
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
