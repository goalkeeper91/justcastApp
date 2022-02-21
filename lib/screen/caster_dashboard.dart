import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:justcast_app/class/event.dart';
import 'package:justcast_app/class/game.dart';
import 'package:justcast_app/screen/detail_match.dart';
import 'package:justcast_app/services/dashboard_service.dart';
import 'package:justcast_app/services/globals.dart';
import 'package:justcast_app/class/match.dart';
import 'package:justcast_app/services/navigation_service.dart';
import 'package:http/http.dart' as http;
import 'package:justcast_app/widget/change_theme_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class CasterDashboard extends StatefulWidget {

  const CasterDashboard({Key? key}) : super(key: key);

  @override
  _CasterDashboardState createState() => _CasterDashboardState();
}

class _CasterDashboardState extends State<CasterDashboard> with TickerProviderStateMixin {

  var url = Uri.parse(baseURL+'auth/dashboard');
  List<Match> _filteredMatches = [];
  List<Match> _requestedMatches = [];
  List<Match> _acceptedMatches = [];
  List<Game> _games = [];
  List<Event> _events = [];
  int index = 0;
  var i = 1;
  AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  void initState() {
    getFilteredMatches();
    getRequestedMatches();
    getGameData();
    getEventData();
    initializeDateFormatting('de_DE', null);
    super.initState();
  }

  Future getFilteredMatches() async {
    http.Response response = await DashboardService.casterDashboard(userAuth);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      var jsonData = map['filteredMatches'];
      if(jsonData != null) {
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
          _filteredMatches.add(match);
        }
      }
      return _filteredMatches;
    }else {
      throw Exception('Daten konnten nicht geladen werden');
    }
  }

  Future getRequestedMatches() async {
    http.Response response = await DashboardService.casterDashboard(userAuth);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      var jsonData = map['requestedMatches'];
      if(jsonData != null) {
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
          _requestedMatches.add(match);
        }
      }
      return _requestedMatches;
    }else {
      throw Exception('Daten konnten nicht geladen werden');
    }
  }

  Future getAcceptedMatches() async {
    http.Response response = await DashboardService.casterDashboard(userAuth);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      var jsonData = map['acceptedMatches'];
      if(jsonData != null) {
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
          _acceptedMatches.add(match);
        }
      }
      return _acceptedMatches;
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

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
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
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("Meine Anfragen"),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text("Mein Profil"),
                ),
                PopupMenuItem<int>(
                  value: 2,
                  child: Column(
                      children: const [
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Expanded(
              child: Column(
              children: [
                TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Angenommen',),
                    Tab(text: 'Exklusive',),
                    Tab(text: 'Angefragte',),
                  ],
                ),
                Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        SingleChildScrollView(
                        child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).primaryColor,
                          ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                child: Column(
                                    children: const [
                                      Text(
                                        'Angenommene Spiele',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]
                                  ),
                                ),
                              ),
                                Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                                  child: Column(
                                    children: [ FutureBuilder(
                                    future: _memoizer.runOnce(() => getAcceptedMatches()),
                                    builder: (context, AsyncSnapshot snapshot){
                                    if(_acceptedMatches.isNotEmpty) {
                                      return ListView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: _acceptedMatches.length,
                                          itemBuilder: (context, i) {
                                        return Card(
                                          color: Theme.of(context).primaryColor,
                                          shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                            backgroundImage: AssetImage(
                                                ('assets/images/games/'+_acceptedMatches[i].game.toString()+'.png'),
                                              ),
                                            ),
                                            title: TextButton(
                                              style: TextButton.styleFrom(
                                              textStyle: const TextStyle(
                                              fontSize: 15,
                                              ),
                                            ),
                                              onPressed: (){
                                              Navigator.pushReplacement(context, MaterialPageRoute(
                                              builder: (context) => DetailMatch(match: _acceptedMatches[i],game: _games[_acceptedMatches[i].game-1],event: _events[_acceptedMatches[i].event])
                                              ));
                                            },
                                              child: Align(
                                              alignment: Alignment.center,
                                                child: Text(
                                                  _acceptedMatches[i].team + '\n vs. ' + '\n'+_acceptedMatches[i].enemy,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                    decoration: TextDecoration.underline,
                                                    color: Colors.blue.shade600,
                                                    ),
                                                ))),
                                                subtitle:
                                            Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                  CircleAvatar(
                                                    radius: 12,
                                                    backgroundImage: AssetImage(
                                                      ('assets/images/events/'+_acceptedMatches[i].game.toString()+'/'+_acceptedMatches[i].event.toString()+'.png'),
                                                    ),
                                                  ),
                                                  Text(' '+_events[_acceptedMatches[i].event-2].name,
                                                    style: const TextStyle(
                                                    fontSize: 12,
                                                    )
                                                  ),
                                                  ]
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                  const Icon(
                                                    Icons.access_time
                                                  ),
                                                  Text(' '+
                                                  DateFormat('EEEE, dd.MM.yyyy HH:mm', 'de_DE').format(DateTime.parse(_acceptedMatches[i].scheduledFor))+ ' Uhr',
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
                                        else {return Card(
                                        color: Theme.of(context).primaryColor,
                                        shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                          child: const Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            child: Text('Du hast momentan keine aktiven Spiele, welche du übertragen musst!'),));}
                                      },
                                      )
                                      ]
                                  ),
                                ),
                                const SizedBox(
                                  height: 40,
                                )
                            ],
                          ),
                      ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Column(
                                      children: const [
                                        Text(
                                          'Exklusive Anfragen',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ]
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                                child: Column(
                                    children: [ FutureBuilder(
                                      future: _memoizer.runOnce(() => getFilteredMatches()),
                                      builder: (context, AsyncSnapshot snapshot){
                                        if(_filteredMatches.isNotEmpty) {
                                          return ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount: _filteredMatches.length,
                                              itemBuilder: (context, i) {
                                                return Card(
                                                  color: Theme.of(context).primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: ListTile(
                                                    leading: CircleAvatar(
                                                      backgroundImage: AssetImage(
                                                        ('assets/images/games/'+_filteredMatches[i].game.toString()+'.png'),
                                                      ),
                                                    ),
                                                    title: TextButton(
                                                        style: TextButton.styleFrom(
                                                          textStyle: const TextStyle(
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                        onPressed: (){
                                                          Navigator.pushReplacement(context, MaterialPageRoute(
                                                              builder: (context) => DetailMatch(match: _filteredMatches[i],game: _games[_filteredMatches[i].game-1],event: _events[_filteredMatches[i].event])
                                                          ));
                                                        },
                                                        child: Align(
                                                            alignment: Alignment.center,
                                                            child: Text(
                                                              _filteredMatches[i].team + '\n vs. ' + '\n'+_filteredMatches[i].enemy,
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                decoration: TextDecoration.underline,
                                                                color: Colors.blue.shade600,
                                                              ),
                                                            ))),
                                                    subtitle:
                                                    Column(
                                                      children: [
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 12,
                                                                backgroundImage: AssetImage(
                                                                  ('assets/images/events/'+_filteredMatches[i].game.toString()+'/'+_filteredMatches[i].event.toString()+'.png'),
                                                                ),
                                                              ),
                                                              Text(' '+_events[_filteredMatches[i].event-2].name,
                                                                  style: const TextStyle(
                                                                    fontSize: 12,
                                                                  )
                                                              ),
                                                            ]
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            const Icon(
                                                                Icons.access_time
                                                            ),
                                                            Text(' '+
                                                                DateFormat('EEEE, dd.MM.yyyy HH:mm', 'de_DE').format(DateTime.parse(_filteredMatches[i].scheduledFor))+ ' Uhr',
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
                                        else {return Card(
                                                color: Theme.of(context).primaryColor,
                                                shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                            ),
                                                child: const Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                  child: Text('Aktuell existieren keine exklusiven Anfragen')));}
                                      },
                                    )
                                    ]
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              )
                            ],
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Column(
                                      children: const [
                                        Text(
                                          'Offene Anfragen',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ]
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                                child: Column(
                                    children: [ FutureBuilder(
                                      future: _memoizer.runOnce(() => getRequestedMatches()),
                                      builder: (context, AsyncSnapshot snapshot){
                                        if(_requestedMatches.isNotEmpty) {
                                          return ListView.builder(
                                              physics: const NeverScrollableScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount: _requestedMatches.length,
                                              itemBuilder: (context, i) {
                                                return Card(
                                                  color: Theme.of(context).primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: ListTile(
                                                    leading: CircleAvatar(
                                                      backgroundImage: AssetImage(
                                                        ('assets/images/games/'+_requestedMatches[i].game.toString()+'.png'),
                                                      ),
                                                    ),
                                                    title: TextButton(
                                                        style: TextButton.styleFrom(
                                                          textStyle: const TextStyle(
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                        onPressed: (){
                                                          Navigator.pushReplacement(context, MaterialPageRoute(
                                                              builder: (context) => DetailMatch(match: _requestedMatches[i],game: _games[_requestedMatches[i].game-1],event: _events[_requestedMatches[i].event])
                                                          ));
                                                        },
                                                        child: Align(
                                                            alignment: Alignment.center,
                                                            child: Text(
                                                              _requestedMatches[i].team + '\n vs. ' + '\n'+_requestedMatches[i].enemy,
                                                              textAlign: TextAlign.center,
                                                              style: TextStyle(
                                                                decoration: TextDecoration.underline,
                                                                color: Colors.blue.shade600,
                                                              ),
                                                            ))),
                                                    subtitle:
                                                    Column(
                                                      children: [
                                                        Row(
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 12,
                                                                backgroundImage: AssetImage(
                                                                  ('assets/images/events/'+_requestedMatches[i].game.toString()+'/'+_requestedMatches[i].event.toString()+'.png'),
                                                                ),
                                                              ),
                                                              Text(' '+_events[_requestedMatches[i].event-2].name,
                                                                  style: const TextStyle(
                                                                    fontSize: 12,
                                                                  )
                                                              ),
                                                            ]
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            const Icon(
                                                                Icons.access_time
                                                            ),
                                                            Text(' '+
                                                                DateFormat('EEEE, dd.MM.yyyy HH:mm', 'de_DE').format(DateTime.parse(_requestedMatches[i].scheduledFor))+ ' Uhr',
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
                                        else {return Card(
                                            color: Theme.of(context).primaryColor,
                                            shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                        ),
                                          child: const Padding(padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            child: Text('Aktuell existieren keine Anfragen für neue Matches')));}
                                      },
                                    )
                                    ]
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              )
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
            ]
            ),
            ),
          ]
      ),
      );
  }
}
