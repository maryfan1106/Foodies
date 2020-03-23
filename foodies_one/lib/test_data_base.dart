import 'models/restaurant_model.dart';
import 'models/user_model.dart';
import 'models/event_model.dart';

final User currentUser = User(
    id: 0,
    name: 'Mary Fan',
    image: './assets/images/sample_pfp.png'
);

final User userOne = User(
    id: 1,
    name: 'Jolyne Kujo',
    image: './assets/images/sample_pfp.png'
);

final User userTwo = User(
    id: 2,
    name: 'Bob Bobberson',
    image: './assets/images/sample_pfp.png'
);

final User userThree = User(
    id: 3,
    name: 'Justin Lee',
    image: './assets/images/sample_pfp.png'
);

final User userFour = User(
    id: 4,
    name: 'Jessica Hamilton',
    image: './assets/images/sample_pfp.png'
);

final User userFive = User(
    id: 5,
    name: 'Rachel Fisherman',
    image: './assets/images/sample_pfp.png'
);

final Restaurant restaurantOne = Restaurant(
  id: 1,
  name: 'Restaurant One',
  image: './assets/images/sample_restaurant.jpg'
);

final Restaurant restaurantTwo = Restaurant(
    id: 2,
    name: 'Restaurant Two',
    image: './assets/images/sample_restaurant.jpg'
);

final Restaurant restaurantThree = Restaurant(
    id: 3,
    name: 'Restaurant Three',
    image: './assets/images/sample_restaurant.jpg'
);

final Restaurant restaurantFour = Restaurant(
    id: 4,
    name: 'Restaurant Four',
    image: './assets/images/sample_restaurant.jpg'
);

final Restaurant restaurantFive = Restaurant(
    id: 5,
    name: 'Restaurant Five',
    image: './assets/images/sample_restaurant.jpg'
);

final Event eventOne = Event(
  name: 'Event One',
  host: currentUser,
  eventMembers: [userOne, userTwo, userThree],
  eventRestaurants: allRestaurants,
);

final Event eventTwo = Event(
  name: 'Event Two',
  host: userOne,
  eventMembers: allUsers,
  eventRestaurants: allRestaurants,
);

final Event eventThree = Event(
  name: 'Event Three',
  host: userThree,
  eventMembers: allUsers,
  eventRestaurants: allRestaurants,
);

final Event eventFour = Event(
  name: 'Event Four',
  host: userTwo,
  eventMembers: allUsers,
  eventRestaurants: allRestaurants,
);

final Event eventFive = Event(
  name: 'Event Five',
  host: userFive,
  eventMembers: allUsers,
  eventRestaurants: allRestaurants,
);

List<User> allUsers = [currentUser, userOne, userTwo, userThree, userFour, userFive];
List<Restaurant> allRestaurants = [restaurantOne, restaurantTwo, restaurantThree, restaurantFour, restaurantFive];
List<Event> allEvents = [eventOne, eventTwo, eventThree, eventFour, eventFive];
List<String> allCategories = [
  'Burgers','Pizza','Sushi','Ham','Nuts','Ramen','Halal','Curry','Korean','American','Chinese'
];