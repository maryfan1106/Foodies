import 'package:flutter/material.dart';

import '../models/eventdetail.dart' show EventDetail;
import 'event_attendees.dart' show EventAttendees;

class EventDetailsDisplay extends StatelessWidget {
  final EventDetail details;

  const EventDetailsDisplay({
    @required this.details,
  });

  Widget _voteStatus(BuildContext context) {
    return RaisedButton(
      child: Text('Vote for Restaurant'),
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          child: ListTile(
            title: Center(child: Text('Hosted by: ' + details.host.name)),
            subtitle: Center(child: Text(details.timestamp.toString())),
          ),
        ),
        EventAttendees(attendees: details.guests),
        Container(
          height: 90.0,
          child: Center(child: _voteStatus(context)),
        ),
      ],
    );
  }
}
