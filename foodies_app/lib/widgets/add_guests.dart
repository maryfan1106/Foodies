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
  String _error;
  final _emailField = TextField(
    controller: TextEditingController(),
    decoration: InputDecoration(
      icon: Icon(Icons.person_add),
      border: InputBorder.none,
    ),
  );

  void _addNewGuest(Attendee guest) => setState(() => widget.guests.add(guest));

  void _setError(String err) => setState(() => _error = err);

  Widget _errorText() {
    return Text(
      _error,
      style: TextStyle(color: Colors.red, fontSize: 14.0),
    );
  }

  @override
  void dispose() {
    _emailField.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addButton = OutlineButton(
      textColor: Theme.of(context).accentColor,
      borderSide: BorderSide(color: Theme.of(context).accentColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: const Text('INVITE'),
      onPressed: () async {
        Attendee result = await getUser(_emailField.controller.text, _setError);
        if (result != null) {
          _addNewGuest(result);
        }
        _emailField.controller.clear();
      },
    );

    return Column(
      children: <Widget>[
        if (_error != null) _errorText(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ListTile(
            title: _emailField,
            trailing: addButton,
          ),
        ),
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.guests.length,
          itemBuilder: (context, index) {
            final Attendee guest = widget.guests[index];
            return Dismissible(
              key: Key(guest.email),
              direction: DismissDirection.startToEnd,
              background: Container(
                padding: EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: const Icon(Icons.delete, color: Colors.white),
                color: Colors.red,
              ),
              child: PersonTile(
                person: guest,
              ),
              onDismissed: (_) => setState(() => widget.guests.removeAt(index)),
            );
          },
        ),
      ],
    );
  }
}
