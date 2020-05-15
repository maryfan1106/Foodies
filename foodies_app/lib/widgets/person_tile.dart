import 'package:flutter/material.dart';
import 'package:meta/meta.dart' show required;

import '../models/attendee.dart' show Attendee;

class PersonTile extends StatelessWidget {
  final Attendee person;

  final String initials;
  final Image avatar;
  final Color bgColor;

  PersonTile({
    @required this.person,
    this.avatar,
  })  : this.initials = _getInitials(person.name),
        bgColor = _getColor(person.name);

  static String _getInitials(String s) {
    // only return up to the first two initials
    return s
        .split(new RegExp(r'\s+'))
        .fold('', (curr, elem) => curr.length >= 2 ? curr : curr + elem[0]);
  }

  static Color _getColor(String s) => Color(s.hashCode | 0xff000000);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(person.name),
        subtitle: Text(person.email),
        leading: CircleAvatar(
          child: Text(initials),
          backgroundColor: avatar ?? bgColor,
        ),
      ),
    );
  }
}
