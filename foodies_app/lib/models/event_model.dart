import 'package:meta/meta.dart';

class Event {
  final int eid;
  final String name;
  final String timestamp;
  final int budget;
  final int attendees;

  const Event({
    @required this.eid,
    @required this.name,
    @required this.timestamp,
    @required this.budget,
    @required this.attendees,
  });

  factory Event.fromJson(Map<String, dynamic> parsedJson) {
    return Event(
      eid: parsedJson['eid'],
      name: parsedJson['name'],
      timestamp: parsedJson['timestamp'],
      budget: parsedJson['budget'],
      attendees: parsedJson['attendees'],
    );
  }
}
