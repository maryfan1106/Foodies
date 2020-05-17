import 'package:Foodies/widgets/person_tile.dart' show PersonTile;
import 'package:flutter/material.dart';

import '../models/attendee.dart' show Attendee;

class EventAttendees extends StatelessWidget {
  final List<Attendee> attendees;

  const EventAttendees({
    @required this.attendees,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: ListView.builder(
        itemCount: attendees.length,
        itemBuilder: (BuildContext context, int index) {
          final Attendee attendee = attendees[index];
          return PersonTile(person: attendee);
        },
      ),
    );
  }
}
