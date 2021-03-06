import 'package:flutter/material.dart';

import '../models/attendee.dart' show Attendee;
import '../models/eventdetail.dart' show EventDetail;
import '../pages/restaurant_voting_screen.dart' show RestaurantVotingScreen;
import '../services/locale.dart' show formatTimestamp;
import '../services/votes.dart' show getVote;
import '../widgets/person_tile.dart' show PersonTile;
import 'event_attendees.dart' show EventAttendees;

class EventDetailsDisplay extends StatefulWidget {
  final EventDetail details;

  const EventDetailsDisplay({
    @required this.details,
  });

  _EventDetailsDisplayState createState() => new _EventDetailsDisplayState();
}

class _EventDetailsDisplayState extends State<EventDetailsDisplay> {
  Widget _voteStatus() {
    return FutureBuilder(
      future: getVote(widget.details.eid),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        Widget body;

        if (snapshot.hasData) {
          if (snapshot.data) {
            body = const Text('Waiting for Result');
          } else {
            body = RaisedButton(
              child: const Text('Vote for Restaurant'),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RestaurantVotingScreen(
                      eid: widget.details.eid,
                      restaurants: widget.details.restaurants,
                    ),
                  ),
                );

                setState(() {});
              },
            );
          }
        } else {
          body = const CircularProgressIndicator();
        }
        return Container(height: 90, child: Center(child: body));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Attendee _host = widget.details.host;

    return Column(
      children: <Widget>[
        Card(
          child: ListTile(
            title: Center(
              child: Column(
                children: <Widget>[
                  const Text('Hosted by:'),
                  PersonTile(person: _host)
                ],
              ),
            ),
            subtitle: Center(
              child: Text(formatTimestamp(widget.details.timestamp)),
            ),
          ),
        ),
        Expanded(
          child: EventAttendees(attendees: widget.details.guests),
        ),
        Container(
          height: 90.0,
          child: Center(child: _voteStatus()),
        ),
      ],
    );
  }
}
