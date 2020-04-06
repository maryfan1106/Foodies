import 'package:flutter/material.dart';

class AddAttendees extends StatefulWidget {
  @override
  AddAttendeesState createState() => AddAttendeesState();
}

class AddAttendeesState extends State<AddAttendees> {
  List<String> attendees = ["Kelly Do", "Raina Winter", "Omar Hu"];
  @override
  Widget build(BuildContext context) {
    // TODO: add and remove guests
    return ListView.builder(
      shrinkWrap: true,
      itemCount: attendees.length,
      itemBuilder: (context, index) {
        final String guest = attendees[index];
        return Card(
          child: ListTile(
            title: Text(guest),
//              onTap: () {
//                setState(() {
//                  attendees.insert(index, User());
//                });
//              },
//              onLongPress: () {
//                setState(() {
//                  attendees.removeAt(index);
//                });
//              },
          ),
        );
      },
    );
  }
}