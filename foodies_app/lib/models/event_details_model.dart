class EventDetails {
  final int eid;
  final String name;
  final String timestamp;
  final int budget;
  final List<Attendee> attendees;
  final List<Restaurant> restaurants;

  EventDetails({
    this.eid,
    this.name,
    this.timestamp,
    this.budget,
    this.attendees,
    this.restaurants
  });

  factory EventDetails.fromJson(Map<String, dynamic> parsedJson){
    var listA = parsedJson['attendees'] as List;
    var listR = parsedJson['restaurants'] as List;
    List<Attendee> attendeesList = listA.map<Attendee>((i) => Attendee.fromJson(i)).toList();
    List<Restaurant> restaurantList = listR.map<Restaurant>((i) => Restaurant.fromJson(i)).toList();

    return EventDetails(
        eid: parsedJson['eid'],
        name: parsedJson['name'],
        timestamp: parsedJson['timestamp'],
        budget: parsedJson['budget'],
        attendees: attendeesList,
        restaurants: restaurantList
    );
  }
}

class Attendee {
  final int role;
  final String name;
  final String email;

  Attendee({
    this.role,
    this.name,
    this.email
  });

  factory Attendee.fromJson(Map<String, dynamic> parsedJson){
    return Attendee(
        role: parsedJson['role'],
        name: parsedJson['name'],
        email: parsedJson['email']
    );
  }

}

class Restaurant {
  final int camis;
  final String name;
  final String address;
  final int phone;
  final String description;
  final int votes;

  Restaurant({
    this.camis,
    this.name,
    this.address,
    this.phone,
    this.description,
    this.votes
  });

  factory Restaurant.fromJson(Map<String, dynamic> parsedJson){
    return Restaurant(
        camis: parsedJson['camis'],
        name: parsedJson['name'],
        address: parsedJson['address'],
        phone: parsedJson['phone'],
        description: parsedJson['description'],
        votes: parsedJson['votes']
    );
  }

}