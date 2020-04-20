import 'dart:convert';
import 'package:foodiesapp/models/event_details_model.dart';
import 'package:foodiesapp/models/event_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EventService {
  final String _baseUrl = 'http://localhost:3000';

  Future<List<Event>> getAllEvents(String role) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final client = http.Client();
    try {
      final request = new http.Request(
          'GET', Uri.parse("$_baseUrl/events/$role"));
      request.headers['Authorization'] =
          "Bearer " + sharedPreferences.getString("token");
      request.headers['Accept'] = "application/json";
      request.headers['Content-type'] = "application/json";
      request.followRedirects = false;
      final response = await client.send(request);
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

  Future<EventDetails> getEventDetails(int eid) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final client = http.Client();
    try {
      final request = new http.Request(
          'GET', Uri.parse("$_baseUrl/events/$eid"));
      request.headers['Authorization'] =
          "Bearer " + sharedPreferences.getString("token");
      request.headers['Accept'] = "application/json";
      request.headers['Content-type'] = "application/json";
      request.followRedirects = false;
      final response = await client.send(request);
      final responseStr = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseStr);
      EventDetails eventDetails = new EventDetails.fromJson(jsonResponse);
      return eventDetails;
    } catch (e) {
      return null;
    } finally {
      client.close();
    }
  }

  Future<bool> getVote(int eid) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final client = http.Client();
    try {
      final request = new http.Request(
          'GET', Uri.parse("$_baseUrl/events/$eid/vote"));
      request.headers['Authorization'] =
          "Bearer " + sharedPreferences.getString("token");
      request.headers['Accept'] = "application/json";
      request.headers['Content-type'] = "application/json";
      request.followRedirects = false;
      final response = await client.send(request);
      return response.statusCode == 302;
    } catch (e) {
      return false;
    } finally {
      client.close();
    }
  }

  Future<bool> voteForRestaurant(int eid, int camis) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      var response = await http.post("$_baseUrl/events/$eid/vote", body: jsonEncode({"camis" : camis}),
          headers: {
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