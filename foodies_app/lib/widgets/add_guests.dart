import 'package:flutter/material.dart';

import '../models/attendee.dart' show Attendee;
import '../services/users.dart' show getUser;
import '../widgets/person_tile.dart' show PersonTile;

class AddGuests extends StatefulWidget {
  final List<Attendee> guests;

  const AddGuests({
    @required Key key,
    @required this.guests,
  }) : super(key: key);

  @override
  AddGuestsState createState() => AddGuestsState();
}

class AddGuestsState extends State<AddGuests> {
  final _emailField = TextField(
    controller: TextEditingController(),
    obscureText: false,
    decoration: const InputDecoration(
      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      hintText: 'Attendee Email',
    ),
  );

  void _addNewGuest(Attendee guest) => setState(() => widget.guests.add(guest));

  @override
  void dispose() {
    _emailField.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addButton = RaisedButton(
      child: const Text('Add Attendee'),
      onPressed: () async {
        Attendee result = await getUser(_emailField.controller.text);
        _addNewGuest(result);
        _emailField.controller.clear();
      },
    );

    return Column(
      children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.guests.length,
          itemBuilder: (context, index) {
            final Attendee guest = widget.guests[index];
            return PersonTile(
              person: guest,
            );
          },
        ),
        const SizedBox(height: 15.0),
        _emailField,
        const SizedBox(height: 25.0),
        addButton,
      ],
    );
  }
}
