import 'package:flutter/material.dart';
import 'package:foodiesapp/models/user_model.dart';
import 'package:foodiesapp/services/create_event_service.dart';
import 'package:foodiesapp/widgets/add_attendees.dart';

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
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          Slider(
            value: _budget.toDouble(),
            divisions: 3,
            min: 1,
            max: 3,
            label: _budget.toString(),
            onChanged: (newPrice) {
              setState(() => _budget = newPrice.toInt());
            },
          ),
          AddAttendees(attendees: _attendees, addNewAttendee: addNewAttendee),
          RaisedButton(
            color: Colors.blue,
            onPressed: () async {
              dynamic result = await CreateEventService()
                  .createEvent(_name, _budget, _attendees);
              if (result == null) {
                print("Error with creating event");
                Navigator.pop(context);
              } else {
                print("Created event");
                Navigator.pop(context);
              }
            },
            child: const Text(
              'Create Event',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
