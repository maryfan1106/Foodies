import 'package:flutter/material.dart';
import 'package:foodiesapp/models/event_details_model.dart';
import 'package:foodiesapp/pages/restaurant_voting_screen.dart';
import 'package:foodiesapp/widgets/event_attendees.dart';

class EventDetailsDisplay extends StatelessWidget {
  final EventDetails details;

  EventDetailsDisplay({
    this.details,
  });

  @override
  Widget build(BuildContext context) {
    if (details == null) {
      return CircularProgressIndicator();
    }

    // TODO: host is becomes N/A after pop because it was removed
    var host = details.attendees.firstWhere(
      (i) => i.role == 0,
      orElse: () => Attendee(role: 0, name: 'N/A', email: 'N/A'),
    );
    details.attendees.removeWhere((i) => i.role == 0);

    return Column(
      children: <Widget>[
        Card(
          child: ListTile(
            title: Center(child: Text('Hosted by: ' + host.name)),
            subtitle: Center(child: Text(details.timestamp)),
          ),
        ),
        EventAttendees(attendees: details.attendees),
        Container(
          height: 90.0,
          child: Center(
            child: RaisedButton(
              child: Text(
                'Vote for Restaurant',
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RestaurantVotingScreen(
                      restaurants: details.restaurants,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
