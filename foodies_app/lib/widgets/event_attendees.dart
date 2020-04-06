import 'package:flutter/material.dart';
import 'package:foodiesapp/models/event_details_model.dart';

class EventAttendees extends StatelessWidget {
  final List<Attendee> attendees;

  EventAttendees({
    this.attendees,
  });

  @override
  Widget build(BuildContext context) {
    if (attendees == null) {
      return CircularProgressIndicator();
    }
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
