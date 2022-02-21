import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:justcast_app/services/globals.dart';

class AuthServices{
  static Future<http.Response> register(
      String username, String email, String password
      ) async {
    Map data = {
      "username":username,
      "email":email,
      "password":password
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL+'auth/register');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }

  static Future<http.Response> login(
      String email, String password
      ) async {
    Map data = {
      "email":email,
      "password":password
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL+'auth/login');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }

  static Future<http.Response> update(
      String user, String username, String email, String? password
      ) async {
    Map data = {
      "user":user,
      "username":username,
      "email":email,
      "password":password
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL+'user/update');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }

  static Future<http.Response> delete(
      String username
      ) async {
    Map data = {
      "username":username,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL+'user/delete');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    return response;
  }
}