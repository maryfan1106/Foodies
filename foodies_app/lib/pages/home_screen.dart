import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodiesapp/models/user_model.dart';
import 'package:foodiesapp/pages/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPreferences sharedPreferences;

  getUserEvents() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }

    final client = http.Client();
    String testEmail = "test1@gmail.com";
    final request = new http.Request(
      'GET',
      Uri.parse("http://localhost:3000/users/$testEmail"),
    );
    request.headers['Authorization'] =
        "Bearer " + sharedPreferences.getString("token");
    request.headers['Accept'] = "application/json";
    request.headers['Content-type'] = "application/json";
    request.followRedirects = false;
    final response = await client.send(request);
    final respStr = await response.stream.bytesToString();
    var jsonResponse = jsonDecode(respStr);
    User user = new User.fromJson(jsonResponse);
    print(user.email);
  }

  @override
  void initState() {
    super.initState();
    getUserEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          iconSize: 30.0,
          color: Colors.white,
          onPressed: () {
            sharedPreferences.clear();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          },
        ),
        title: Text(
          'Events',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.account_circle),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {
              // TODO: Navigate to ProfilePage
              //Navigator.pushNamed(context, '/profileScreen');
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 90.0,
            child: Center(
                child: RaisedButton(
              child: Text(
                'Create New Event',
              ),
              onPressed: () {
                // TODO: Navigate to CreateEventPage
                //Navigator.push(
                //  context,
                //  MaterialPageRoute(builder: (context) => CreateEventScreen()),
                //);
              },
            )),
          ),
          //AllEvents(),
        ],
      ),
    );
  }
}
