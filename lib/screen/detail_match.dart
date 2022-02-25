import 'dart:convert';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:justcast_app/class/comments.dart';
import 'package:justcast_app/class/event.dart';
import 'package:justcast_app/class/game.dart';
import 'package:justcast_app/class/match.dart';
import 'package:justcast_app/class/user.dart';
import 'package:justcast_app/screen/legal/agb.dart';
import 'package:justcast_app/screen/dashboard.dart';
import 'package:justcast_app/screen/legal/datasecure.dart';
import 'package:justcast_app/screen/legal/impressum.dart';
import 'package:justcast_app/services/globals.dart';
import 'package:justcast_app/services/match_services.dart';
import 'package:justcast_app/services/navigation_service.dart';
import 'package:justcast_app/widget/change_theme_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class DetailMatch extends StatefulWidget {

  final Match match;
  final Event event;
  final Game game;

  const DetailMatch({Key? key, required this.match, required this.game, required this.event}) : super(key: key);

  @override
  _DetailMatchState createState() => _DetailMatchState(match,game,event);
}

class _DetailMatchState extends State<DetailMatch> {

  final Match match;
  final Event event;
  final Game game;
  String _status = "";
  String comment = "";
  bool isChargeable = false;
  var _color;
  var i = 1;
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  final List<Comments> _comments = [];
  final List<User> _users = [];
  _DetailMatchState(this.match, this.game, this.event);


  var buttonText = "";

  @override
  void initState() {
    getUsers();
    initializeDateFormatting('de_DE', null);
    super.initState();
  }

  Future getComments() async {
    http.Response response = await MatchServices.comments(match.id);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      List<dynamic> jsonData = map['comments'];
      for (var e in jsonData) {
        Comments comment = Comments(e['id'],e['user_id'],e['content'],e['created_at'.toString()]);
        _comments.add(comment);
      }
      return _comments;
    }else {
      throw Exception('Daten konnten nicht geladen werden');
    }
  }

  Future commentSendPress() async {
    if(comment.isNotEmpty){
      http.Response response = await MatchServices.comment(comment, userAuth, match.id);
      Map responseMap = jsonDecode(response.body);
      if(response.statusCode==200) {
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

  Future acceptCasterPress() async {
    http.Response response = await MatchServices.acceptCaster(match.id);
    Map responseMap = jsonDecode(response.body);
    if(response.statusCode==200) {Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const Dashboard()
        ));
    }else{
      errorSnackBar(context, responseMap.values.first);
    }
  }

  Future acceptPress() async {
    http.Response response = await MatchServices.accept(match.id, userAuth);
    if(response.statusCode==200) { Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const Dashboard()
        ));
    }else{
      errorSnackBar(context, '');
    }
  }

  Future cancelPress() async {
    http.Response response = await MatchServices.cancel(match.id);
    Map responseMap = jsonDecode(response.body);
    if(response.statusCode==200) {Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const Dashboard()
        ));
    }else{
      errorSnackBar(context, responseMap.values.first);
    }
  }

  Future payedPress() async {
    http.Response response = await MatchServices.payed(match.id);
    Map responseMap = jsonDecode(response.body);
    if(response.statusCode==200) {Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const Dashboard()
        ));
    }else{
      errorSnackBar(context, responseMap.values.first);
    }
  }

  Future setRequestPress() async {
    http.Response response = await MatchServices.setRequest(match.id, userAuth);
    Map responseMap = jsonDecode(response.body);
    if(response.statusCode==200) {Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const Dashboard()
        ));
    }else{
      errorSnackBar(context, responseMap.values.first);
    }
  }

  Future denieCastPress() async {
    http.Response response = await MatchServices.denieCast(match.id);
    Map responseMap = jsonDecode(response.body);
    if(response.statusCode==200) {Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const Dashboard()
        ));
    }else{
      errorSnackBar(context, responseMap.values.first);
    }
  }

  Future declinePress() async {
    http.Response response = await MatchServices.decline(match.id, userAuth);
    Map responseMap = jsonDecode(response.body);
    if(response.statusCode==200) {Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => const Dashboard()
        ));
    }else{
      errorSnackBar(context, responseMap.values.first);
    }
  }

  Future getUsers() async {
    http.Response response = await MatchServices.comments(match.id);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      List<dynamic> jsonData = map['users'];
      for (var e in jsonData) {
        User user = User(e['id'],e['username'.toString()],e['email'.toString()]);
          _users.add(user);
      }
      return _users;
    }else {
      throw Exception('Daten konnten nicht geladen werden');
    }
  }

  Future getPayedMatches() async {
    http.Response response = await MatchServices.payedMatch(match.id);
    if (response.statusCode == 200) {
      if(response.body == 'true') {
        isChargeable = true;
      }else {
        isChargeable = false;
      }
      return isChargeable;
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

  setColor() {
    if(match.status == 'accepted') {
      _color = Colors.red;
      return _color;
    }else if(match.status == 'requested') {
      _color = Colors.green;
      return _color;
    }
  }

  setStatus() {
    if(match.status == 'accepted') {
      _status = 'Angenommen';
      return _status;
    }else if(match.status == 'requested') {
      _status = 'Angefragt';
      return _status;
    }else if(match.status == 'cancelled') {
      _status = 'Abgebrochen';
      return _status;
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
                        const ChangeThemeButtonWidget(),
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
            alignment: Alignment.center,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if(match.caster == null && casterId != null || casterId == match.caster)
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: setColor(),
                        ),
                        onPressed: (){
                          if(setText() == 'Match akzeptieren') {
                            acceptPress();
                          }else{
                            setRequestPress();
                          }
                          },
                        child: Text(setText()),
                    ),
                    const SizedBox(width: 8,),
                    if(match.caster == null && userId != match.user || casterId == match.caster)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey[300],
                        ),
                        onPressed: () => declinePress(),
                        child: const Text('Ablehnen'),
                      ),
                    const SizedBox(width: 8,),
                    if(userId == match.user && match.status == 'accepted' && isChargeable == true && DateTime.parse(match.scheduledFor).isAfter(DateTime.now()))
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.grey[300],
                        ),
                        onPressed: () => acceptCasterPress(),
                        child: const Text('Caster Akzeptieren'),
                      ),
                    const SizedBox(width: 8,),
                    if(userId == match.user && match.status == 'accepted' && isChargeable == true && DateTime.parse(match.scheduledFor).isAfter(DateTime.now()))
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red[300],
                        ),
                        onPressed: () => denieCastPress(),
                        child: const Text('Caster Ablehnen'),
                      ),
                    const SizedBox(width: 8,),
                    if(userId == match.user && match.status == 'accepted' && isChargeable == true && DateTime.parse(match.scheduledFor).isBefore(DateTime.now()))
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue[300],
                        ),
                        onPressed: () => payedPress(),
                        child: const Text('Caster bezahlt'),
                      ),
                    const SizedBox(width: 8,),
                    if(userId == match.user && match.caster == null)
                    ElevatedButton(
                          style: ElevatedButton.styleFrom(
                          primary: Colors.grey[300],
                        ),
                        onPressed: () => cancelPress(),
                        child: const Text('Match Abbrechen'),
                    ),
                  ],
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                           children: const [
                             Text(
                             'Matchinformation',
                             style: TextStyle(
                               fontWeight: FontWeight.bold,
                               fontSize: 20,
                           ),),
                           ]
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 45,
                              ),
                              const Text(
                                  'Spiel',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(
                                width: 57,
                              ),
                              Flexible(
                                child: Text(game.name,softWrap: true),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 45,
                              ),
                              const Text(
                                'Liga / Event',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Flexible(
                                child: Text(event.name,softWrap: true),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 45,
                              ),
                              const Text(
                                'Teamname',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(
                                width: 21,
                              ),
                              Flexible(
                                child: Text(match.team,softWrap: true),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 45,
                              ),
                              const Text(
                                'Gegner',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(
                                width: 45,
                              ),
                              Flexible(
                                child: Text(match.enemy,softWrap: true),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 45,
                              ),
                              const Text(
                                'Matchlink',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(
                                width: 26,
                              ),
                              GestureDetector(
                                child: const Text('Zum Match',
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blueAccent
                                  ),
                                ),
                                onTap: () async {
                                 launch(match.matchlink);
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 45,
                              ),
                              const Text(
                                'Spieltermin',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Text(DateFormat('EEEE, dd.MM.yyyy HH:mm', 'de_DE').format(DateTime.parse(match.scheduledFor))+ ' Uhr',),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 45,
                              ),
                              const Text(
                                'Status',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              const SizedBox(
                                width: 47,
                              ),
                              Text(setStatus()),
                            ],
                          ),
                    ],
                  ),
                ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Details',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ]
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 45,
                              ),
                              if(match.infos != null)
                                Flexible(child: Text(match.infos,softWrap: true,))
                              else const Text(
                                  'Keine weiteren Informationen',
                                  style: TextStyle(
                                  fontStyle: FontStyle.italic
                                  ),
                              )
                            ],
                          ),
                          ],
                      ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Column(
                        children: [
                        Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Kommentare',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                                ),
                              ),
                            ]
                          ),
                          const SizedBox(
                            width: 10,
                            height: 10,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 320,
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Schreibe einen Kommentar...',
                                    ),
                                    onChanged: (value) {
                                        comment = value;
                                    },
                                  ),
                                ),
                              ]
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blueAccent
                                  ),
                                  onPressed: () => commentSendPress(),
                                  child: const Text('Kommentar hinzufügen'))
                            ],
                          ),
                          Column(
                              children: [ FutureBuilder(
                                future: this._memoizer.runOnce(() => getComments()),
                                builder: (context, AsyncSnapshot snapshot){
                                  if(snapshot.data != null) {
                                    return ListView.builder(
                                        physics: const NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: _comments.length,
                                        itemBuilder: (context, i) {
                                          final int userId = _comments[i].userId;
                                          final int index = _users.indexWhere((user) => user.id == userId);
                                          if (_comments[i].userId != null) {
                                            return Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .circular(10),
                                              ),
                                              child: Column(
                                                children: [ListTile(
                                                  title: Text(
                                                  _users[index].username,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                                subtitle:
                                                Text(
                                                  DateFormat('EEEE, dd.MM.yyyy HH:mm', 'de_DE').format(DateTime.parse(_comments[i].createdAt)) + ' Uhr',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      const Padding(padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),),
                                                      Flexible(child: Text(_comments[i].content, softWrap: true,))
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  )
                                                ]
                                              ),
                                            );
                                          }else{
                                            return Card(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .circular(10),
                                              ),
                                              child: Column(
                                              children: [ListTile(
                                                title: const Text('System',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                                subtitle:
                                                Text(
                                                  DateFormat('EEEE, dd.MM.yyyy HH:mm', 'de_DE').format(DateTime.parse(_comments[i].createdAt)) + ' Uhr',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                ),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      const Padding(padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),),
                                                      Flexible(child: Text(_comments[i].content, softWrap: true,))
                                                      ],
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                )
                                              ]
                                              ),
                                            );
                                          }
                                        }
                                    );
                                  }
                                  else {return const Text('Lädt....');}
                                },
                              ),
                              ]
                          ),
                    ],
                    ),
                  ),
                )
              ],
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