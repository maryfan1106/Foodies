import 'package:flutter/material.dart';
import 'package:foodiesone/models/event_model.dart';
import 'package:foodiesone/test_data_base.dart';
import 'add_attendees.dart';

class CreateEventForm extends StatefulWidget {
  @override
  _CreateEventFormState createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  final _formKey = GlobalKey<FormState>();
  Event newEvent = Event(host: currentUser, eventRestaurants: []);
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Event Name'
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter event name';
              }
              return null;
            },
          ),
          AddAttendees(),
          RaisedButton(
            color: Colors.blue,
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                //TODO: pass newEvent back
                print(newEvent);
              }
            },
            child: Text(
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

//final String name;
//final User host;
//final List<User> eventMembers;
//final List<Restaurant> eventRestaurants;