import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:justcast_app/class/match.dart';
import 'package:justcast_app/services/globals.dart';
import 'package:justcast_app/services/match_services.dart';
import 'package:justcast_app/services/navigation_service.dart';

class DetailMatch extends StatefulWidget {

  final int id = 0;
  final int event = 0;
  final int game = 0;

  const DetailMatch({Key? key, id, event, game}) : super(key: key);

  @override
  _DetailMatchState createState() => _DetailMatchState();
}

class _DetailMatchState extends State<DetailMatch> {

  Match match = Match(0, 0, 0, 0, 0, "", "", "", "", false, "", "", "", 0);
  String game = "";
  String event = "";
  var buttonText = "";

  Future getEvent() async {
    http.Response response = await MatchServices.detailMatch(null, null,widget.event);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      event = map[event];
      return event;
    }else {
      throw Exception('Daten konnten nicht geladen werden');
    }
  }

  Future getGame() async {
    http.Response response = await MatchServices.detailMatch(null,widget.game,null);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      game = map[game];
      return game;
    }else {
      throw Exception('Daten konnten nicht geladen werden');
    }
  }

  Future getMatches() async {
    http.Response response = await MatchServices.detailMatch(widget.id,null,null);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      match = map[match];
      return match;
    }else {
      throw Exception('Daten konnten nicht geladen werden');
    }
  }

  setText() {
    if(match.status == 'requested') {
      buttonText = 'Match akzeptieren';
      return buttonText;
    }else if (match.status == 'accepted') {
      buttonText = 'Match freigeben';
      return buttonText;
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
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ),
                        onPressed: (){},
                        child: Text(setText()),
                    ),
                    const SizedBox(width: 8,),
                    ElevatedButton(
                          style: ElevatedButton.styleFrom(
                          primary: Colors.grey[300],
                        ),
                        onPressed: (){},
                        child: const Text('Match Abbrechen'),
                    ),
                  ],
                ),
                Card(
                    child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                           children: const [Text('Matchinformation'),]
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Spiel'),
                              Text(game),
                            ],
                          )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}