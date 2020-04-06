import 'package:meta/meta.dart' show required;

enum AttendeeRole {
  host,
  guest,
}

class Attendee {
  final AttendeeRole role;
  final String name;
  final String email;

  const Attendee({
    @required this.role,
    @required this.name,
    @required this.email,
  });

  static Attendee fromJson(dynamic parsedJson) {
    return Attendee(
      role: AttendeeRole.values[parsedJson['role'] ?? 1], // default to guest
      name: parsedJson['name'],
      email: parsedJson['email'],
    );
  }
}
