import 'package:flutter/material.dart';
import 'package:foodiesone/models/event_model.dart';
import 'package:foodiesone/pages/event_screen.dart';
import '../test_data_base.dart';

class AllEvents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: ListView.builder(
          itemCount: allEvents.length,
          itemBuilder: (BuildContext context, int index) {
            final Event event = allEvents[index];
            return GestureDetector(
              //TODO: pass event using route
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(
                      builder: (_) => EventScreen(event: event,)
                  )
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  )
                ),
                margin: EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                            event.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                        ),
                        Text(
                          'Hosted by: ' + event.host.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
