import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../models/user.dart' show User;
import '../services/create_event.dart' show createEvent;
import '../widgets/add_attendees.dart' show AddAttendees;

class CreateEventForm extends StatefulWidget {
  @override
  _CreateEventFormState createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  DateTime _dateTime = DateTime.now();
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
            TextField(
              controller: _nameController,
              obscureText: false,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "Event name",
              ),
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
              alignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                RaisedButton(
                  color: _budget == 1 ? Colors.green : null,
                  child: Text('\$'),
                  onPressed: () {
                    setState(() {
                      _budget = 1;
                    });
                  },
                ),
                RaisedButton(
                  color: _budget == 2 ? Colors.green : null,
                  child: Text('\$\$'),
                  onPressed: () {
                    setState(() {
                      _budget = 2;
                    });
                  },
                ),
                RaisedButton(
                  color: _budget == 3 ? Colors.green : null,
                  child: Text('\$\$\$'),
                  onPressed: () {
                    setState(() {
                      _budget = 3;
                    });
                  },
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: const Text(
                  'Date and Time',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                DatePicker.showDateTimePicker(context, showTitleActions: true,
                    onConfirm: (date) {
                  setState(() {
                    _dateTime = date;
                  });
                }, currentTime: DateTime(2020, 05, 18, 3, 15, 34));
              },
              child: Text(_dateTime.toString()),
            ),
            AddAttendees(attendees: _attendees, addNewAttendee: addNewAttendee),
            RaisedButton(
              color: Theme.of(context).accentColor,
              onPressed: () async {
                bool posted = await createEvent(
                    _nameController.text, _budget, _attendees);
                if (posted) {
                  print("successfully created event");
                } else {
                  print("failed to create event");
                }
                Navigator.pop(context);
              },
              child: const Text('Create Event',
                  style: TextStyle(
                    color: Colors.white,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
