import 'foodiesapi.dart' show FoodiesData, foodiesGet;

Future<bool> getVote(int eid) async {
  final FoodiesData fdata = await foodiesGet('/events/$eid/vote');
  // TODO: better error handling
  return fdata.body['camis'] != null;
}
