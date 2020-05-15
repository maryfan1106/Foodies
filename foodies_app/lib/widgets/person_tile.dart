import 'package:flutter/material.dart';
import 'package:meta/meta.dart' show required;

class PersonTile extends StatelessWidget {
  final String name;
  final String initials;
  final Image avatar;
  final Color bgColor;

  PersonTile({
    @required this.name,
    this.avatar,
  })  : this.initials = _getInitials(name),
        bgColor = _getColor(name);

  static String _getInitials(String s) {
    // only return up to the first two initials
    return s
        .split(new RegExp(r'\s+'))
        .fold('', (curr, elem) => curr.length >= 2 ? curr : curr + elem[0]);
  }

  static Color _getColor(String s) => Color(s.hashCode | 0xff000000);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      leading: CircleAvatar(
        child: Text(initials),
        backgroundColor: avatar ?? bgColor,
      ),
    );
  }
}
