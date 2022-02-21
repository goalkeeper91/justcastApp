import 'dart:convert';

import 'package:http/http.dart' as http;
import 'globals.dart';

class MatchServices {
  static Future<http.Response> requestMatch(
  int? game,
  int? event,
  int user,
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

  static Future<http.Response> comments(int match) async {
    Map data = {
      'match':match,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'match/comments');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }

  static Future<http.Response> comment(String content, String user, int match) async {
    Map data = {
      'match':match,
      'content':content,
      'user':user
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'match/comment');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }

  static Future<http.Response> acceptCaster(int match) async {
    Map data = {
      'match':match
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'match/acceptCaster');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }

  static Future<http.Response> accept(int match, String username) async {
    Map data = {
      'match':match,
      'username':username
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'match/accept');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }

  static Future<http.Response> cancel(int match) async {
    Map data = {
      'match':match
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'match/cancel');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }

  static Future<http.Response> payed(int match) async {
    Map data = {
      'match':match
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'match/payed');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }

  static Future<http.Response> setRequest(int match, String username) async {
    Map data = {
      'match':match,
      'username':username
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'match/setRequested');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }

  static Future<http.Response> denieCast(int match) async {
    Map data = {
      'match':match
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'match/denieCast');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }

  static Future<http.Response> payedMatch(int match) async {
    Map data = {
      'match':match
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'match/payedMatches');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }

  static Future<http.Response> decline(int match, String username) async {
    Map data = {
      'match':match,
      'username':username
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'match/decline');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }
}