import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodiesapp/models/event_model.dart';
import 'package:foodiesapp/pages/create_event_screen.dart';
import 'package:foodiesapp/pages/login_screen.dart';
import 'package:foodiesapp/widgets/all_events.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPreferences sharedPreferences;
  List<Event> _attending;
  List<Event> _organizing;

  getUserEvents() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()), (Route<dynamic> route) => false
      );
    }

    final client = http.Client();
    try {
      // GET /events/attending
      final getUserAttending = new http.Request('GET', Uri.parse("http://localhost:3000/events/attending"));
      getUserAttending.headers['Authorization'] = "Bearer " + sharedPreferences.getString("token");
      getUserAttending.headers['Accept'] = "application/json";
      getUserAttending.headers['Content-type'] = "application/json";
      getUserAttending.followRedirects = false;
      final attendingResponse = await client.send(getUserAttending);
      final attendingStr = await attendingResponse.stream.bytesToString();
      var jsonResponseA = jsonDecode(attendingStr);
      List<Event> attendingEvents = jsonResponseA.map<Event>((i) => Event.fromJson(i)).toList();
      // GET /events/organizing
      final getUserOrganizing = new http.Request('GET', Uri.parse("http://localhost:3000/events/organizing"));
      getUserOrganizing.headers['Authorization'] = "Bearer " + sharedPreferences.getString("token");
      getUserOrganizing.headers['Accept'] = "application/json";
      getUserOrganizing.headers['Content-type'] = "application/json";
      getUserOrganizing.followRedirects = false;
      final organizingResponse = await client.send(getUserOrganizing);
      final organizingStr = await organizingResponse.stream.bytesToString();
      var jsonResponseO = jsonDecode(organizingStr);
      List<Event> organizingEvents = jsonResponseO.map<Event>((i) => Event.fromJson(i)).toList();

      setState(() {
        _attending = attendingEvents;
        _organizing = organizingEvents;
      });

    } finally {
      client.close();
    }

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
        leading: Transform.rotate(
          angle: 180 * math.pi / 180,
          child: IconButton(
            icon: Icon(Icons.exit_to_app),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {
              sharedPreferences.clear();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (BuildContext context) => LoginScreen()), (Route<dynamic> route) => false
              );
            },
          ),
        ),
        title: Text('Events',
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
              Navigator.pushNamed(context, '/profile');
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CreateEventScreen()),
                    );
                  },
                )
            ),
          ),
          AllEvents(attending: _attending, organizing: _organizing),
        ],
      ),
    );
  }
}