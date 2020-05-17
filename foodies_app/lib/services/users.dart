import 'dart:io' show HttpStatus;

import '../models/attendee.dart' show Attendee;
import 'foodiesapi.dart' show FoodiesData, foodiesGet;

Future<Attendee> getUser(String email, Function(String) err) async {
  final FoodiesData fdata = await foodiesGet('/users/$email');
  switch (fdata.status) {
    case HttpStatus.found:
      final Attendee user = Attendee.fromJson(fdata.body);
      err(null);
      return user;
  }

  err(fdata.body['error']);
  return null;
}
