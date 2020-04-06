import 'package:flutter/material.dart';

import '../widgets/create_event_form.dart' show CreateEventForm;

class CreateEventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
      body: CreateEventForm(),
    );
  }
}
