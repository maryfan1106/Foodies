import 'dart:io' show HttpStatus;

import '../models/attendee.dart' show Attendee;
import '../models/eventbrief.dart' show EventBrief;
import '../models/eventdetail.dart' show EventDetail;
import 'foodiesapi.dart' show FoodiesData, foodiesGet, foodiesPost;

Future<List<EventBrief>> _getEvents(String type) async {
  final FoodiesData fdata = await foodiesGet('/events/$type');

  switch (fdata.status) {
    case HttpStatus.found:
      final List<EventBrief> events =
          (fdata.body as List<dynamic>).map(EventBrief.fromJson).toList();
      return events;
    case HttpStatus.notFound:
      // TODO: handle better (throw fdata.body['err'], catch in futurebuilder)
      return [];
  }

  throw Exception("placeholder");
}

Future<List<EventBrief>> getEventsAttending() => _getEvents('attending');

Future<List<EventBrief>> getEventsOrganizing() => _getEvents('organizing');

Future<EventDetail> getEventDetails(int eid) async {
  final FoodiesData fdata = await foodiesGet('/events/$eid');

  switch (fdata.status) {
    case HttpStatus.found:
      final EventDetail eventDetails = EventDetail.fromJson(fdata.body);
      return eventDetails;
  }

  throw Exception('placeholder');
}

Future<bool> createEvent(String name, DateTime timestamp, int budget, List<Attendee> guests) async {
  List<String> emails = guests.map((guest) => guest.email).toList();
  Map<String, dynamic> data = {
    "name": name,
    "timestamp": timestamp.toIso8601String(),
    "budget": budget,
    "guests": emails,
  };

  final FoodiesData fd = await foodiesPost('/events', data: data);

  switch (fd.status) {
    case HttpStatus.created:
      return true;
  }

  return false;
}
