import 'dart:convert';
import 'package:foodiesapp/models/event_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EventService {
  final String _baseUrl = 'http://localhost:3000';

  Future<List<Event>> getAllEvents(String role) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final client = http.Client();
    try {
      final getEvents = new http.Request(
          'GET', Uri.parse("$_baseUrl/events/$role"));
      getEvents.headers['Authorization'] =
          "Bearer " + sharedPreferences.getString("token");
      getEvents.headers['Accept'] = "application/json";
      getEvents.headers['Content-type'] = "application/json";
      getEvents.followRedirects = false;
      final response = await client.send(getEvents);
      final responseStr = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseStr);
      List<Event> allEvents = jsonResponse.map<Event>((i) => Event.fromJson(i))
          .toList();
      return allEvents;
    } catch (e) {
      return [];
    } finally {
      client.close();
    }
  }

}