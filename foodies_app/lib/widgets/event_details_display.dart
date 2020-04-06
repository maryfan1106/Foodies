import 'package:flutter/material.dart';

import '../models/eventdetail.dart' show EventDetail;

class EventDetailsDisplay extends StatelessWidget {
  final EventDetail details;

  const EventDetailsDisplay({
    @required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          child: ListTile(
            subtitle: Center(child: Text(details.timestamp.toString())),
          ),
        ),
      ],
    );
  }
}
