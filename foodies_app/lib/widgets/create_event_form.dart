import 'package:flutter/material.dart';

import '../models/user.dart' show User;
import '../services/create_event.dart' show createEvent;
import '../widgets/add_attendees.dart' show AddAttendees;

class CreateEventForm extends StatefulWidget {
  @override
  _CreateEventFormState createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  int _budget = 2;
  List<User> _attendees = [];

  addNewAttendee(User attendee) {
    List<User> attendees = _attendees;
    attendees.add(attendee);
    setState(() {
      _attendees = attendees;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Event Name',
                contentPadding: EdgeInsets.all(20.0),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter event name';
                }
                setState(() {
                  _name = value;
                });
                return null;
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: const Text(
                  'Price Range',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            ButtonBar(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RaisedButton(
                  color: _budget == 1 ? Colors.green[100] : null,
                  child: Text('\$'),
                  onPressed: () {
                    setState(() {
                      _budget = 1;
                    });
                  },
                ),
                RaisedButton(
                  color: _budget == 2 ? Colors.green[300] : null,
                  child: Text('\$\$'),
                  onPressed: () {
                    setState(() {
                      _budget = 2;
                    });
                  },
                ),
                RaisedButton(
                  color: _budget == 3 ? Colors.green[500] : null,
                  child: Text('\$\$\$'),
                  onPressed: () {
                    setState(() {
                      _budget = 3;
                    });
                  },
                ),
              ],
            ),
            AddAttendees(attendees: _attendees, addNewAttendee: addNewAttendee),
            RaisedButton(
              onPressed: () async {
                bool posted = await createEvent(_name, _budget, _attendees);
                if (posted) {
                  print("successfully created event");
                } else {
                  print("failed to create event");
                }
                Navigator.pop(context);
              },
              child: const Text(
                'Create Event',
              ),
            )
          ],
        ),
      ),
    );
  }
}
