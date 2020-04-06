import 'package:flutter/material.dart';

import '../widgets/add_attendees.dart';

class CreateEventForm extends StatefulWidget {
  @override
  _CreateEventFormState createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  double price = 50;
  final _formKey = GlobalKey<FormState>();

//  Event newEvent = Event(host: currentUser, eventRestaurants: []);
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Event Name',
                contentPadding: const EdgeInsets.all(20.0)),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter event name';
              }
              return null;
            },
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Price Range',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          Slider(
            value: price,
            onChanged: (newPrice) {
              setState(() => price = newPrice);
            },
            divisions: 4,
            min: 0,
            max: 100,
          ),
          AddAttendees(),
          RaisedButton(
            color: Colors.blue,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                // TODO: create the event
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
