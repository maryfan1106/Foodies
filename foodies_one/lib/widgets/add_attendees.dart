import 'package:flutter/material.dart';
import 'package:foodiesone/models/user_model.dart';

import '../test_data_base.dart';

class AddAttendees extends StatefulWidget {
  @override
  AddAttendeesState createState() => AddAttendeesState();
}

class AddAttendeesState extends State<AddAttendees> {
  List<User> attendees = allUsers;
  @override
  Widget build(BuildContext context) {
    // TODO: add and remove guests
    return Container(
      height: 600.0,
      child: ListView.builder(
        itemCount: attendees.length,
        itemBuilder: (context, index) {
          final User guest = attendees[index];
          return Card(
            child: ListTile(
              title: Text(guest.name),
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
      ),
    );
  }
}

