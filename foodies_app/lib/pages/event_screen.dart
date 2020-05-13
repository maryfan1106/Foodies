import 'package:flutter/material.dart';

import '../models/eventdetail.dart' show EventDetail;
import '../services/events.dart' show getEventDetails;
import '../widgets/event_details_display.dart' show EventDetailsDisplay;

class EventScreen extends StatefulWidget {
  final String name;
  final int eid;

  const EventScreen({
    @required this.name,
    @required this.eid,
  });

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getEventDetails(widget.eid),
      builder: (BuildContext context, AsyncSnapshot<EventDetail> snapshot) {
        Widget body;
        if (snapshot.hasData) {
          body = EventDetailsDisplay(details: snapshot.data);
        } else if (snapshot.hasError) {
          body = Text(snapshot.error.toString(),
              style: const TextStyle(color: Colors.red));
        } else {
          body = const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.name),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.more_horiz),
                iconSize: 30.0,
                color: Colors.white,
                onPressed: () {},
              ),
            ],
          ),
          body: body,
        );
      },
    );
  }
}
