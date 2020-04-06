import 'package:meta/meta.dart' show required;

import 'attendee.dart' show Attendee, AttendeeRole;
import 'restaurant.dart' show Restaurant;

class EventDetail {
  final int eid;
  final String name;
  final DateTime timestamp;
  final int budget;
  final Attendee host;
  final List<Attendee> guests;
  final List<Restaurant> restaurants;

  const EventDetail({
    @required this.eid,
    @required this.name,
    @required this.timestamp,
    @required this.budget,
    @required this.host,
    @required this.guests,
    @required this.restaurants,
  });

  static EventDetail fromJson(dynamic parsedJson) {
    final List<Restaurant> restaurantList =
        (parsedJson['restaurants'] as List).map(Restaurant.fromJson).toList();

    final Iterable<Attendee> attending =
        (parsedJson['attendees'] as List).map(Attendee.fromJson);

    return EventDetail(
      eid: parsedJson['eid'],
      name: parsedJson['name'],
      timestamp: DateTime.parse(parsedJson['timestamp']),
      budget: parsedJson['budget'],
      host: attending.singleWhere((i) => i.role == AttendeeRole.host),
      guests: attending.where((i) => i.role == AttendeeRole.guest).toList(),
      restaurants: restaurantList,
    );
  }
}
