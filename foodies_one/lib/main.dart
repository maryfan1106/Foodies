import 'package:flutter/material.dart';
import 'package:foodiesone/pages/create_event_screen.dart';
import 'package:foodiesone/pages/home_screen.dart';
import 'package:foodiesone/pages/profile_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodies',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.lightBlue,
        accentColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/profileScreen': (context) => ProfileScreen(),
        '/createEventScreen': (context) => CreateEventScreen(),
      },
    );
  }
}