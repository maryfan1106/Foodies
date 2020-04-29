import 'dart:io' show HttpStatus;

import 'foodiesapi.dart' show FoodiesData, foodiesGet, foodiesPost;

Future<bool> getVote(int eid) async {
  final FoodiesData fdata = await foodiesGet('/events/$eid/vote');
  // TODO: better error handling
  return fdata.body['camis'] != null;
}

Future<bool> voteForRestaurant(int eid, int camis) async {
  final FoodiesData fdata =
      await foodiesPost('/events/$eid/vote', data: {'camis': camis});

  switch (fdata.status) {
    case HttpStatus.created:
      return true;
      break;
  }

  return false;
}
