import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show DotEnv;
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/home_screen.dart' show HomeScreen;
import 'pages/login_screen.dart' show LoginScreen;
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
        primarySwatch: Colors.blue,
        accentColor: Colors.deepPurpleAccent,
      ),
      home: _routeHome(),
      routes: {
        '/register': (_) => RegisterScreen(),
        '/login': (_) => LoginScreen(),
        '/home': (_) => HomeScreen(),
      },
    );
  }
}
