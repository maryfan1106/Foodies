import 'dart:math' as math;

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

class TabData {
  final String name;
  final Function getData;
  final Tab tab;
  Future<List<EventBrief>> future;

  TabData({
    @required this.name,
    @required this.getData,
    @required Widget icon,
  })  : future = getData(),
        tab = Tab(text: name, icon: icon);

  Future<List<EventBrief>> refresh() => future = getData();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final List<TabData> _events = [
    TabData(
      name: 'Attending',
      getData: getEventsAttending,
      icon: Transform.rotate(
        angle: math.pi,
        child: const Icon(Icons.call_merge),
      ),
    ),
    TabData(
      name: 'Organizing',
      getData: getEventsOrganizing,
      icon: const Icon(Icons.call_split),
    ),
  ];

  TabController _tabController;

  Widget makeTab(TabData tabData) {
    return FutureBuilder(
      future: tabData.future,
      builder:
          (BuildContext context, AsyncSnapshot<List<EventBrief>> snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
            onRefresh: () async {
              await tabData.refresh();
              setState(() {});
            },
            child: Events(events: snapshot.data),
          );
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
          icon: Transform.rotate(
            angle: math.pi,
            child: const Icon(Icons.exit_to_app),
          ),
          onPressed: () => logOut(context),
        ),
        title: const Text('Events'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: _events.map((e) => e.tab).toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        tooltip: 'Create new event',
        onPressed: () async {
          final needUpdate = await Navigator.pushNamed(context, '/create');
          if (needUpdate ?? false) {
            _events.firstWhere((e) => e.name == 'Organizing').refresh();
          }
        },
      ),
      body: TabBarView(
        controller: _tabController,
        children: _events.map((e) => makeTab(e)).toList(),
      ),
    );
  }
}
