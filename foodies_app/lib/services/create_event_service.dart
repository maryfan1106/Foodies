import 'dart:convert';

import 'package:foodiesapp/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreateEventService {
  final String _baseUrl = 'http://localhost:3000';

  Future<User> validateEmail(String email) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final client = http.Client();
    try {
      final request =
          new http.Request('GET', Uri.parse("$_baseUrl/users/$email"));
      request.headers['Authorization'] =
          "Bearer " + sharedPreferences.getString("token");
      request.headers['Accept'] = "application/json";
      request.headers['Content-type'] = "application/json";
      request.followRedirects = false;
      final response = await client.send(request);
      if (response.statusCode == 404) {
        return null;
      }
      final respStr = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(respStr);
      User user = new User.fromJson(jsonResponse);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<bool> createEvent(
    String name,
    int budget,
    List<User> attendees,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> emails = attendees.map((attendee) => attendee.email).toList();
    Map<String, dynamic> event = {
      "name": name,
      "timestamp": DateTime.now(),
      "budget": budget,
      "attendees": emails,
    };
    //TODO: it doesn't actually create the event
    try {
      var response = await http
          .post("$_baseUrl/events/", body: jsonEncode(event), headers: {
        "Accept": "application/json",
        "Content-type": "application/json",
        "Authorization": "Bearer " + sharedPreferences.getString("token")
      });
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}
