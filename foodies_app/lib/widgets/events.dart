import 'package:flutter/material.dart';

import '../models/eventbrief.dart' show EventBrief;
import '../pages/event_screen.dart' show EventScreen;
import '../services/locale.dart' show formatTimestamp;

class Events extends StatelessWidget {
  final List<EventBrief> events;

  const Events({
    @required this.events,
  });

  static const Padding _padding = Padding(padding: EdgeInsets.all(5.0));

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: events.length,
      itemBuilder: (BuildContext context, int index) {
        final EventBrief event = events[index];
        return Card(
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EventScreen(name: event.name, eid: event.eid),
              ),
            ),
            child: ListTile(
              title: Text(event.name),
              subtitle: Text(formatTimestamp(event.timestamp)),
              leading: SizedBox(
                width: 56.0,
                child: Chip(
                  label: Text('\$' * event.budget),
                ),
              ),
              trailing: Chip(
                label: Text(event.numAttending.toString()),
                avatar: const Icon(Icons.people),
              ),
            ),
          ),
        );
      },
    );
  }
}
