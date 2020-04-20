import 'package:flutter/material.dart';
import 'package:foodiesapp/models/event_details_model.dart';
import 'package:foodiesapp/services/event_service.dart';
import 'package:foodiesapp/widgets/event_details_display.dart';

class EventScreen extends StatefulWidget {
  final String name;
  final int eid;

  EventScreen({
    @required this.name,
    @required this.eid,
  });

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  EventDetails _eventDetails;
  bool _voted;

  @override
  void initState() {
    super.initState();
    _getEventDetails();
    _getVote();
  }

  _getEventDetails() async {
    EventDetails eventDetails =
        await EventService().getEventDetails(widget.eid);
    setState(() {
      _eventDetails = eventDetails;
    });
  }

  _getVote() async {
    bool voted = await EventService().getVote(widget.eid);
    setState(() {
      _voted = voted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: EventDetailsDisplay(
        details: _eventDetails,
        voted: _voted,
      ),
    );
  }
}
