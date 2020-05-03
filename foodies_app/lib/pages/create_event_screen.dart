import 'package:flutter/material.dart';

import '../widgets/create_event_form.dart';

class CreateEventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Event',
        ),
      ),
      body: CreateEventForm(),
    );
  }
}
