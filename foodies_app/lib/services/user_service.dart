import 'dart:convert';

import 'package:foodiesapp/models/bias_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final String _baseUrl = 'http://localhost:3000';

  Future<List<Bias>> getBiases() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final client = http.Client();
    try {
      final request =
          new http.Request('GET', Uri.parse("$_baseUrl/categories"));
      request.headers['Authorization'] =
          "Bearer " + sharedPreferences.getString("token");
      request.headers['Accept'] = "application/json";
      request.headers['Content-type'] = "application/json";
      request.followRedirects = false;
      final response = await client.send(request);
      final responseStr = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseStr);
      List<Bias> biases =
          jsonResponse.map<Bias>((i) => Bias.fromJson(i)).toList();
      return biases;
    } catch (e) {
      return [];
    } finally {
      client.close();
    }
  }

  Future<bool> setBias(int cid, int bias) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      var response = await http.put("$_baseUrl/categories/$cid",
          body: jsonEncode({"bias": bias}),
          headers: {
            "Accept": "application/json",
            "Content-type": "application/json",
            "Authorization": "Bearer " + sharedPreferences.getString("token")
          });
      return response.statusCode == 204;
    } catch (e) {
      return false;
    }
  }
}
