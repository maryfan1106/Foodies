import 'package:flutter/material.dart';

import '../models/attendee.dart' show Attendee;
import 'add_guests.dart' show AddGuests;

class CreateEventForm extends StatefulWidget {
  @override
  _CreateEventFormState createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final List<Attendee> _guests = [];
  int _budget = 2;

  Widget _budgetButton(int budget) {
    return RaisedButton(
      color: _budget == budget ? Colors.green[300 * budget - 100] : null,
      child: Text('\$' * budget),
      onPressed: () => setState(() => _budget = budget),
    );
  }

  void processNewEvent() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
  }

  @override
  dispose() {
    super.dispose();
    _nameController.dispose();
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
              controller: _nameController,
              validator: (value) {
                return value.isEmpty ? 'Please enter an event name' : null;
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
                _budgetButton(1),
                _budgetButton(2),
                _budgetButton(3),
              ],
            ),
            AddGuests(guests: _guests),
            RaisedButton(
              child: const Text('Create Event'),
              onPressed: processNewEvent,
            )
          ],
        ),
      ),
    );
  }
}
