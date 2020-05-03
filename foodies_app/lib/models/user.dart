import 'package:meta/meta.dart' show required;

class User {
  //final String name;
  final String email;

  const User({
    //@required this.name,
    @required this.email,
  });

  static User fromJson(dynamic parsedJson) {
    return User(
      //name: parsedJson['name'],
      email: parsedJson['email'],
    );
  }
}
