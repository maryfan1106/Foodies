import 'package:foodiesone/models/restaurant_model.dart';
import 'package:foodiesone/models/user_model.dart';

class Event {
  final String name;
  final User host;
  final List<User> eventMembers;
  final List<Restaurant> eventRestaurants;

  Event({
    this.name,
    this.host,
    this.eventMembers,
    this.eventRestaurants
  });
}