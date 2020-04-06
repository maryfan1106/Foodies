import 'package:flutter/material.dart';

import '../models/attendee.dart' show Attendee;

class EventAttendees extends StatelessWidget {
  final List<Attendee> attendees;

  const EventAttendees({
    @required this.attendees,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: attendees.length,
      itemBuilder: (BuildContext context, int index) {
        final Attendee attendee = attendees[index];
        return ListTile(
          title: Center(child: Text(attendee.name)),
        );
      },
    );
  }
}
