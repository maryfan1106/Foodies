import 'package:meta/meta.dart' show required;

import 'attendee.dart' show Attendee, AttendeeRole;

class EventDetail {
  final int eid;
  final String name;
  final DateTime timestamp;
  final int budget;
  final Attendee host;
  final List<Attendee> guests;

  const EventDetail({
    @required this.eid,
    @required this.name,
    @required this.timestamp,
    @required this.budget,
    @required this.host,
    @required this.guests,
  });

  static EventDetail fromJson(dynamic parsedJson) {
    final Iterable<Attendee> attending =
        (parsedJson['attendees'] as List).map(Attendee.fromJson);

    return EventDetail(
      eid: parsedJson['eid'],
      name: parsedJson['name'],
      timestamp: DateTime.parse(parsedJson['timestamp']),
      budget: parsedJson['budget'],
      host: attending.singleWhere((i) => i.role == AttendeeRole.host),
      guests: attending.where((i) => i.role == AttendeeRole.guest).toList(),
    );
  }
}
