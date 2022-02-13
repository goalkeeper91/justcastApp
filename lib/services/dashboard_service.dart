import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:justcast_app/services/globals.dart';

class DashboardService {
  static Future<http.Response> dashboard(
      String username
      ) async {
    Map data = {
      "username":username,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + 'auth/dashboard');
    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    print(response.body);
    return response;
  }
}