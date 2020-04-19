import 'package:meta/meta.dart';

class User {
  final String name;
  final String email;

  const User({
    @required this.name,
    @required this.email,
  });

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      name: parsedJson['name'],
      email: parsedJson['email'],
    );
  }
}
