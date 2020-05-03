import 'dart:io' show HttpStatus;

import '../models/user.dart' show User;
import 'foodiesapi.dart' show FoodiesData, foodiesGet, foodiesPost;

Future<User> getUser(String email) async {
  final FoodiesData fdata = await foodiesGet('/users/$email');

  switch (fdata.status) {
    case HttpStatus.found:
      final User user = User.fromJson(fdata.body);
      return user;
  }

  throw Exception('No user found');
}

Future<bool> createEvent(String name, int budget, List<User> attendees) async {
  List<String> emails = attendees.map((attendee) => attendee.email).toList();
  Map<String, dynamic> data = {
    "name": name,
    "timestamp": DateTime.now().toIso8601String(),
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
