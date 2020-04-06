import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodiesapp/models/bias_model.dart';
import 'package:foodiesapp/models/event_details_model.dart';
import 'package:foodiesapp/widgets/biases_display.dart';
import 'package:foodiesapp/widgets/event_details_display.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  SharedPreferences sharedPreferences;
  List<Bias> _biases;

  getEventDetails() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final client = http.Client();
    final request = new http.Request('GET', Uri.parse("http://localhost:3000/categories"));
    request.headers['Authorization'] = "Bearer " + sharedPreferences.getString("token");
    request.headers['Accept'] = "application/json";
    request.headers['Content-type'] = "application/json";
    request.followRedirects = false;
    final response = await client.send(request);
    final respStr = await response.stream.bytesToString();
    var jsonResponse = jsonDecode(respStr);
    List<Bias> biases = jsonResponse.map<Bias>((i) => Bias.fromJson(i)).toList();
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
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
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