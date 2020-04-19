import 'package:flutter/material.dart';
import 'package:foodiesapp/models/event_model.dart';
import 'package:foodiesapp/pages/event_screen.dart';

class AllEvents extends StatelessWidget {
  final List<Event> attending;
  final List<Event> organizing;

  const AllEvents({
    @required this.attending,
    @required this.organizing,
  });

  @override
  Widget build(BuildContext context) {
    if (attending == null || organizing == null) {
      return CircularProgressIndicator();
    }
    final List<Event> allEvents = attending + organizing;
    return Expanded(
      child: ListView.builder(
        itemCount: allEvents.length,
        itemBuilder: (BuildContext context, int index) {
          final Event event = allEvents[index];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EventScreen(
                  name: event.name,
                  eid: event.eid,
                ),
              ),
            ).then((_) {
              // TODO: Re-render AllEvents Widgets
            }),
            child: Card(
              child: ListTile(
                title: Center(child: Text(event.name)),
                subtitle: Center(child: Text(event.timestamp)),
              ),
            ),
          );
        },
      ),
    );
  }
}
