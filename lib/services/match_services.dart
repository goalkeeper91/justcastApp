import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'globals.dart';

class MatchServices {
  static Future<http.Response> requestMatch(
  int? game,
  int? event,
  String user,
  String caster,
  String team,
  String enemy,
  String matchlink,
  String infos,
  DateTime scheduledfor,
  bool isexclusive
      ) async {
    Map data = {
      "game_id":game,
      "event_id":event,
      "user":user,
      "caster":caster,
      "team":team,
      "enemy":enemy,
      "matchlink":matchlink,
      "infos":infos,
      "scheduled_for":scheduledfor.toIso8601String(),
      "isexclusive":isexclusive
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'match/request');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }

  static Future<http.Response> detailMatch(int? id, int? game, int? event) async {
    Map data = {
      'id':id,
      'game':game,
      'event':event
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'match/detail');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    return response;
}
}