import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart' show LatLng;

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
  static const Divider divider = Divider(indent: 20, endIndent: 20);
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

  void showDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Container(
        height: 256,
        child: Column(
          children: <Widget>[
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('Done'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                onDateTimeChanged: (DateTime newDT) =>
                    setState(() => _dateTime = newDT),
              ),
            ),
          ],
        ),
      ),
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
      setState(() => _location = result);
    }
  }

  void processNewEvent() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    String _name = _nameController.text;
    if (await createEvent(_name, _dateTime, _budget, _guests)) {
      print(_dateTime);
      Navigator.pop(context, true);
    } else {
      print("failed to create event");
    }
  }

  get formattedLatLong {
    final double lat = _location.latitude;
    final double long = _location.longitude;
    return 'Near \t ${lat.toStringAsFixed(4)}, ${long.toStringAsFixed(4)}';
  }

  @override
  void dispose() {
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
                decoration: const InputDecoration(
                  icon: Icon(Icons.edit),
                  border: InputBorder.none,
                ),
              ),
            ),
            divider,
            _sectionLabel("Price Range"),
            ButtonBar(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, _budgetButton).skip(1).toList(),
            ),
            divider,
            _sectionLabel("Date and Time"),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: FlatButton(
                onPressed: () => showDatePicker(context),
                child: Text(formatTimestamp(_dateTime)),
              ),
            ),
            divider,
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
                          formattedLatLong,
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
            divider,
            _sectionLabel("Attendees"),
            AddGuests(guests: _guests),
            divider,
            RaisedButton(
              color: Theme.of(context).accentColor,
              child: const Text(
                'Create Event',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: processNewEvent,
            ),
            const SizedBox(height: 25.0),
          ],
        ),
      ),
    );
  }
}
