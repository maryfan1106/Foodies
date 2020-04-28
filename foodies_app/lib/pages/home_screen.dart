import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/eventbrief.dart' show EventBrief;
import '../services/events.dart' show getEventsAttending, getEventsOrganizing;
import '../widgets/events.dart' show Events;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final Map<String, Future<List<EventBrief>>> events = {
    'Attending': getEventsAttending(),
    'Organizing': getEventsOrganizing(),
  };

  static const List<Tab> _tabs = [
    Tab(text: 'Attending'),
    Tab(text: 'Organizing'),
  ];

  TabController _tabController;

  static Widget _makeTab(String text, Future<List<EventBrief>> future) {
    return FutureBuilder(
      future: future,
      builder:
          (BuildContext context, AsyncSnapshot<List<EventBrief>> snapshot) {
        if (snapshot.hasData) {
          return Events(events: snapshot.data);
        }

        if (snapshot.hasError) {
          print(snapshot.error);
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void logOut(BuildContext context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.remove('token');

    Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () => logOut(context),
        ),
        title: const Text('Events'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // TODO: Navigate to ProfilePage
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        tooltip: 'Create new event',
        onPressed: () {
          // TODO: Navigate to CreateEventPage
        },
      ),
      body: TabBarView(
        controller: _tabController,
        children: _tabs.map((tab) {
          String label = tab.text;
          return _makeTab(label, events[label]);
        }).toList(),
      ),
    );
  }
}
