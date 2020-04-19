import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodiesapp/models/bias_model.dart';
import 'package:foodiesapp/widgets/biases_display.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  SharedPreferences sharedPreferences;
  List<Bias> _biases;

  getEventDetails() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final client = http.Client();
    final request = new http.Request(
      'GET',
      Uri.parse("http://localhost:3000/categories"),
    );
    request.headers['Authorization'] =
        "Bearer " + sharedPreferences.getString("token");
    request.headers['Accept'] = "application/json";
    request.headers['Content-type'] = "application/json";
    request.followRedirects = false;
    final response = await client.send(request);
    final respStr = await response.stream.bytesToString();
    final jsonResponse = jsonDecode(respStr);
    final List<Bias> biases =
        jsonResponse.map<Bias>((i) => Bias.fromJson(i)).toList();
    setState(() {
      _biases = biases;
    });
  }

  @override
  void initState() {
    super.initState();
    getEventDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_horiz),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: BiasesDisplay(biases: _biases),
    );
  }
}
