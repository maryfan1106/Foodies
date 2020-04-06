import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodiesapp/models/event_details_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EventScreen extends StatefulWidget {
  final String name;
  final int eid;

  EventScreen({
    this.name,
    this.eid,
  });

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  SharedPreferences sharedPreferences;
  EventDetails _eventDetails;

  getEventDetails() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final client = http.Client();
    final request = new http.Request(
      'GET',
      Uri.parse("http://localhost:3000/events/${widget.eid}"),
    );
    request.headers['Authorization'] =
        "Bearer " + sharedPreferences.getString("token");
    request.headers['Accept'] = "application/json";
    request.headers['Content-type'] = "application/json";
    request.followRedirects = false;
    final response = await client.send(request);
    final respStr = await response.stream.bytesToString();
    var jsonResponse = jsonDecode(respStr);
    EventDetails eventDetails = new EventDetails.fromJson(jsonResponse);
    print(eventDetails);
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
          widget.name,
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
      body: Column(
        children: <Widget>[
//          Card(
//            child: ListTile(
//              title: Center(
//                child: Text('Hosted by: ' + widget.event.host.name),
//              ),
//            ),
//          ),
          //EventAttendees(),
          Container(
            height: 90.0,
            child: Center(
              child: RaisedButton(
                child: Text(
                  'Vote for Restaurant',
                ),
                onPressed: () {
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                      builder: (context) => RestaurantVotingScreen(),
//                    ),
//                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
