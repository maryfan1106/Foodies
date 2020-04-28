import 'package:flutter/material.dart';

import '../models/eventbrief.dart' show EventBrief;

class Events extends StatelessWidget {
  final List<EventBrief> events;

  const Events({
    @required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: events.length,
      itemBuilder: (BuildContext context, int index) {
        final EventBrief event = events[index];
        return GestureDetector(
          child: Card(
            child: ListTile(
              title: Center(child: Text(event.name)),
              subtitle: Center(child: Text(event.timestamp.toString())),
            ),
          ),
        );
      },
    );
  }
}
