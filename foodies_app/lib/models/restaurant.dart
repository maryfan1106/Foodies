import 'package:meta/meta.dart' show required;

class Restaurant {
  final int camis;
  final String name;
  final String address;
  final int phone;
  final String description;
  final int votes;

  const Restaurant({
    @required this.camis,
    @required this.name,
    @required this.address,
    @required this.phone,
    @required this.description,
    @required this.votes,
  });

  static Restaurant fromJson(dynamic parsedJson) {
    return Restaurant(
      camis: parsedJson['camis'],
      name: parsedJson['name'],
      address: parsedJson['address'],
      phone: parsedJson['phone'],
      description: parsedJson['description'],
      votes: parsedJson['votes'],
    );
  }
}
