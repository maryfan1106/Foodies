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
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EventScreen(name: event.name, eid: event.eid),
            ),
          ),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
              child: Column(
                children: <Widget>[
                  _padding,
                  Center(
                    child: Text(
                      event.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  _padding,
                  Center(
                    child: Text(
                      '${event.numAttending} guests attending',
                      style: const TextStyle(fontSize: 12.0),
                    ),
                  ),
                  _padding,
                  Center(
                    child: Text(
                      formatTimestamp(event.timestamp),
                      style: const TextStyle(fontSize: 12.0),
                    ),
                  ),
                  _padding,
                  Center(
                    child: Text(
                      '\$' * event.budget,
                      style: const TextStyle(fontSize: 12.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
