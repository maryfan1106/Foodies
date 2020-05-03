import 'package:flutter/material.dart';

import '../models/eventbrief.dart' show EventBrief;
import '../pages/event_screen.dart' show EventScreen;

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
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                  Center(
                    child: Text(
                      event.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                  Center(
                    child: Text(
                      event.attendees.toString() + " guests attending",
                      style: const TextStyle(fontSize: 12.0),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                  Center(
                    child: Text(
                      event.timestamp.month.toString() +
                          "/" +
                          event.timestamp.day.toString() +
                          "/" +
                          event.timestamp.year.toString() +
                          " " +
                          event.timestamp.hour.toString() +
                          ":" +
                          event.timestamp.minute.toString(),
                      style: const TextStyle(fontSize: 12.0),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                  Center(
                    child: Text(
                      "\$" * event.budget,
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
