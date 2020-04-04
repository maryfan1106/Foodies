import 'dart:convert' show base64Encode, utf8;
import 'dart:io' show HttpHeaders, HttpStatus;

import 'package:shared_preferences/shared_preferences.dart';

import 'foodiesapi.dart' show FoodiesData, foodiesPost;

void _setToken(String token) async {
  final SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setString('token', token);
}

Future<bool> logIn(String email, String password) async {
  final String basic = 'Basic ' + base64Encode(utf8.encode('$email:$password'));
  final FoodiesData fdata = await foodiesPost(
    '/users/login',
    headers: <String, String>{HttpHeaders.authorizationHeader: basic},
  );

  switch (fdata.status) {
    case HttpStatus.ok:
      final String token = fdata.body['token'];
      _setToken(token);
      return true;
  }

  return false;
}

Future<bool> signUp(String name, String email, String password) async {
  final Map<String, dynamic> data = {
    'name': name,
    'email': email,
    'password': password,
  };
  final FoodiesData fd = await foodiesPost('/users', data: data);

  switch (fd.status) {
    case HttpStatus.created:
      final String token = fd.body['token'];
      _setToken(token);
      return true;
  }

  return false;
}
