import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String _baseUrl = 'http://localhost:3000';

  Future<String> logIn(String email, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, String> data = {
      "email": email,
      "password": password
    };
    try {
      var response = await http.post("$_baseUrl/users/login", body: jsonEncode(data),
          headers: {
            "Accept": "application/json",
            "Content-type": "application/json",
          });
      var jsonResponse = jsonDecode(response.body);
      sharedPreferences.setString("token", jsonResponse['token']);
      return jsonResponse['token'];
    } catch (e) {
      return null;
    }
  }

  Future<String> signUp(String name, String email, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map<String, String> data = {
      'name': name,
      'email': email,
      'password': password
    };
    try {
      var response = await http.post("$_baseUrl/users/", body: jsonEncode(data),
          headers: {
            "Accept": "application/json",
            "Content-type": "application/json",
          });
      var jsonResponse = jsonDecode(response.body);
      sharedPreferences.setString("token", jsonResponse['token']);
      return jsonResponse['token'];
    } catch (e) {
      return null;
    }
  }

}