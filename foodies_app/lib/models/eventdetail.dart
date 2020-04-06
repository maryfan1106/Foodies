import 'package:meta/meta.dart' show required;

class EventDetail {
  final int eid;
  final String name;
  final DateTime timestamp;
  final int budget;

  const EventDetail({
    @required this.eid,
    @required this.name,
    @required this.timestamp,
    @required this.budget,
  });

  static EventDetail fromJson(dynamic parsedJson) {
    return EventDetail(
      eid: parsedJson['eid'],
      name: parsedJson['name'],
      timestamp: DateTime.parse(parsedJson['timestamp']),
      budget: parsedJson['budget'],
    );
  }
}
