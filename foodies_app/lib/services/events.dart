import 'dart:io' show HttpStatus;

import '../models/eventbrief.dart' show EventBrief;
import '../models/eventdetail.dart' show EventDetail;
import 'foodiesapi.dart' show FoodiesData, foodiesGet;

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
