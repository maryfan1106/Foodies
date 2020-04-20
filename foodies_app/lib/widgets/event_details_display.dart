import 'package:flutter/material.dart';
import 'package:foodiesapp/models/event_details_model.dart';
import 'package:foodiesapp/pages/restaurant_voting_screen.dart';
import 'package:foodiesapp/widgets/event_attendees.dart';

class EventDetailsDisplay extends StatelessWidget {
  final EventDetails details;
  final bool voted;
  EventDetailsDisplay({
    this.details,
    this.voted
  });

  @override
  Widget build(BuildContext context) {
    if (details == null) {
      return CircularProgressIndicator();
    }

    Attendee host = details.attendees.firstWhere((i) => i.role == 0);
    List<Attendee> guests = details.attendees.where((i) => i.role == 1).toList();

    return Column(
      children: <Widget>[
          Card(
              child: ListTile(
                title: Center(child: Text('Hosted by: ' + host.name)),
                subtitle: Center(child: Text(details.timestamp)),
              )
          ),
        EventAttendees(attendees: guests),
        Container(
          height: 90.0,
          child: Center(
              child: voted ? Text(
                'Waiting for Result',
                ) : RaisedButton(
                child: Text(
                  'Vote for Restaurant',
                ),
                onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RestaurantVotingScreen(eid: details.eid, restaurants: details.restaurants)),
                    );
                },
              )
          ),
        ),
      ],
    );
  }
}