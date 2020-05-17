import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import '../models/attendee.dart' show Attendee;
import '../pages/choose_location_screen.dart' show ChooseLocationScreen;
import '../services/events.dart' show createEvent;
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

  Widget _sectionLabel(String section) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(
          left: 20,
          top: 20,
          right: 20,
        ),
        child: Text(
          section,
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 12.0,
          ),
        ),
      ),
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
      setState(() => {
            _location = result,
          });
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
            _sectionLabel("Event Name"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  icon: Icon(Icons.edit),
                  border: InputBorder.none,
                ),
              ),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
            ),
            _sectionLabel("Price Range"),
            ButtonBar(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, _budgetButton).skip(1).toList(),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
            ),
            _sectionLabel("Date and Time"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: DateTimePickerFormField(
                inputType: InputType.both,
                format: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
                editable: false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.event),
                ),
                onChanged: (dateTime) {
                  setState(() => _dateTime = dateTime);
                },
              ),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
            ),
            _sectionLabel("Location"),
            GestureDetector(
              onTap: () {
                _chooseLocation(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 25.0),
                child: Row(
                  children: <Widget>[
                    const Icon(
                      Icons.edit_location,
                      color: Colors.grey,
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Near \t" +
                              _location.latitude.toStringAsFixed(4) +
                              ', ' +
                              _location.longitude.toStringAsFixed(4),
                              style: TextStyle(
                    fontSize: 16.0,
                  ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              indent: 20,
              endIndent: 20,
            ),
            _sectionLabel("Attendees"),
            AddGuests(guests: _guests),
            Divider(
              indent: 20,
              endIndent: 20,
            ),
            RaisedButton(
              color: Theme.of(context).accentColor,
              child: const Text(
                'Create Event',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: processNewEvent,
            )
          ],
        ),
      ),
    );
  }
}
