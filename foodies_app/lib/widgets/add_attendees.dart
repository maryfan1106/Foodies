import 'package:flutter/material.dart';
import 'package:foodiesapp/models/user_model.dart';
import 'package:foodiesapp/services/create_event_service.dart';

class AddAttendees extends StatefulWidget {
  final List<User> attendees;
  final Function(User) addNewAttendee;
  AddAttendees({Key key, @required this.attendees, this.addNewAttendee})
      : super(key: key);

  @override
  AddAttendeesState createState() => AddAttendeesState();
}

class AddAttendeesState extends State<AddAttendees> {
  final TextEditingController _emailController = TextEditingController();
  String _error = '';

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      controller: _emailController,
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Attendee Email",
      ),
    );

    final addButton = RaisedButton(
      onPressed: () async {
        User result =
            await CreateEventService().validateEmail(_emailController.text);
        if (result == null) {
          setState(() {
            _error = 'No user with that email exists';
          });
        } else {
          setState(() {
            _error = '';
          });
          widget.addNewAttendee(result);
        }
        _emailController.clear();
      },
      child: const Text(
        'Add Attendee',
      ),
    );

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.attendees.length,
            itemBuilder: (context, index) {
              final String guest = widget.attendees[index].name;
              return Card(
                child: ListTile(
                  title: Text(guest),
                ),
              );
            },
          ),
          Text(
            _error,
            style: TextStyle(color: Colors.red, fontSize: 14.0),
          ),
          const SizedBox(height: 15.0),
          emailField,
          const SizedBox(height: 25.0),
          addButton,
        ],
      ),
    );
  }
}
