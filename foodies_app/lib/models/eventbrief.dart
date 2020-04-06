import 'package:meta/meta.dart' show required;

class EventBrief {
  final int eid;
  final String name;
  final DateTime timestamp;
  final int budget;
  final int numAttending;

  const EventBrief({
    @required this.eid,
    @required this.name,
    @required this.timestamp,
    @required this.budget,
    @required this.numAttending,
  });

  static EventBrief fromJson(dynamic parsedJson) {
    return EventBrief(
      eid: parsedJson['eid'],
      name: parsedJson['name'],
      timestamp: DateTime.parse(parsedJson['timestamp']),
      budget: parsedJson['budget'],
      numAttending: parsedJson['numAttending'],
    );
  }
}
