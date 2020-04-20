import 'dart:convert';
import 'package:foodiesapp/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CreateEventService {
  final String _baseUrl = 'http://localhost:3000';

  Future<User> validateEmail(String email) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final client = http.Client();
    try {
      final request = new http.Request('GET', Uri.parse("$_baseUrl/users/$email"));
      request.headers['Authorization'] = "Bearer " + sharedPreferences.getString("token");
      request.headers['Accept'] = "application/json";
      request.headers['Content-type'] = "application/json";
      request.followRedirects = false;
      final response = await client.send(request);
      final respStr = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(respStr);
      User user = new User.fromJson(jsonResponse);
      return user;
    } catch (e) {
     return null;
    }
  }

}