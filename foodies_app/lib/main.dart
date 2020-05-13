import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show DotEnv;
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/create_event_screen.dart' show CreateEventScreen;
import 'pages/home_screen.dart' show HomeScreen;
import 'pages/login_screen.dart' show LoginScreen;
import "pages/profile_screen.dart" show ProfileScreen;
import 'pages/register_screen.dart' show RegisterScreen;

void main() async {
  await DotEnv().load('.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget _routeHome() {
    return FutureBuilder(
      future: SharedPreferences.getInstance(),
      builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snap) {
        if (snap.hasData) {
          return snap.data.containsKey('token') ? HomeScreen() : LoginScreen();
        }

        return const CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Foodies',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF3799D4),
        accentColor: Colors.deepPurpleAccent,
      ),
      home: _routeHome(),
      routes: {
        '/register': (_) => RegisterScreen(),
        '/login': (_) => LoginScreen(),
        '/home': (_) => HomeScreen(),
        '/profile': (_) => ProfileScreen(),
        '/create': (_) => CreateEventScreen(),
      },
    );
  }
}
