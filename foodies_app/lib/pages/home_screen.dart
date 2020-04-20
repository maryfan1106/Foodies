import 'package:flutter/material.dart';
import 'package:foodiesapp/models/event_model.dart';
import 'package:foodiesapp/pages/login_screen.dart';
import 'package:foodiesapp/services/event_service.dart';
import 'package:foodiesapp/widgets/all_events.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPreferences sharedPreferences;
  final EventService _eventService = EventService();
  List<Event> _attending;
  List<Event> _organizing;

  @override
  void initState() {
    super.initState();
    _checkAuth();
    _getUserEvents();
  }

  _checkAuth() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("token") == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()), (Route<dynamic> route) => false
      );
    }
  }

  _getUserEvents() async {
    List<Event> attending = await _eventService.getAllEvents('attending');
    List<Event> organizing = await _eventService.getAllEvents('organizing');
    setState(() {
      _attending = attending;
      _organizing = organizing;
    });
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
                    Navigator.pushNamed(context, '/create');
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