import 'package:flutter/material.dart';
import 'package:foodiesone/models/event_model.dart';
import 'package:foodiesone/widgets/event_attendees.dart';
import 'package:foodiesone/widgets/event_restaurants.dart';

class EventScreen extends StatefulWidget {
  final Event event;
  EventScreen({this.event});
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.event.name,
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
          EventAttendees(),
          EventRestaurants(),
        ],
      ),
    );
  }
}
