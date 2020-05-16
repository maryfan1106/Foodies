import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:latlong/latlong.dart';

import '../models/attendee.dart' show Attendee;
import '../pages/choose_location_screen.dart' show ChooseLocationScreen;
import '../services/events.dart' show createEvent;
import '../services/locale.dart' show formatTimestamp;
import 'add_guests.dart' show AddGuests;

class CreateEventForm extends StatefulWidget {
  @override
  _CreateEventFormState createState() => _CreateEventFormState();
}

class _CreateEventFormState extends State<CreateEventForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final List<Attendee> _guests = [];
  DateTime _dateTime = DateTime.now();
  int _budget = 2;
  LatLng _location = LatLng(40.7678, -73.9647);

  Widget _budgetButton(int budget) {
    return ChoiceChip(
      selected: _budget == budget,
      selectedColor: Colors.green,
      labelStyle: const TextStyle(color: Colors.black),
      label: Text('\$' * budget),
      onSelected: (bool _) => setState(() => _budget = budget),
    );
  }

  void _chooseLocation(BuildContext context) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChooseLocationScreen(
          initialLocation: _location,
        ),
      ),
    );
    if (result != null) {
      setState(() => _location = result);
    }
  }

  void processNewEvent() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    String _name = _nameController.text;
    if (await createEvent(_name, _budget, _guests)) {
      print("successfully created event");
      Navigator.pop(context, true);
    } else {
      print("failed to create event");
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
              children: List.generate(5, _budgetButton).skip(1).toList(),
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
                DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  onConfirm: (date) => setState(() => _dateTime = date),
                );
              },
              child: Text(formatTimestamp(_dateTime)),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                child: const Text(
                  'Location',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            Text(
              _location.latitude.toString() +
                  ', ' +
                  _location.longitude.toString(),
            ),
            RaisedButton(
              child: Text(
                'choose location',
              ),
              onPressed: () {
                _chooseLocation(context);
              },
            ),
            AddGuests(guests: _guests),
            RaisedButton(
              color: Theme.of(context).accentColor,
              child: const Text('Create Event'),
              onPressed: processNewEvent,
            )
          ],
        ),
      ),
    );
  }
}
