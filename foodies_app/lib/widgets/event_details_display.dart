import 'package:Foodies/services/locale.dart';
import 'package:flutter/material.dart';

import '../models/eventdetail.dart' show EventDetail;
import '../pages/restaurant_voting_screen.dart' show RestaurantVotingScreen;
import '../services/votes.dart' show getVote;
import 'event_attendees.dart' show EventAttendees;

class EventDetailsDisplay extends StatelessWidget {
  final EventDetail details;

  const EventDetailsDisplay({
    @required this.details,
  });

  Widget _voteStatus() {
    return FutureBuilder(
      future: getVote(details.eid),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        Widget body;

        if (snapshot.hasData) {
          if (snapshot.data) {
            body = const Text('Waiting for Result');
          } else {
            body = RaisedButton(
              child: Text('Vote for Restaurant'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RestaurantVotingScreen(
                      eid: details.eid,
                      restaurants: details.restaurants,
                    ),
                  ),
                );
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
    return Column(
      children: <Widget>[
        Card(
          child: ListTile(
            title: Center(child: Text('Hosted by: ' + details.host.name)),
            subtitle: Center(
              child: Text(formatTimestamp(details.timestamp)),
            ),
          ),
        ),
        EventAttendees(attendees: details.guests),
        Container(
          height: 90.0,
          child: Center(child: _voteStatus()),
        ),
      ],
    );
  }
}
